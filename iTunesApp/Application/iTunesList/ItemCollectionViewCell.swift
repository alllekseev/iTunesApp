//
//  ItemCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

  static let ID = String(describing: ItemCollectionViewCell.self)

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()

  private var itemImageView: UIImageView = {
    let imageView = UIImageView()

    return imageView
  }()

  private var titleLabel: UILabel = {
    let label = UILabel()
    label.contentMode = .left
    return label
  }()

  var detailLabel: UILabel = {
    let label = UILabel()
    label.contentMode = .left
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  func configure(for item: StoreItem) async {
    titleLabel.text = item.name
    detailLabel.text = item.artist
    itemImageView.image = UIImage(systemName: "photo")

    do {
      let image = try await UIImage().fetchImage(from: item.artworkURL)

      self.itemImageView.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancelation errors
    } catch {
      self.itemImageView.image = UIImage(systemName: "photo")
      print("Error fetching image: \(error)")
    }
  }
}

extension ItemCollectionViewCell {
  func prepareUI() {
    setupViews()
    configureConstraints()
  }

  func setupViews() {

  }

  func configureConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}
