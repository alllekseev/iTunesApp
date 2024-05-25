//
//  SearchResultsCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

protocol SearchResultsCellDelegate: AnyObject {
  func didSelectItem(with name: String)
}

protocol ShowDetailViewController: AnyObject {
  func showDetailView(for item: StoreItem)
}

final class SearchResultsCollectionViewController: UICollectionViewController {

  weak var delegateShowDetailVC: ShowDetailViewController?

  enum SupplementaryViewKind {
    static let header = "header"
  }
  enum Section: Int, CaseIterable {
    case histroy
    case results
  }

  enum Item: Hashable {
    case history(StoreItem)
    case results(SearchSuggestion)
  }

  enum ResultsState {
    case history
    case results
  }

  var resultsState: ResultsState = .history {
    didSet {
      updateSnapshot()
    }
  }

  var searchRepository: SearchRepository
  lazy var dataManager = DataManager()

  weak var delegate: SearchResultsCellDelegate?

  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

  let ID = "cell"

  var dataSource: DataSource!
  var sections = [Section]()
  var searchHistroyItems = [StoreItem]()
  var items = [SearchSuggestion]()
//  var itemsSnapshot: Snapshot {
//    var snaphot = Snapshot()
//
//    if !searchHistroyItems.isEmpty && searchText.isEmpty {
//      snaphot.appendSections([.histroy])
//      snaphot.appendItems(searchHistroyItems.map{ Item.history($0) }, toSection: .histroy)
//    }
//
//    if !items.isEmpty && !searchText.isEmpty {
//      snaphot.appendSections([.results])
//      snaphot.appendItems(items.map { Item.results($0) }, toSection: .results)
//    }
//
//    return snaphot
//  }

  init(_ searchRepository: SearchRepository) {
    self.searchRepository = searchRepository
    super.init(collectionViewLayout: UICollectionViewLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func applyInitialSnapshot() {

    var snapshot = Snapshot()

    if !searchHistroyItems.isEmpty && searchText.isEmpty {
      snapshot.appendSections([.histroy])
      snapshot.appendItems(searchHistroyItems.map{ Item.history($0) }, toSection: .histroy)
    }

    sections = snapshot.sectionIdentifiers
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  private func updateSnapshot() {
    var snapshot = Snapshot()

    switch resultsState {
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

  private var searchText: String = ""

  private var error: String?

  // MARK: - ViewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemBackground

    collectionView.collectionViewLayout = listLayout()

    collectionView.register(
      SearchHistoryCollectionViewCell.self,
      forCellWithReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier
    )

    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: ID)

    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: SupplementaryViewKind.header,
      withReuseIdentifier: SectionHeaderView.reuseIdentifier
    )

    configureDataSource()
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      collectionView,
      indexPath,
      item in
      switch item {
      case .history(let storeItem):
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier,
          for: indexPath
        ) as! SearchHistoryCollectionViewCell
        cell.configureCell(for: storeItem)
        return cell
      case .results(let resultsItem):
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: self.ID,
          for: indexPath
        ) as! UICollectionViewListCell

        var contentConfiguration = cell.defaultContentConfiguration()
        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 16))
        contentConfiguration.image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration)
        contentConfiguration.imageProperties.tintColor = .systemGray

        let resultText = resultsItem.name
        contentConfiguration.textProperties.color = .systemGray
        if let attributedText = self.attributedString(from: resultText) {
          contentConfiguration.attributedText = attributedText
        } else {
          contentConfiguration.text = resultText
        }

        cell.contentConfiguration = contentConfiguration
        return cell
      }
    }

    dataSource.supplementaryViewProvider = {
      collectionView,
      kind,
      indexPath -> UICollectionReusableView? in

      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: SupplementaryViewKind.header,
        withReuseIdentifier: SectionHeaderView.reuseIdentifier,
        for: indexPath
      ) as! SectionHeaderView
      headerView.delegate = self

      return headerView
    }

    applyInitialSnapshot()
//    dataSource.apply(itemsSnapshot)
  }

  private func attributedString(from resultText: String) -> NSMutableAttributedString? {
    guard let range = resultText.range(of: searchText, options: .caseInsensitive) else {
      return nil
    }
    let attributedString = NSMutableAttributedString(string: resultText)
    attributedString.addAttributes(
      [
        .font: UIFont.boldSystemFont(ofSize: 17),
        .foregroundColor: UIColor.label
      ],
      range: NSRange(range, in: resultText)
    )
    return attributedString
  }

  private func listLayout() -> UICollectionViewLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
    listConfiguration.backgroundColor = .clear

    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

      let section = self.sections[sectionIndex]

      let headerItemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.92),
          heightDimension: .estimated(44))
      let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerItemSize,
          elementKind: SupplementaryViewKind.header, alignment: .top)
      headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

      let supplementaryItemContentInsets = NSDirectionalEdgeInsets(
          top: 0,
          leading: 4,
          bottom: 0,
          trailing: 4)

      headerItem.contentInsets = supplementaryItemContentInsets

      switch section {
      case .histroy:
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
        section.boundarySupplementaryItems = [headerItem]
        return section
      case .results:
        listConfiguration.itemSeparatorHandler = {
          (indexPath, sectionSeparatorConfiguration) in
          var configuration = sectionSeparatorConfiguration
          configuration.bottomSeparatorInsets.leading = 0
          return configuration
        }
        return NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
      }
    }

    return layout
  }
//  private func listLayout() -> UICollectionViewCompositionalLayout {
//    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
//    listConfiguration.headerMode = .supplementary
//    listConfiguration.backgroundColor = .clear
//    
//    listConfiguration.itemSeparatorHandler = {
//      (indexPath, sectionSeparatorConfiguration) in
//      var configuration = sectionSeparatorConfiguration
//      configuration.bottomSeparatorInsets.leading = 0
//      return configuration
//    }
//    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
//  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let section = sections[indexPath.section]
    switch section {
    case .histroy:
      delegateShowDetailVC?.showDetailView(for: searchHistroyItems[indexPath.item])
//      let vc = DetailViewController(itemDetails: searchHistroyItems[indexPath.item])
//      self.navigationController?.pushViewController(vc, animated: true)
//      print("tapped")
    case .results: delegate?.didSelectItem(with: items[indexPath.row].name)
    }
  }
}

extension SearchResultsCollectionViewController: SearchBarTextDelegate {
  func searchTextDidChange(_ searchText: String) {
    self.searchText = searchText
  }
}

extension SearchResultsCollectionViewController: SearchRepositoryDelegate {
  func update() {

    switch searchRepository.resultsStateManager.state {
    case .empty:
      self.searchHistroyItems = dataManager.fetchSearchHistory()
      resultsState = .history
    case .loading: self.items = []
    case .loaded(let items):
      self.items = items.compactMap { $0 }
      resultsState = .results
    case .error:
      items.append(SearchSuggestion(name: self.searchText))
      resultsState = .results
    }

//    dataSource.apply(itemsSnapshot, animatingDifferences: true)
  }
}

extension SearchResultsCollectionViewController: ClearHistoryDelegate {
  func clearHistory() {
    dataManager.deleteSearchHistory()
    searchHistroyItems = dataManager.fetchSearchHistory()
//    dataSource.apply(itemsSnapshot, animatingDifferences: true)
    resultsState = .history
  }
  

}
