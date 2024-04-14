//
//  MainCollectionViewController+Updating.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit



//extension MainCollectionViewController: UISearchResultsUpdating {



//  @objc func fetchMatchingItems() {
//    let controller = searchCollectionViewController
//    controller.items = []
//
//
//    let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]
//
//    controller.searchTask?.cancel()
//    controller.searchTask = Task {
//      var searchTerm = searchController.searchBar.text ?? ""
//      searchTerm = searchTerm.split(separator: " ").joined(separator: "+")
//      if !searchTerm.isEmpty {
//        var queryItems: [URLQueryItem] {
//
//          let queryItems = [
//            "term": searchTerm,
//            "entity": mediaType,
//            "lang": "en_us",
//            "limit": "5"
//          ]
//
//          return queryItems.map { URLQueryItem(name: $0.key, value: $0.value )}
//        }
//        searchServise.queryItems = queryItems
//
//        controller.loadingViewController.startLoading()
//
//        do {
//          let items = try await searchServise.fetchItems()
//          if searchTerm == self.searchController.searchBar.text,
//             mediaType == queryOptions[searchController.searchBar.selectedScopeButtonIndex] {
//            controller.items = items
//          }
//        } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
//          // ignore cancellation error
//        } catch APIRequestError.itemsNotFound {
//          controller.items = []
//        } catch {
//          print(error)
//        }
//        await controller.dataSource.apply(
//          controller.itemsSnapshot,
//          animatingDifferences: true)
//      } else {
//        await controller.dataSource.apply(
//          controller.itemsSnapshot,
//          animatingDifferences: true)
//      }
//      controller.loadingViewController.stopLoading()
//      controller.searchTask = nil
//
//    }
//
//  }



//  func updateSearchResults(for searchController: UISearchController) {
//    NSObject.cancelPreviousPerformRequests(
//      withTarget: self,
//      selector: #selector(fetchItems),
//      object: nil
//    )
//
//    perform(#selector(fetchItems), with: nil, afterDelay: 0.5)
//  }
//}
//