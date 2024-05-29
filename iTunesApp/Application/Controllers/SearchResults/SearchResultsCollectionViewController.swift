//
//  SearchResultsCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

protocol SearchResultsDelegate: AnyObject {
  func selectItem(with name: String)
  func showDetailView(for item: StoreItem)
}

final class SearchResultsCollectionViewController: UICollectionViewController {

  // MARK: - Type Definitions

  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

  // MARK: - Supplementary Kind View

  enum SupplementaryViewKind {
    static let header = "header"
  }

  // MARK: - Sections

  enum Section: Int, CaseIterable {
    case histroy
    case results
  }

  // MARK: - Items

  enum Item: Hashable {
    case history(StoreItem)
    case results(SearchSuggestion)
  }

  weak var delegate: SearchResultsDelegate?

  // MARK: - Snapshot Manager

  enum SnapshotManager {
    case history
    case results
  }

  private var snapshotManager: SnapshotManager = .history {
    didSet {
      var snapshot = Snapshot()

      switch snapshotManager {
      case .history:
        guard !searchHistroyItems.isEmpty else { break }
        snapshot.appendSections([.histroy])
        snapshot.appendItems(searchHistroyItems.map{ Item.history($0) }, toSection: .histroy)
      case .results:
        snapshot.appendSections([.results])
        snapshot.appendItems(items.map { Item.results($0) }, toSection: .results)
      }

      sections = snapshot.sectionIdentifiers
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }

  // MARK: - Network Properties
  
  var searchRepository: SearchRepository

  // MARK: - Collection View Properties

  let ID = "cell"

  var dataSource: DataSource!
  var sections = [Section]()

  private var searchHistroyItems = [StoreItem]()
  
  var items = [SearchSuggestion]()

  var searchText: String = ""
  var onSearchTextChanged: ((String) -> Void)?
  var coreDataManager: DataManager

  private var error: String?

  // MARK: - Initializers

  init(_ searchRepository: SearchRepository, coreDataManager: DataManager) {
    self.searchRepository = searchRepository
    self.coreDataManager = coreDataManager
    super.init(collectionViewLayout: UICollectionViewLayout())

    onSearchTextChanged = { [weak self] newText in
      self?.searchText = newText
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemBackground

    collectionView.collectionViewLayout = configureListLayout()

    collectionView.register(
      SearchHistoryCollectionViewCell.self,
      forCellWithReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier
    )

    collectionView.register(
      SearchItemCollectionViewCell.self,
      forCellWithReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier
    )

    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: ID)

    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: SupplementaryViewKind.header,
      withReuseIdentifier: SectionHeaderView.reuseIdentifier
    )

    configureDataSource()
  }

  // MARK: - Override didSelectItem

  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let section = sections[indexPath.section]
    switch section {
    case .histroy:
      delegate?.showDetailView(for: searchHistroyItems[indexPath.item])
    case .results:
      let cell = collectionView.cellForItem(at: indexPath) as! SearchItemCollectionViewCell
      let text = cell.text
      delegate?.selectItem(with: text.string)
    }
  }
}

  // MARK: - Update DataSource

extension SearchResultsCollectionViewController: SearchRepositoryDelegate {
  func update() {
    switch searchRepository.resultsStateManager.state {
    case .empty:
      self.searchHistroyItems = coreDataManager.fetchSearchHistory()
      snapshotManager = .history
    case .loading: self.items = []
    case .loaded(let items):
      self.items = items.compactMap { $0 }
      filterLoadedItems()
      snapshotManager = .results
    case .error:
      items.append(SearchSuggestion(name: self.searchText, artist: self.searchText))
      snapshotManager = .results
    }
  }
}

  // MARK: - Clear History

extension SearchResultsCollectionViewController: ClearHistoryDelegate {
  func clearHistory() {
    coreDataManager.deleteSearchHistory()
    searchHistroyItems = coreDataManager.fetchSearchHistory()
    snapshotManager = .history
  }
}
