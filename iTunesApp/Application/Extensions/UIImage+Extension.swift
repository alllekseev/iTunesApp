//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

extension UIImage {

  convenience init?(systemName: String, size: CGFloat, and weight: UIFont.Weight) {
    let font = UIFont.systemFont(ofSize: size, weight: weight)
    let configuration = UIImage.SymbolConfiguration(font: font)
    self.init(systemName: systemName, withConfiguration: configuration)
  }

  
  static func fetchImage(from url: URL?) async throws -> UIImage {

    guard let url = url else {
      throw APIError.notValidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode != 200 {
      throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
    }

    guard let image = UIImage(data: data) else {
      throw APIError.invalidData
    }

    return image
  }
}
