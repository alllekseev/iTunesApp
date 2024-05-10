//
//  MainCollectionViewCell.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell, ItemDisplaying {

  static let ID = String(describing: MainCollectionViewCell.self)

  private lazy var textGradientContainer: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0.5, width: self.bounds.width, height: self.bounds.height))

    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    gradient.colors = [
      UIColor.black.withAlphaComponent(0.0).cgColor,
      UIColor.black.withAlphaComponent(0.5).cgColor
    ]
    gradient.locations = [0.0, 0.6]

    view.layer.insertSublayer(gradient, at: 0)
    return view
  }()

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillEqually
    stackView.spacing = 2
    return stackView
  }()

  lazy var itemImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()

  var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .white
    return label
  }()

  var detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .white.withAlphaComponent(0.8)
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

extension MainCollectionViewCell: PrepareView {

  func prepareUI() {
    setupViews()
    configureConstraints()
    configureCellAppearance()
  }

  func setupViews() {
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailLabel)

    textGradientContainer.setupView(stackView)

    setupView(textGradientContainer)
  }

  func configureConstraints() {
    NSLayoutConstraint.activate([
      textGradientContainer.topAnchor.constraint(equalTo: topAnchor, constant: 81),
      textGradientContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
      textGradientContainer.widthAnchor.constraint(equalTo: widthAnchor),
      textGradientContainer.centerXAnchor.constraint(equalTo: centerXAnchor),

      stackView.topAnchor.constraint(equalTo: textGradientContainer.topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: textGradientContainer.leadingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: textGradientContainer.bottomAnchor, constant: -20),
      stackView.trailingAnchor.constraint(equalTo: textGradientContainer.trailingAnchor, constant: -16)
    ])
  }

  func configureCellAppearance() {
    layer.cornerRadius = 14
    layer.masksToBounds = true
    backgroundView = itemImageView
  }
}
