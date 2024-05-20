//
//  DataManager.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/05/2024.
//

import Foundation
import CoreData

final class DataManager {

  private let coreDataStack: CoreDataStack
  private var searchHistory: SearchHistory?

  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }

  func save(item: StoreItem) {
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

    let fetchRequest = SearchHistory.fetchRequest()

    do {
      var results = try coreDataStack.context.fetch(fetchRequest)
      let count = results.count
      if count >= 5 {
        results.removeLast()
        results.insert(newItem, at: 0)
      } else {
        results.insert(newItem, at: 0)
      }
//      for result in results {
//        coreDataStack.context.insert(result)
//      }
    } catch {
      print("Failed to fetch search history items: \(error)")
    }
    coreDataStack.saveContext()
  }

  func fetchSearchHistory() -> [SearchHistory] {
    let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()

    do {
      let searchHistory = try coreDataStack.context.fetch(fetchRequest)
      return searchHistory
    } catch {
      // TODO: - add logger
      print("Failed fetching: \(error)")
      return []
    }
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
