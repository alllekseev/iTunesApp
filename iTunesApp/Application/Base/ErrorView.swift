//
//  ErrorView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 15/04/2024.
//

import UIKit

struct ErrorMessage {
  var message: String
  var iconName: String = "magnifyingglass"

  init() {
    message = ""
  }

  var icon: UIImage {
    let font = UIFont.systemFont(ofSize: 24, weight: .medium)
    let configuration = UIImage.SymbolConfiguration(font: font)
    return UIImage(systemName: iconName, withConfiguration: configuration)!
  }
}

extension UIColor {
  static let greyColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 0.3)
}

final class ErrorView: UIViewController {

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
    imageView.tintColor = .greyColor
    return imageView
  }()

  private var messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .greyColor
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    prepareUI()
  }

  func configureController(errorMessage: ErrorMessage) {
    DispatchQueue.main.async {
      self.iconImageView.image = errorMessage.icon
      self.messageLabel.text = errorMessage.message
    }
  }
}

extension ErrorView: PrepareView {
  func setupViews() {
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(messageLabel)
    view.setupView(stackView)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
//      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
}
