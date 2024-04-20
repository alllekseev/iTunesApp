//
//  QueryItems.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

struct QueryItems {
  typealias SearchScope = String

  let term: String
  let mediaType: SearchScope
  var language: Language = .english
  let elementsAmount: Int = 30

  var searchTerm: String {
    term.replacingOccurrences(of: " ", with: "+")
  }

  enum Language: String {
    case english = "en_us"
    case russian = "ru_ru"
  }

  var queryItems: [URLQueryItem] {
    let queryItems = [
      "term": "\(searchTerm)",
      "media": "\(mediaType)",
      "lang": language.rawValue,
      "limit": "\(elementsAmount)"
    ]

    return queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
  }
}
