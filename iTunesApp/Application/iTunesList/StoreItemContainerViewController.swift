//
//  StoreItemContainerViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

class StoreItemContainerViewController: UIViewController {

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
  }

  let queryOptions = SearchScope.allCases.map{ $0.mediaType }

  var searchTask: Task<Void, Never>? = nil
  var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()

    prepareSearchController()
  }

  private func prepareSearchController() {
    navigationItem.searchController = searchController

    searchController.searchResultsUpdater = self
//    searchController.showsSearchResultsController = true
    searchController.obscuresBackgroundDuringPresentation = false // TODO: change on true
    searchController.automaticallyShowsSearchResultsController = true
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
  }

  func configureDataSource(_ collectionView: UICollectionView) {
    dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
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
          let limit = URLQueryItem(name: "limit", value: "20")
          return [term]
        }
        searchServise.queryItems = queryItems

        do {
          let items = try await searchServise.fetchItems()
          if searchTerm == self.searchController.searchBar.text && mediaType == queryOptions[searchController.searchBar.selectedScopeButtonIndex] {
            self.items = items
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
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
  }
}

extension StoreItemContainerViewController {

  func setupViews() {
    
  }

  func configureConstraints() {

  }
}
