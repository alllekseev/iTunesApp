//
//  APIError.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 10/04/2024.
//

import Foundation

enum APIError: Error, LocalizedError {
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
      return ErrorMessageText.invalidData
    case .jsonParsingFailure:
      return ErrorMessageText.jsonParsingFailure
    case .requestFailed(let description):
      return "\(ErrorMessageText.requestFailed): \(description)"
    case .invalidStatusCode(let statusCode):
      return "\(ErrorMessageText.invalidStatusCode): \(statusCode)"
    case .unknownError(let error):
      return "\(ErrorMessageText.unknownError) \(error.localizedDescription)"
    case .itemsNotFound:
      return ErrorMessageText.itemsNotFound
    case .notValidURL:
      return ErrorMessageText.notValidURL
    }
  }
}
