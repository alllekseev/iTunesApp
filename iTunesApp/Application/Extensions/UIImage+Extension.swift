//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

extension UIImage {
  func fetchImage(from url: URL) async throws -> UIImage {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw APIRequestError.imageDataMissing
    }

    guard let image = UIImage(data: data) else {
      throw APIRequestError.imageDataMissing
    }

    return image
  }
}
