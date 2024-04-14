//
//  QueryItems.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

struct QueryItems {
  let term: String
  let mediaType: String
  var language: Language = .russian
  let elementsAmount: Int = 30

  var searchTerm: String {
    term.replacingOccurrences(of: " ", with: "+")
  }

  enum Language: String {
    case english = "en_en"
    case russian = "ru_ru"
  }

  var queryItems: [URLQueryItem] {
    let queryItems = [
      "term": "\(searchTerm)",
      "entity": "\(mediaType)",
      "lang": language.rawValue,
      "limit": "\(elementsAmount)"
    ]

    return queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
  }
}
