//
//  SectionHeaderView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 21/05/2024.
//

import UIKit

protocol ClearHistoryDelegate: AnyObject {
  func clearHistory()
}

final class SectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: SectionHeaderView.self)

  weak var delegate: ClearHistoryDelegate?

  private let sectionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    return stackView
  }()

  private let titileLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = .text
    label.text = "Resently Searched"
    return label
  }()

  private lazy var resetButton: UIButton = {
    let button = UIButton()
    button.setTitle("Clear", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(tappedClearHistory), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func tappedClearHistory() {
    delegate?.clearHistory()
  }
}

extension SectionHeaderView: PrepareView {
  func setupViews() {
    sectionStackView.addArrangedSubview(titileLabel)
    sectionStackView.addArrangedSubview(resetButton)

    setupView(sectionStackView)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
      sectionStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      sectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      sectionStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      sectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    ])
  }
  

}
