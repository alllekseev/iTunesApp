//
//  StoreSearchController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import UIKit

final class StoreSearchController: UISearchController {

  weak var textDelegate: SearchBarTextDelegate?
  var searchTextHandler: (() -> Void) = {}

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
    searchTextHandler()
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
    searchRepository.addObserver(resultsController)
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

    perform(#selector(fetchItems), with: nil, afterDelay: 0.3)
  }
}

extension StoreSearchController: UISearchBarDelegate {
  func searchBar(
    _ searchBar: UISearchBar,
    selectedScopeButtonIndexDidChange selectedScope: Int
  ) {
    updateSearchResults(for: self)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    dismiss(animated: true, completion: nil)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    dismiss(animated: true, completion: nil)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty || searchBar.text == nil {
      searchTextHandler()
    } else {
      textDelegate?.searchTextDidChange(searchText)
    }
  }
}

