//
//  SearchTableViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

final class SearchTableViewCell: UITableViewCell, ItemDisplaing {

  static let ID = String(describing: SearchTableViewCell.self)

  var itemImageView: UIImageView = {
    let imageView = UIImageView()

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

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: .default,
      reuseIdentifier: SearchTableViewCell.ID
    )
    prepareUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SearchTableViewCell: PrepareView {
  func setupViews() {
    setupView(itemImageView)
    setupView(titleLabel)
    setupView(detailLabel)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
      itemImageView.heightAnchor.constraint(equalToConstant: 100),
      itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
      itemImageView.topAnchor.constraint(equalTo: topAnchor),
      itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      itemImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      itemImageView.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
      itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor),
      titleLabel.lastBaselineAnchor.constraint(equalTo: detailLabel.firstBaselineAnchor),

      detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor)

    ])
  }
}
