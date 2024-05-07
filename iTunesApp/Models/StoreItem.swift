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
  let artworkURL: URL?
  let trackId: Int?
  let collectionId: Int?

  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case artist = "artistName"
    case kind
    case description = "longDescription"
    case artworkURL = "artworkUrl100"
    case trackId
    case collectionId
  }

  enum AdditionalKeys: String, CodingKey {
    case description = "shortDescription"
    case collectionName = "collectionName"
  }

  static var testData: [StoreItem] {
    guard let data = try? JSONDecoder().decode(SearchResponse<StoreItem>.self, from: testStoreItemsData) else {
      return []
    }
    return data.results
  }
}

extension StoreItem: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    artist = try container.decode(String.self, forKey: .artist)
    kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
    artworkURL = try? container.decode(URL.self, forKey: .artworkURL)
    trackId = try? container.decode(Int.self, forKey: .trackId)
    collectionId = try? container.decode(Int.self, forKey: .collectionId)

    let additionalContainer = try decoder.container(keyedBy: AdditionalKeys.self)
    name = (try? container.decode(String.self, forKey: .name))
        ?? (try? additionalContainer.decode(String.self, forKey: .collectionName)) ?? ""
    description = (try? container.decode(String.self, forKey: .description))
        ?? (try? additionalContainer.decode(String.self, forKey: .description))
        ?? ""
  }
}
