//
//  MainCollectionViewController+SearchController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 27/05/2024.
//

import UIKit

// MARK: - Configure Search Controller

extension MainCollectionViewController {

  // MARK: - Setup SearchBar

  func setupSearchBar() {
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = NSLocalizedString(
      "Type you request",
      comment: "Search placeholder for search bar"
    )
    searchController.searchBar.showsScopeBar = true
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
  }

  // MARK: - Setup Results Controller

  func setupResultsController() {
    searchController.showsSearchResultsController = true
    searchRepository.resultsDelegate = resultsController
    resultsController.delegate = self
    textDidChange = resultsController.onSearchTextChanged
  }

  fileprivate func searchDidChangeText(to newText: String) {
    textDidChange?(newText)
  }

}

extension MainCollectionViewController {

  // MARK: - Update Service

  private func updateService(for isFirstResponder: Bool) {
    responseData.service = isFirstResponder ? .resultItems : .storeItems
    responseData.elementsAmount = isFirstResponder ? 10 : 30
  }

  // MARK: - Update Results

  fileprivate func updateResults() {
    workItem?.cancel()
    responseData.mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]

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

  // MARK: - Reset Search

  private func resetSearch() {
    searchRepository.storeStateManager.state = .empty
    searchRepository.resultsStateManager.state = .empty
    searchController.searchBar.selectedScopeButtonIndex = 0
  }

  // MARK: - FetchItems

  private func fetchItems() async {
    guard let searchTerm = searchController.searchBar.text,
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
}

// MARK: - UISearchBarDelegate

extension MainCollectionViewController: UISearchBarDelegate {

  func searchBar(
    _ searchBar: UISearchBar,
    selectedScopeButtonIndexDidChange selectedScope: Int
  ) {
    updateService(for: searchBar.isFirstResponder)
    updateResults()
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

    searchDidChangeText(to: searchText)
    guard !searchText.isEmpty else {
      searchRepository.resultsStateManager.state = .empty
      return
    }

    updateService(for: true)
    updateResults()
  }
}

  // MARK: - SearchResultsDelegate

extension MainCollectionViewController: SearchResultsDelegate {
  func selectItem(with name: String) {
    searchController.searchBar.text = name
    searchBarSearchButtonClicked(searchController.searchBar)
  }
  
  func showDetailView(for item: StoreItem) {
    let vc = DetailViewController(itemDetails: item)
    navigationController?.pushViewController(vc, animated: true)
  }
}
