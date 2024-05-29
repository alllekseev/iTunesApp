//
//  SearchSuggestion.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 23/04/2024.
//

import Foundation

struct SearchSuggestion: Hashable, Identifiable {
  let id = UUID()
  let name: String
  let artist: String

  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case collectionName = "collectionName"
    case artist = "artistName"
  }
}

extension SearchSuggestion: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = (try? container.decode(String.self, forKey: .name))
    ?? (try? container.decode(String.self, forKey: .collectionName)) ?? ""
    artist = try container.decode(String.self, forKey: .artist)
  }
}

extension SearchSuggestion: Comparable {
  static func < (lhs: SearchSuggestion, rhs: SearchSuggestion) -> Bool {
    lhs.name > rhs.name || lhs.artist > rhs.artist
  }
}

extension SearchSuggestion {
    var dictionaryRepresentation: [String: Any] {
        return ["name": name, "artist": artist]
    }
}
