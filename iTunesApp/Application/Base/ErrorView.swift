//
//  ErrorView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 15/04/2024.
//

import UIKit

final class ErrorView: UIView {

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    stackView.spacing = 21
    return stackView
  }()

  private var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .systemGray
    return imageView
  }()

  private var messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .systemGray
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureController(_ context: ErrorContext) {
    DispatchQueue.main.async {
      self.iconImageView.image = UIImage(
        systemName: context.iconName,
        size: 24,
        and: .medium
      )
      self.messageLabel.text = context.message
    }
  }
}

extension ErrorView: PrepareView {
  func setupViews() {
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(messageLabel)
    setupView(stackView)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
//      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    ])
  }
}
