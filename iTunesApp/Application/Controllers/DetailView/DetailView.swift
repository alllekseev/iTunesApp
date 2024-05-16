//
//  DetailView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 07/05/2024.
//

import UIKit

// TODO: add title in navigation bar while scrolling

final class DetailView: UIView {

  weak var delegate: OpenLinkDelegate?

  private var scrollView = UIScrollView()

  private var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    return view
  }()

  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.alignment = .leading
    stackView.spacing = 16
    return stackView
  }()

  private let nameStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.alignment = .leading
    stackView.spacing = 8
    return stackView
  }()

  private let authorStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.spacing = 8
    return stackView
  }()

  private let descriptionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.alignment = .leading
    stackView.spacing = 8
    return stackView
  }()

  private let itemImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 20
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 0.5
    imageView.layer.borderColor = UIColor.border.cgColor
    imageView.image = UIImage(systemName: "rectangle")!
    return imageView
  }()

  private lazy var authorLinkButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0))
    button.setImage(UIImage(systemName: "arrow.up.right.square", withConfiguration: imageConfig), for: .normal)
    button.tintColor = .systemBlue
    button.addTarget(self, action: #selector(authorLinkTapped), for: .touchUpInside)
    return button
  }()

  private let nameLabel = TextLabel(size: 22, weight: .semibold, color: .text)
  private let typeContentLabel = TextLabel(size: 16, weight: .medium, color: .textLight)
  private let authorNameLabel = TextLabel(size: 20, weight: .regular, color: .textLight)
  private let descriptionHeaderLabel = TextLabel(size: 20, weight: .semibold, color: .text)

  private let descriptionTextLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .textLight
    label.numberOfLines = 0
    return label
  }()

  init(itemDetails: StoreItem) {
    super.init(frame: .zero)
    prepareUI()

    if let url = itemDetails.artworkURL {
      itemImageView.loadImage(from: url as NSURL, item: itemDetails)
    }
    nameLabel.text = itemDetails.name
    typeContentLabel.text = itemDetails.kind
    authorNameLabel.text = itemDetails.artist

    if !itemDetails.description.isEmpty {
      descriptionHeaderLabel.text = NSLocalizedString("Описание", comment: "header for detail block of items")
      descriptionTextLabel.text = itemDetails.description
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func authorLinkTapped() {
    delegate?.openLink()
  }
}

extension DetailView: PrepareView {
  func prepareUI() {
    configureAppearance()
    setupViews()
    configureConstraints()
  }

  func setupViews() {
    nameStackView.addArrangedSubview(nameLabel)
    nameStackView.addArrangedSubview(typeContentLabel)

    authorStackView.addArrangedSubview(authorNameLabel)
    authorStackView.addArrangedSubview(authorLinkButton)

    descriptionStackView.addArrangedSubview(descriptionHeaderLabel)
    descriptionStackView.addArrangedSubview(descriptionTextLabel)

    containerStackView.addArrangedSubview(nameStackView)
    containerStackView.addArrangedSubview(authorStackView)
    containerStackView.addArrangedSubview(descriptionStackView)

    contentView.setupView(itemImageView)
    contentView.setupView(containerStackView)
    scrollView.setupView(contentView)
    setupView(scrollView)
  }
  
  func configureConstraints() {
    let containerViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
    containerViewCenterY.priority = .defaultLow

    let containerViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor)
    containerViewHeight.priority = .defaultLow

    NSLayoutConstraint.activate([

      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

      contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      containerViewCenterY,
      containerViewHeight,

      itemImageView.widthAnchor.constraint(equalToConstant: 100),
      itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 1),
      itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      containerStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 20),
      containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
      containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }

  func configureAppearance() {
    backgroundColor = .systemBackground
    scrollView.showsVerticalScrollIndicator = false
    nameLabel.numberOfLines = 0
  }
}

// MARK: - Text Label

fileprivate class TextLabel: UILabel {
  // TODO: change to struct?

  init(size: CGFloat, weight: UIFont.Weight, color: UIColor) {
    super.init(frame: .zero)
    self.font = UIFont.systemFont(ofSize: size, weight: weight)
    self.textColor = color
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
