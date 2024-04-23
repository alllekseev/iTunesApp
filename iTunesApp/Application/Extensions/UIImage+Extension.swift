//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

extension UIImage {
  static func fetchImage(from url: URL?) async throws -> UIImage {

    guard let url = url else {
      throw StoreAPIError.notValidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode != 200 {
      throw StoreAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
    }

    guard let image = UIImage(data: data) else {
      throw StoreAPIError.invalidData
    }

    return image
  }
}
