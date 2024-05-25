//
//  DataManager.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/05/2024.
//

import Foundation
import CoreData

final class DataManager {

  private let coreDataStack = CoreDataStack.shared

  private func getItems() -> [SearchHistory]? {
    let fetchRequest = SearchHistory.fetchRequest()
    let items = try? coreDataStack.context.fetch(fetchRequest)
    return items
  }

  private func create(_ item: StoreItem) {
    let newItem = SearchHistory(context: coreDataStack.context)
    newItem.id = item.id
    newItem.title = item.name
    newItem.artistName = item.artist
    newItem.kind = item.kind
    newItem.brief = item.description
    newItem.artworkURL = item.artworkURL?.absoluteString

    if let trackID = item.trackId {
      newItem.trackID = Int64(trackID)
    }
    if let collectionID = item.collectionId {
      newItem.collectionID = Int64(collectionID)
    }
  }

  func save(item: StoreItem) {
    if var items = getItems() {
      guard !items.contains(where: { $0.id == item.id }) else { return }
      if items.count >= 5 {
        let excessItem = items.removeFirst()
        coreDataStack.context.delete(excessItem)
      }
    }
    create(item)
    coreDataStack.saveContext()
  }

  func fetchSearchHistory() -> [StoreItem] {
    guard let items = getItems() else { return [] }

    return items.map { historyItem in
      var storeItem = StoreItem(
        name: historyItem.title,
        artist: historyItem.artistName,
        kind: historyItem.kind,
        description: historyItem.brief
      )

      if let urlString = historyItem.artworkURL {
        storeItem.artworkURL = URL(string: urlString)
      }

      storeItem.trackId = Int(historyItem.trackID)
      storeItem.collectionId = Int(historyItem.collectionID)

      return storeItem
    }.reversed()
  }

  func deleteSearchHistory() {
    let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()

    do {
      let results = try coreDataStack.context.fetch(fetchRequest)
      for result in results {
        coreDataStack.context.delete(result)
      }
      coreDataStack.saveContext()
    } catch {
      print("Failed fetching: \(error)")
    }
  }
}
