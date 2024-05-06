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

  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case collectionName = "collectionName"
  }
}

extension SearchSuggestion: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = (try? container.decode(String.self, forKey: .name))
    ?? (try? container.decode(String.self, forKey: .collectionName)) ?? ""
  }
}
