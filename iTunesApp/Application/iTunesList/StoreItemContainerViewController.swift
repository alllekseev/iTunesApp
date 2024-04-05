//
//  StoreItemContainerViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

class StoreItemContainerViewController: UICollectionViewController {

  typealias DataSource = UICollectionViewDiffableDataSource<String, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>
  var searchServise = iTunesSearchService()

  var containerView: UIView!

  let searchController = UISearchController()

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
    collectionView.collectionViewLayout = createLayout()
    prepareSearchController()
    collectionView.register(
      ItemCollectionViewCell.self,
      forCellWithReuseIdentifier: ItemCollectionViewCell.ID
    )
    configureDataSource()
  }

  private func prepareSearchController() {
    navigationItem.searchController = searchController

    searchController.searchResultsUpdater = self
    searchController.showsSearchResultsController = true
    searchController.obscuresBackgroundDuringPresentation = false // TODO: change on true
    searchController.automaticallyShowsSearchResultsController = true
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
  }

  func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

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
      (
        collectionView,
        indexPath,
        item
      ) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.ID, for: indexPath) as! ItemCollectionViewCell
      self.imageLoadTask[indexPath]?.cancel()
      self.imageLoadTask[indexPath] = Task {
        await cell.configure(for: item)
        self.imageLoadTask[indexPath] = nil
      }
      return cell
    }
  }

  @objc func fetchMatchingItems() {
    self.items = []

    let searchTerm = searchController.searchBar.text ?? ""
    let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]

    imageLoadTask.values.forEach { task in task.cancel() }
    imageLoadTask = [:]

    searchTask?.cancel()
    searchTask = Task {
      if !searchTerm.isEmpty {
        var queryItems: [URLQueryItem] {
          let term = URLQueryItem(name: "term", value: searchTerm)
          let media = URLQueryItem(name: "media", value: mediaType)
          let lang = URLQueryItem(name: "lang", value: "en_us")
          let limit = URLQueryItem(name: "limit", value: "10")
          return [term, media, lang, limit]
        }
        searchServise.queryItems = queryItems

        do {
          let items = try await searchServise.fetchItems()
          if searchTerm == self.searchController.searchBar.text && mediaType == queryOptions[searchController.searchBar.selectedScopeButtonIndex] {
            self.items = items
            print(self.items.count)
          }
        } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
          // ignore cancelation errors
        } catch {
          print(error)
        }
      }
      // apply data source changes
      await dataSource.apply(self.itemSnapshot, animatingDifferences: true)
    }
    searchTask = nil
  }
}

extension StoreItemContainerViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(fetchMatchingItems),
      object: nil
    )

    perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
  }
}

//extension StoreItemContainerViewController: PrepareView {
//
//  func setupViews() {
//    view.setupView(containerView)
//  }
//
//  func configureConstraints() {
//    NSLayoutConstraint.activate([
//      containerView.topAnchor.constraint(equalTo: view.topAnchor),
//      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//    ])
//  }
//}
