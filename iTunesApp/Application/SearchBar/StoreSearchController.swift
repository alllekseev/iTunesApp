//
//  StoreSearchController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import UIKit

final class StoreSearchController: UISearchController {

  weak var textDelegate: SearchBarTextDelegate?

  var searchRepository = SearchRepository()
  private var searchServise: iTunesSearchService
  private var resultsController: SearchCollectionViewController

  private let queryOptions = SearchScope.allCases.map{ $0.mediaType }

  private var searchTask: Task<Void, Never>? = nil

  init() {
    searchServise = iTunesSearchService()
    resultsController = SearchCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    super.init(searchResultsController: resultsController)
    setupSearchBar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSearchBar()
    setupResultsController()
  }

  private func setupSearchBar() {
    searchBar.delegate = self
    searchResultsUpdater = self
    searchBar.placeholder = NSLocalizedString(
      "Type you request",
      comment: "Search placeholder for search bar"
    )
    searchBar.showsScopeBar = true
    searchBar.autocapitalizationType = .none
    searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
    searchBar.showsScopeBar = true


    showsSearchResultsController = true
    automaticallyShowsSearchResultsController = true
    obscuresBackgroundDuringPresentation = true
  }

  private func setupResultsController() {
    searchRepository.addObserver(self)
    textDelegate = resultsController
  }
}

extension StoreSearchController {
  @objc private func fetchItems() {
    let searchTerm = searchBar.text ?? ""
    let mediaType = queryOptions[searchBar.selectedScopeButtonIndex]
    self.searchTask?.cancel()
    self.searchTask = Task {
      if !searchTerm.isEmpty {
        let queryItems = QueryItems(term: searchTerm, mediaType: mediaType)
        await searchRepository.fetchMatchingItems(queryItems: queryItems)
      }

      self.searchTask = nil
    }


  }
}

extension StoreSearchController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(fetchItems),
      object: nil
    )

    if let searchText = searchController.searchBar.text {
      textDelegate?.searchTextDidChange(searchText)
    }

    perform(#selector(fetchItems), with: nil, afterDelay: 0.3)
  }
}

extension StoreSearchController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    isActive = false
  }

  func searchBar(
    _ searchBar: UISearchBar,
    selectedScopeButtonIndexDidChange selectedScope: Int
  ) {
    updateSearchResults(for: self)
  }
}

extension StoreSearchController: SearchObserver {
  func searchItemsDidFetch(_ items: [StoreItem]) {
    resultsController.searchItemsDidFetch(items)
  }

  func searchFetchFailed(with error: Error) {
    resultsController.searchFetchFailed(with: error)
  }
}


