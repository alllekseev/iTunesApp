//
//  CoreDataStack.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 19/05/2024.
//

import Foundation
import CoreData

final class CoreDataStack {

  let persistentContainer: NSPersistentContainer

  var context: NSManagedObjectContext { persistentContainer.viewContext }

  init(modelName: CoreDataModelNames) {
    persistentContainer = NSPersistentContainer(name: modelName.rawValue)
    persistentContainer.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }

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
