//
//  SearchRepository.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

protocol SearchObserver: AnyObject {
  func searchItemsDidFetch(_ items: [StoreItem])
  func searchFetchFailed(with error: Error)
}

class SearchRepository {
//  weak var delegate: SearchRepositoryDelegate?
  private var searchService = iTunesSearchService()

  private var observers = [SearchObserver]()

  func addObserver(_ observer: SearchObserver) {
    observers.append(observer)
  }

  func removeObserver(_ observer: SearchObserver) {
    observers = observers.filter { $0 !== observer }
  }

  func fetchMatchingItems(queryItems: QueryItems) async {
    do {
      searchService.queryItems = queryItems.queryItems
      var items = try await searchService.fetchItems()
      items = items.compactMap { $0 }
      observers.forEach { $0.searchItemsDidFetch(items) }
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancellation error
    } catch {
      observers.forEach { $0.searchFetchFailed(with: error) }
    }
  }
}
