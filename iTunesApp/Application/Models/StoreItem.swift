//
//  StoreItem.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

struct StoreItem: Hashable {
  let name: String
  let artist: String
  let kind: String
  let description: String
  let collection: String
  let artworkURL: URL
  

}

extension StoreItem: Decodable {
  init(from decoder: Decoder) throws {
    <#code#>
  }
}
