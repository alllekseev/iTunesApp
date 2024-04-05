//
//  APIService.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

struct iTunesSearchService: APIRequest {

  typealias Response = SearchResponse

  var path: Endpoints { .search }

  var queryItems: [URLQueryItem]
}
