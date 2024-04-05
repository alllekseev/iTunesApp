//
//  SearchResponse.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

struct SearchResponse<Response: Decodable>: Decodable {
  let results: [Response]
}
