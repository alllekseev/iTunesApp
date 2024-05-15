//
//  SearchController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import UIKit

final class SearchController: UISearchController {

  struct ResponseData {
    var service: ServiceType = .resultItems
    var mediaType: String
    var elementsAmount: Int = 30
  }

  private lazy var responseData = ResponseData(
    service: .resultItems,
    mediaType: queryOptions[searchBar.selectedScopeButtonIndex],
    elementsAmount: 10
  )

  weak var textDelegate: SearchBarTextDelegate?
  var searchTextHandler: (() -> Void) = {}

  private var workItem: DispatchWorkItem?

  var searchRepository = SearchRepository()
  private var resultsController: SearchResultsCollectionViewController

  private let queryOptions = SearchScope.allCases.map{ $0.mediaType }

  init() {
    resultsController = SearchResultsCollectionViewController(searchRepository)
    super.init(searchResultsController: resultsController)
    setupSearchBar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSearchBar()
    searchTextHandler()
    setupResultsController()
  }

  private func setupSearchBar() {
    searchBar.delegate = self
    searchBar.placeholder = NSLocalizedString(
      "Type you request",
      comment: "Search placeholder for search bar"
    )
    searchBar.showsScopeBar = true
    searchBar.autocapitalizationType = .none
    searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
  }

  private func setupResultsController() {
    searchRepository.resultsDelegate = resultsController
    textDelegate = resultsController
    resultsController.delegate = self
  }
}

extension SearchController {
  private func fetchItems() async {
    let searchTerm = searchBar.text ?? ""
    if !searchTerm.isEmpty {
      let queryItems = QueryItems(term: searchTerm, mediaType: responseData.mediaType, elementsAmount: responseData.elementsAmount)
      await searchRepository.fetchMatchingItems(for: responseData.service, queryItems: queryItems)
    }
  }


  private func updateResults() {
    workItem?.cancel()
    responseData.mediaType = queryOptions[searchBar.selectedScopeButtonIndex]
    workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      Task {
        await self.fetchItems()
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem!)
  }
}

extension SearchController: UISearchBarDelegate {
  func searchBar(
    _ searchBar: UISearchBar,
    selectedScopeButtonIndexDidChange selectedScope: Int
  ) {
    if searchBar.isFirstResponder {
      responseData.service = .resultItems
      responseData.elementsAmount = 10
    } else {
      responseData.service = .storeItems
      responseData.elementsAmount = 30
    }
    updateResults()
  }

  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    searchRepository.resultsStateManager.state = .empty
    searchTextHandler()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    responseData.service = .storeItems
    responseData.elementsAmount = 30
    updateResults()

    dismiss(animated: true, completion: nil)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchRepository.storeStateManager.state = .empty
    searchRepository.resultsStateManager.state = .empty
    searchBar.selectedScopeButtonIndex = 0
    dismiss(animated: true, completion: nil)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    guard !searchText.isEmpty || searchBar.text != nil else {
      searchTextHandler()
      return
    }

    responseData.service = .resultItems
    responseData.elementsAmount = 10
    updateResults()
    textDelegate?.searchTextDidChange(searchText)
  }
}

extension SearchController: SearchResultsCellDelegate {
  func didSelectItem(with name: String) {
    self.searchBar.text = name
    searchBarSearchButtonClicked(self.searchBar)
  }
}
