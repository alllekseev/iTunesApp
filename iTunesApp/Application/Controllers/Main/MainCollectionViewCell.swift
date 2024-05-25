//
//  MainCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

  static let ID = String(describing: MainCollectionViewCell.self)

  private struct Constants {
    static let stackViewSpacing: CGFloat = 2
    static let imageSize: CGFloat = 64
    static let systemFontSize: CGFloat = 16
    static let cellCornerRadius: CGFloat = 14
    static let verticalMargin: CGFloat = 20
    static let horizontalMargin: CGFloat = 16
    static let cellBorderWidht: CGFloat = 1
  }

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = Constants.stackViewSpacing
    return stackView
  }()

  private var itemImageView: UIImageView = {
    let imageView = UIImageView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: Constants.imageSize,
        height: Constants.imageSize
      )
    )
    imageView.backgroundColor = .systemBackground
    imageView.layer.cornerRadius = imageView.frame.height / 2
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Constants.systemFontSize, weight: .medium)
    label.textColor = .text
    return label
  }()

  private var authorLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Constants.systemFontSize, weight: .regular)
    label.textColor = .textLight
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for item: StoreItem) {
    titleLabel.text = item.name
    authorLabel.text = item.artist

    if let url = item.artworkURL {
      itemImageView.loadImage(from: url as NSURL)
    }
  }
}

extension MainCollectionViewCell: PrepareView {

  func prepareUI() {
    setupViews()
    configureConstraints()
    configureCellAppearance()

    registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection) in
      self.layer.borderColor = UIColor.border.cgColor
    }
  }

  func setupViews() {
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(authorLabel)

    setupView(itemImageView)
    setupView(stackView)
  }

  func configureConstraints() {
    NSLayoutConstraint.activate([

      itemImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalMargin),
      itemImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      itemImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
      itemImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

      stackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: Constants.verticalMargin),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalMargin),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalMargin),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalMargin)
    ])
  }

  func configureCellAppearance() {
    backgroundColor = .itemBackground
    layer.cornerRadius = Constants.cellCornerRadius
    layer.borderWidth = Constants.cellBorderWidht
    self.layer.borderColor = UIColor.border.cgColor
  }
}
