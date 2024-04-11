//
//  MainCollectionViewController+Updating.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

extension MainCollectionViewController: UISearchResultsUpdating {

  @objc func fetchMatchingItems() {
    let controller = searchCollectionViewController
    controller.items = []


    let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]

    controller.searchTask?.cancel()
    controller.searchTask = Task {
      var searchTerm = searchController.searchBar.text ?? ""
      searchTerm = searchTerm.split(separator: " ").joined(separator: "+")
      if !searchTerm.isEmpty {
        var queryItems: [URLQueryItem] {

          let queryItems = [
            "term": searchTerm,
            "entity": mediaType,
            "lang": "en_us",
            "limit": "30"
          ]

          print("DEBUG: \(queryItems)")

          return queryItems.map { URLQueryItem(name: $0.key, value: $0.value )}
        }
        searchServise.queryItems = queryItems

        do {
          let items = try await searchServise.fetchItems()
          if searchTerm == self.searchController.searchBar.text,
             mediaType == queryOptions[searchController.searchBar.selectedScopeButtonIndex] {
//            controller.items = items
            if let resultController = searchController.searchResultsController as? SearchCollectionViewController {
              resultController.items = items
              controller.collectionView.reloadData()

            }
          }

          controller.searchTask = nil


        } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
          // ignore cancelation errors
        } catch APIRequestError.itemsNotFound {
          controller.items = []
        } catch {
          print(error)
        }
      }
      // apply data source changes
      await controller.dataSource.apply(
        controller.itemsSnapshot,
        animatingDifferences: true)
    }

  }

  func updateSearchResults(for searchController: UISearchController) {
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(fetchMatchingItems),
      object: nil
    )

    perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
  }
}
