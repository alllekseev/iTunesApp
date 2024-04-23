//
//  APIRequest.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

protocol APIRequest {
  associatedtype Response

  var path: Endpoints { get }
  var queryItems: [URLQueryItem] { get }
  var request: URLRequest? { get }
}

extension APIRequest {
  var host: String { "itunes.apple.com" }
}

extension APIRequest {
  var request: URLRequest? {
    var components = URLComponents()

    components.scheme = "https"
    components.host = host
    components.path = path.rawValue
    components.queryItems = queryItems

    guard let url = components.url else {
      return nil
    }

    return URLRequest(url: url)
  }
}

extension APIRequest where Response: Decodable {

  func fetchItems() async throws -> [Response] {
    guard let request = request else {
      throw APIError.notValidURL
    }
    let (data, response) = try await URLSession.shared.data(for: request)

    if let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode != 200 {
      throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
    }

    guard let decoded = try? JSONDecoder().decode(SearchResponse<Response>.self, from: data) else {
      throw APIError.jsonParsingFailure
    }

    guard !decoded.results.isEmpty else {
      throw APIError.itemsNotFound
    }

    return decoded.results
  }
}
