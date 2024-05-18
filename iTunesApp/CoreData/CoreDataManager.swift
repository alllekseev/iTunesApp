//
//  CoreDataManager.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/05/2024.
//

import Foundation
import CoreData

final class CoreDataManager {
  static let shared = CoreDataManager()

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "")
    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  var context: NSManagedObjectContext { persistentContainer.viewContext }

  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

extension CoreDataManager {
  func save(item: StoreItem) {
    let newItem = SearchHistory(context: context)
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

  func fetchSearchHistory() -> [SearchHistory] {
    let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()

    do {
      let searchHistory = try context.fetch(fetchRequest)
      return searchHistory
    } catch {
      // TODO: - add logger
      print("Failed fetching: \(error)")
      return []
    }
  }
}

/*
 if let urlString = searchItem.searchURL, let url = URL(string: urlString) {
             cell.detailTextLabel?.text = url.absoluteString
         }
 */
