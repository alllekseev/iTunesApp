//
//  MainCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell, ItemDisplaying {

  static let ID = String(describing: MainCollectionViewCell.self)

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.spacing = 4
    return stackView
  }()

  var itemImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  var titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  var detailLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

//  func configure(for item: StoreItem) async {
//    titleLabel.text = item.name
//    detailLabel.text = item.artist
//    itemImageView.image = UIImage(systemName: "photo")
//
//    do {
//      let image = try await UIImage().fetchImage(from: item.artworkURL)
//
//      self.itemImageView.image = image
//    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
//      // ignore cancelation errors
//    } catch {
//      self.itemImageView.image = UIImage(systemName: "photo")
//      print("Error fetching image: \(error)")
//    }
//  }
}

extension MainCollectionViewCell: PrepareView {
  func setupViews() {
    stackView.addArrangedSubview(itemImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailLabel)
    setupView(stackView)

    backgroundColor = .gray.withAlphaComponent(0.4)
  }

  func configureConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
}
