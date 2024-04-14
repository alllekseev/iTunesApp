//
//  MainCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

// TODO: create initializer
class MainCollectionViewController: UICollectionViewController {

  // MARK: - Typealiases

  typealias DataSource = UICollectionViewDiffableDataSource<String, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>

  // MARK: - Properties


  var searchServise = iTunesSearchService()
  var searchRepositiry: SearchRepository!
  var searchController: UISearchController!
//  let searchCollectionViewController = SearchCollectionViewController(collectionViewLayout: UICollectionViewLayout())

  var dataSource: DataSource!

  var items = [StoreItem]()
  var itemSnapshot: Snapshot {
    var snapshot = Snapshot()
    snapshot.appendSections(["Results"])
    snapshot.appendItems(items)
    return snapshot
  }

  let queryOptions = SearchScope.allCases.map{ $0.mediaType }

  var searchTask: Task<Void, Never>? = nil
  var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.collectionViewLayout = configureLayout()
    collectionView.register(
      MainCollectionViewCell.self,
      forCellWithReuseIdentifier: MainCollectionViewCell.ID
    )
    configureDataSource()
    configureSearchController()
    searchRepositiry = SearchRepository(searchService: searchServise)
    searchRepositiry.delegate = self
  }

  // MARK: - Configure SearchController

  private func configureSearchController() {
//    searchController = UISearchController(searchResultsController: searchCollectionViewController)
    searchController = UISearchController()
//    searchController.searchResultsUpdater = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = true // TODO: change on true
//    searchController.automaticallyShowsSearchResultsController = true
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }

    navigationItem.searchController = searchController
  }

  // MARK: - Configure Layout

  func configureLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 4,
      leading: 4,
      bottom: 4,
      trailing: 4
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: 2
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 8,
      leading: 8,
      bottom: 8,
      trailing: 8
    )
    section.interGroupSpacing = 8

    return UICollectionViewCompositionalLayout(section: section)
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MainCollectionViewCell.ID,
        for: indexPath
      ) as! MainCollectionViewCell

      // FIXME: Remove Task from here
      self.imageLoadTask[indexPath]?.cancel()
      self.imageLoadTask[indexPath] = Task {
        try? await cell.configure(for: item)
        self.imageLoadTask[indexPath] = nil
      }
      return cell
    }
  }
}

extension MainCollectionViewController {
  @objc func fetchItems() {
    let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]
    let searchTerm = searchController.searchBar.text ?? ""

    self.searchTask?.cancel()
    self.searchTask = Task {
      if !searchTerm.isEmpty {
        let queryItems = QueryItems(term: searchTerm, mediaType: mediaType)
        await searchRepositiry.fetchMatchingItems(queryItems: queryItems)
      }
    }
  }
}

extension MainCollectionViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    fetchItems()
    searchBar.resignFirstResponder()
  }

//  func searchBar(
//    _ searchBar: UISearchBar,
//    selectedScopeButtonIndexDidChange selectedScope: Int
//  ) {
//    updateSearchResults(for: searchController)
//  }
}

extension MainCollectionViewController: SearchRepositoryDelegate {
  func searchItemsDidFetch(_ items: [StoreItem]) {
    self.items = items
    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }

  func searchFetchFailed(with error: Error) {
    switch error {
    case APIRequestError.itemsNotFound:
      print("Items not found.")
      // Дополнительные действия при необходимости
    case APIRequestError.requestFailed:
      print("Request failed.")
      // Дополнительные действия при необходимости
    case APIRequestError.imageDataMissing:
      print("Image data is missing.")
      // Дополнительные действия при необходимости
    case APIRequestError.notValidURL:
      print("URL is not valid.")
      // Дополнительные действия при необходимости
    case APIRequestError.imageURLNotFound:
      print("Image URL not found.")
      // Дополнительные действия при необходимости
    default:
      print("Unknown error occurred: \(error.localizedDescription)")
    }
  }
}
