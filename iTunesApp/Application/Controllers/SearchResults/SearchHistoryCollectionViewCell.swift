//
//  SearchHistoryCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 20/05/2024.
//

import UIKit

final class SearchHistoryCollectionViewCell: UICollectionViewListCell {
  
  static let reuseIdentifier = String(describing: SearchHistoryCollectionViewCell.self)

  private let labelsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .leading
    stackView.spacing = 2
    return stackView
  }()

  private let cellImageView: UIImageView = {
    let imageView = UIImageView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: 60,
        height: 60
      )
    )
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.layer.masksToBounds = true
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textColor = .text
    return label
  }()

  private let authorLable: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .textLight
    return label
  }()

  private let detailButton: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: "chevron.right", size: 24, and: .semibold)
    button.setImage(image, for: .normal)
    button.tintColor = .systemGray
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(for searchHistoryItem: StoreItem) {
    if let url = searchHistoryItem.artworkURL {
      cellImageView.loadImage(from: url as NSURL)
    }
    titleLabel.text = searchHistoryItem.name
    authorLable.text = searchHistoryItem.artist
  }
}

extension SearchHistoryCollectionViewCell: PrepareView {
  func setupViews() {
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(authorLable)

    setupView(cellImageView)
    setupView(labelsStackView)
    setupView(detailButton)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([

      cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//      cellImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      cellImageView.trailingAnchor.constraint(equalTo: labelsStackView.leadingAnchor, constant: -8),
      cellImageView.heightAnchor.constraint(equalToConstant: 60),
      cellImageView.widthAnchor.constraint(equalToConstant: 60),

      labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      labelsStackView.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -8),

      detailButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      detailButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    ])
  }
}
