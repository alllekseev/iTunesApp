//
//  SearchRepository.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

enum ServiceType {
  case storeItems
  case resultItems
}

class SearchRepository {

  weak var delegate: SearchRepositoryDelegate?
  weak var resultsDelegate: SearchRepositoryDelegate?

  lazy var storeStateManager: StateManager<StoreItem> = {
    StateManager<StoreItem> { [weak self] in
      self?.delegate?.update()
    }
  }()

  lazy var resultsStateManager: StateManager<SearchSuggestion> = {
    StateManager<SearchSuggestion> { [weak self] in
      self?.resultsDelegate?.update()
    }
  }()

  private var storeSearchService = iTunesSearchService()
  private var resultsSearchService = SuggestionResults()

  init() {
    storeStateManager.state = .empty
    resultsStateManager.state = .empty
  }

  func fetchMatchingItems(
    for service: ServiceType,
    queryItems: QueryItems
  ) async {
    do {
      switch service {
      case .storeItems:
        storeStateManager.state = .loading
        storeSearchService.queryItems = queryItems.queryItems
        let items = try await storeSearchService.fetchItems().compactMap { $0 }
        storeStateManager.state = .loaded(items)
      case .resultItems:
        resultsStateManager.state = .loading
        resultsSearchService.queryItems = queryItems.queryItems
        let items = try await resultsSearchService.fetchItems().compactMap { $0 }
        resultsStateManager.state = .loaded(items)
      }
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
    } catch {
      if let error = error as? APIError {
        switch service {
        case .storeItems:
          storeStateManager.state = .error(error)
        case .resultItems:
          resultsStateManager.state = .error(error)
        }
      }
    }
  }
}
