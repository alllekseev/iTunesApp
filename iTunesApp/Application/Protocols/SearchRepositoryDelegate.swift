//
//  SearchRepositoryDelegate.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

protocol SearchRepositoryDelegate: AnyObject {
  func searchItemsDidFetch(_ items: [StoreItem])
  func searchFetchFailed(with error: Error)
}

//extension MainCollectionViewController: SearchRepositoryDelegate {
//  func searchItemsDidFetch(_ items: [StoreItem]) {
//    self.items = items
//    dataSource.apply(itemSnapshot, animatingDifferences: true)
//  }
//
//  func searchFetchFailed(with error: Error) {
//    switch error {
//    case APIRequestError.itemsNotFound:
//      print("Items not found.")
//      // Дополнительные действия при необходимости
//    case APIRequestError.requestFailed:
//      print("Request failed.")
//      // Дополнительные действия при необходимости
//    case APIRequestError.imageDataMissing:
//      print("Image data is missing.")
//      // Дополнительные действия при необходимости
//    case APIRequestError.notValidURL:
//      print("URL is not valid.")
//      // Дополнительные действия при необходимости
//    case APIRequestError.imageURLNotFound:
//      print("Image URL not found.")
//      // Дополнительные действия при необходимости
//    default:
//      print("Unknown error occurred: \(error.localizedDescription)")
//    }
//  }
//}
