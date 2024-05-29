//
//  CoreDataStack.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 19/05/2024.
//

import Foundation
import CoreData

final class CoreDataStack {

  static let shared = CoreDataStack()

  lazy var persistentContainer: NSPersistentContainer = {
    let container =  NSPersistentContainer(name: CoreDataModelNames.searchHistory.rawValue)
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
