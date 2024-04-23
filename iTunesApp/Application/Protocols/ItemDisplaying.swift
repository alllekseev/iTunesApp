//
//  ItemDisplaying.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

// TODO: check MainActor and Task in controller
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

    do {
      let image = try await UIImage.fetchImage(from: item.artworkURL)
      itemImageView.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancelation errors
    } catch {
      throw APIError.unknownError(error: error)
    }
  }
}
