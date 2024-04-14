//
//  SearchCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewListCell, ItemDisplaying {

  static let ID = String(describing: SearchCollectionViewCell.self)

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    stackView.alignment = .leading
    stackView.spacing = 5
    return stackView
  }()

  var itemImageView: UIImageView = {
    let imageView = UIImageView()
//    imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    return imageView
  }()

  var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return label
  }()

  var detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension SearchCollectionViewCell: PrepareView {
  func setupViews() {
    contentView.setupView(itemImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailLabel)
    contentView.setupView(stackView)
  }

  func configureConstraints() {
    NSLayoutConstraint.activate([
      itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      itemImageView.heightAnchor.constraint(equalToConstant: 50),
      itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),

      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
    ])
  }


}
