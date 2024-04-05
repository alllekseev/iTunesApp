//
//  SearchResponse.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

struct SearchResponse: Decodable {
  let result: [StoreItem]
}
