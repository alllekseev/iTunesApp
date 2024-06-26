//
//  StoreItem.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

struct StoreItem: Hashable, Identifiable {
  
  let id = UUID()
  let name: String
  let artist: String
  let kind: String
  let description: String
  var artworkURL: URL?
  var trackId: Int?
  var collectionId: Int?
  var artistURL: URL?

  /*artistViewUrl*/
  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case artist = "artistName"
    case kind
    case description = "longDescription"
    case artwork = "artworkUrl100"
    case trackId
    case collectionId
    case artistViewUrl
  }

  enum AdditionalKeys: String, CodingKey {
    case description = "shortDescription"
    case collectionName = "collectionName"
    case collectionArtistViewUrl
  }

  init(name: String, artist: String, kind: String, description: String) {
    self.name = name
    self.artist = artist
    self.kind = kind
    self.description = description
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: StoreItem, rhs: StoreItem) -> Bool {
    return lhs.id == rhs.id
  }
}

extension StoreItem: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    artist = try container.decode(String.self, forKey: .artist)
    kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
    trackId = try? container.decode(Int.self, forKey: .trackId)
    collectionId = try? container.decode(Int.self, forKey: .collectionId)
    artworkURL = try? container.decode(URL.self, forKey: .artwork)

    let additionalContainer = try decoder.container(keyedBy: AdditionalKeys.self)
    name = (try? container.decode(String.self, forKey: .name))
        ?? (try? additionalContainer.decode(String.self, forKey: .collectionName)) ?? ""
    description = (try? container.decode(String.self, forKey: .description))
        ?? (try? additionalContainer.decode(String.self, forKey: .description))
        ?? ""
    artistURL = (try? container.decode(URL.self, forKey: .artistViewUrl))
      ?? (try? additionalContainer.decode(URL.self, forKey: .collectionArtistViewUrl))
  }
}

// MARK: - Testing Data

extension StoreItem {
  static var testItems: [StoreItem] {
    guard let data = try? JSONDecoder().decode(SearchResponse<StoreItem>.self, from: testStoreItemsData) else {
      return []
    }
    return data.results
  }

  static var testTwoItems: [StoreItem] {
    guard let data = try? JSONDecoder().decode(SearchResponse<StoreItem>.self, from: testStoreItemsData) else {
      return []
    }
    let countOfElements = min(2, data.results.count)
    return Array(data.results[0..<countOfElements])
  }

  static var testItemDetail: StoreItem? {
    guard let data = try? JSONDecoder().decode(StoreItem.self, from: testStoreItemDetail) else {
      return nil
    }
    return data
  }
}
