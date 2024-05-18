//
//  SearchHistory+CoreDataProperties.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/05/2024.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var artistName: String
    @NSManaged public var artworkURL: String?
    @NSManaged public var brief: String
    @NSManaged public var collectionID: Int64
    @NSManaged public var id: UUID
    @NSManaged public var kind: String
    @NSManaged public var title: String
    @NSManaged public var trackID: Int64

}

extension SearchHistory : Identifiable {

}
