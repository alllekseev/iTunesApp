//
//  ImageCache.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 13/05/2024.
//

import UIKit

final class ImageCache {
  public static let shared = ImageCache()

  var placeholderImage = UIImage(systemName: "rectangle")!
  private let cachedImages = NSCache<NSURL, UIImage>()
  private var loadingResponses = [NSURL: [(StoreItem, UIImage?) -> Void]]()

  func image(url: NSURL) -> UIImage? {
    cachedImages.object(forKey: url)
  }

  func load(
    url: NSURL,
    item: StoreItem,
    completion: @escaping (StoreItem, UIImage?) -> Void
  ) {
    if let cachedImage = image(url: url) {
      DispatchQueue.main.async {
        completion(item, cachedImage)
      }
      return
    }

    if loadingResponses[url] != nil {
      loadingResponses[url]?.append(completion)
      return
    } else {
      loadingResponses[url] = [completion]
    }

    URLSession.shared.dataTask(with: url as URL) {
      [weak self] (data, response, error) in

      guard let self = self,
            let responseData = data,
            let image = UIImage(data: responseData),
            let blocks = self.loadingResponses[url],
            error == nil else {
        DispatchQueue.main.async {
          completion(item, nil)
        }
        return
      }

      self.cachedImages.setObject(image, forKey: url, cost: responseData.count)

      for block in blocks {
        DispatchQueue.main.async {
          block(item, image)
        }
      }

      self.loadingResponses[url] = nil
    }.resume()
  }

}
