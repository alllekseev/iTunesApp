//
//  UIImageView+Extension.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 15/05/2024.
//

import UIKit

extension UIImageView {
  private static let imageCache = ImageCache.shared

  func loadImage(
    from url: NSURL,
    item: StoreItem
  ) {
    let activityIndicator = ActivityIndicator(view: self)
    self.image = nil
    activityIndicator.showIndicator()

    UIImageView.imageCache.load(
      url: url,
      item: item
    ) { [weak self] (fetchedItem, image) in
      guard let self = self else {
        activityIndicator.hideIndicator()
        return
      }

      activityIndicator.hideIndicator()

      if let image = image {
        self.image = image
      } else {
        self.image = UIImageView.imageCache.placeholderImage
      }
    }
  }
}
