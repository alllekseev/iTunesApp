//
//  APIRequest.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

enum APIRequestError: Error {
  case itemsNotFound
  case requestFailed
  case notValidURL
}

protocol APIRequest {
  associatedtype Response

  var path: Endpoints { get }
  var queryItems: [URLQueryItem] { get }
  var request: URLRequest { get }
}

extension APIRequest {
  var host: String { "" }
}

extension APIRequest {
  var request: URLRequest {
    var components = URLComponents()

    components.scheme = "https"
    components.host = host
    components.path = path.rawValue
    components.queryItems = queryItems

    guard let url = components.url else {
      print(APIRequestError.notValidURL)
    }

    return URLRequest(url: url)
  }
}

extension APIRequest where Response: Decodable {

  func send() async throws -> Response {
    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw APIRequestError.itemsNotFound
    }

    let decoded = try JSONDecoder().decode(Response.self, from: data)

    return decoded
  }
}