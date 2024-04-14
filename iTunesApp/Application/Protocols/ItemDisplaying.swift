//
//  ItemDisplaying.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

protocol ItemDisplaying {
  var itemImageView: UIImageView { get set }
  var titleLabel: UILabel { get set }
  var detailLabel: UILabel { get set }
}

@MainActor
extension ItemDisplaying {
  func configure(for item: StoreItem) async throws {
    titleLabel.text = item.name
    detailLabel.text = item.artist
    itemImageView.image = UIImage(systemName: "photo")

    do {
      guard let itemImageURL = item.artworkURL else {
        return
      }

      let image = try await UIImage.fetchImage(from: itemImageURL)



      itemImageView.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancelation errors
    } catch {

      print("DEBUG Error fetching image: \(error)")
      throw APIRequestError.imageDataMissing
    }
  }
}
