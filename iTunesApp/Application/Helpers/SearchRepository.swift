//
//  SearchRepository.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

protocol SearchObserver: AnyObject {
  func update()
}

class SearchRepository {

  lazy var stateManager: StateManager = {
    StateManager { [weak self ] in
      self?.notifyObservers()
    }
  }()

  private var searchService = iTunesSearchService()

  private var observers = [SearchObserver]()

  init() {
    stateManager.state = .empty
  }

  func addObserver(_ observer: SearchObserver) {
    observers.append(observer)
  }

  func removeObserver(_ observer: SearchObserver) {
    observers = observers.filter { $0 !== observer }
  }

  private func notifyObservers() {
    observers.forEach { $0.update() }
  }

  func fetchMatchingItems(queryItems: QueryItems) async {
    do {
      stateManager.state = .loading
      searchService.queryItems = queryItems.queryItems
      let items = try await searchService.fetchItems().compactMap { $0 }
      stateManager.state = .loaded(items)
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
    } catch {
      if let error = error as? APIError {
        stateManager.state = .error(error)
      }
    }
  }
}
