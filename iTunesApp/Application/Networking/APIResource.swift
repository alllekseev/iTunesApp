//
//  APIResource.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 08/04/2024.
//

import Foundation

protocol APIResource {
  associatedtype Response: Decodable

  var path: Endpoints { get }
  var queryItems: [URLQueryItem] { get }
  var request: URLRequest? { get }
}

extension APIResource {
  var host: String { "itunes.apple.com" }
}

extension APIResource {
  var request: URLRequest? {
    var components = URLComponents()

    components.scheme = "https"
    components.host = host
    components.path = path.rawValue
    components.queryItems = queryItems

    guard let url = components.url else {
      print(StoreAPIError.notValidURL)
      return nil
    }

    return URLRequest(url: url)
  }
}
