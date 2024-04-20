//
//  StoreAPIError.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 10/04/2024.
//

import Foundation

//timecode: 2:10:00

enum StoreAPIError: Error, LocalizedError {
  case invalidData
  case jsonParsingFailure
  case requestFailed(description: String)
  case invalidStatusCode(statusCode: Int)
  case unknownError(error: Error)
  case itemsNotFound
  case notValidURL

  var customDescription: String {
    switch self {
    case .invalidData:
      return "Invalid data"
    case .jsonParsingFailure:
      return "Failed to parse JSON"
    case .requestFailed(let description):
      return "Request failed: \(description)"
    case .invalidStatusCode(let statusCode):
      return "Invalid status code: \(statusCode)"
    case .unknownError(let error):
      return "An unknown error occured \(error.localizedDescription)"
    case .itemsNotFound:
      return "Items not found"
    case .notValidURL:
      return "Check URL"
    }
  }
}
