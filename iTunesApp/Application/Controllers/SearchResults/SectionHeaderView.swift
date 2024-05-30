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
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 16
    return stackView
  }()

  private let titileLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textColor = .text
    label.text = Strings.historyBlockHeader
    return label
  }()

  private lazy var resetButton: UIButton = {
    let button = UIButton()
    button.setTitle(Strings.clearBittonTitle, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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

    titileLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    titileLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    resetButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    resetButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

    NSLayoutConstraint.activate([
      sectionStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      sectionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      sectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      sectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

//      resetButton.leadingAnchor.constraint(equalTo: titileLabel.trailingAnchor, constant: 16),
//      resetButton.trailingAnchor.constraint(equalTo: sectionStackView.trailingAnchor),
    ])
  }
  

}
