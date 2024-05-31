//
//  SearchHistory+CoreDataClass.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 22/05/2024.
//
//

import Foundation
import CoreData

@objc(SearchHistory)
public class SearchHistory: NSManagedObject, Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
      return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
  }

  @NSManaged public var id: UUID
  @NSManaged public var title: String
  @NSManaged public var artistName: String
  @NSManaged public var kind: String
  @NSManaged public var brief: String
  @NSManaged public var artworkURL: String?
  @NSManaged public var trackID: Int64
  @NSManaged public var collectionID: Int64
  @NSManaged public var artistURL: String?
}
