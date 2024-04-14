//
//  APIService.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

// TODO: rename struct
struct iTunesSearchService: APIRequest {

  typealias Response = StoreItem

  var path: Endpoints { .search }

  var queryItems: [URLQueryItem] = []
}
