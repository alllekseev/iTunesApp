//
//  SearchController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import UIKit

final class SearchController: UISearchController {

  struct ResponseData {
    var service: ServiceType
    var mediaType: String
    var elementsAmount: Int
  }

  weak var textDelegate: SearchBarTextDelegate?
  var searchTextHandler: (() -> Void) = {}
  var searchRepository = SearchRepository()

  private var workItem: DispatchWorkItem?
  private var resultsController: SearchResultsCollectionViewController
  private let queryOptions = SearchScope.allCases.map{ $0.mediaType }

  private lazy var responseData = ResponseData(
    service: .resultItems,
    mediaType: queryOptions[searchBar.selectedScopeButtonIndex],
    elementsAmount: 10
  )

  init() {
    resultsController = SearchResultsCollectionViewController(searchRepository)
    super.init(searchResultsController: resultsController)
    setupSearchBar()
    setupResultsController()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextHandler()
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
    self.showsSearchResultsController = true
    searchRepository.resultsDelegate = resultsController
    textDelegate = resultsController
    resultsController.delegate = self
    resultsController.delegateShowDetailVC = self
  }
}

extension SearchController {
  private func fetchItems() async {
    guard let searchTerm = searchBar.text,
          !searchTerm.isEmpty else {
      return
    }

    let queryItems = QueryItems(
      term: searchTerm,
      mediaType: responseData.mediaType,
      elementsAmount: responseData.elementsAmount
    )

    await searchRepository.fetchMatchingItems(
      for: responseData.service,
      queryItems: queryItems
    )
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

    DispatchQueue.main.asyncAfter(
      deadline: .now() + 0.3,
      execute: workItem!
    )
  }

  private func resetSearch() {
    searchRepository.storeStateManager.state = .empty
    searchRepository.resultsStateManager.state = .empty
    searchBar.selectedScopeButtonIndex = 0
  }
}

extension SearchController: UISearchBarDelegate {

  private func updateService(for isFirstResponder: Bool) {
    responseData.service = isFirstResponder ? .resultItems : .storeItems
    responseData.elementsAmount = isFirstResponder ? 10 : 30
  }

  func searchBar(
    _ searchBar: UISearchBar,
    selectedScopeButtonIndexDidChange selectedScope: Int
  ) {
    updateService(for: searchBar.isFirstResponder)
    updateResults()
  }

  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    searchRepository.resultsStateManager.state = .empty
    searchTextHandler()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    updateService(for: false)
    updateResults()
    dismiss(animated: true, completion: nil)

    dismiss(animated: true, completion: nil)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    resetSearch()
    dismiss(animated: true, completion: nil)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    guard !searchText.isEmpty else {
      searchRepository.resultsStateManager.state = .empty
      textDelegate?.searchTextDidChange(searchText)
      return
    }

    updateService(for: true)
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

extension SearchController: ShowDetailViewController {
  func showDetailView(for item: StoreItem) {

//    let mainVC = MainCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    let vc = DetailViewController(itemDetails: item)
    self.present(vc, animated: true)

//    navigationController?.pushViewController(vc, animated: true)
  }
}
