//
//  SearchItemCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 29/05/2024.
//

import UIKit

final class SearchItemCollectionViewCell: UICollectionViewListCell {

  static let reuseIdentifier = String(describing: SearchItemCollectionViewCell.self)

  var text: NSAttributedString = NSAttributedString(string: "")

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
    imageView.image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration)
    imageView.tintColor = .systemGray
    return imageView
  }()

  private let textLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(_ text: NSAttributedString) {
    textLabel.attributedText = text
    self.text = textLabel.attributedText ?? NSAttributedString(string: "")
  }

}

extension SearchItemCollectionViewCell: PrepareView {
  func setupViews() {
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(textLabel)

    setupView(stackView)
  }
  
  func configureConstraints() {

    iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    ])
  }
  

}
