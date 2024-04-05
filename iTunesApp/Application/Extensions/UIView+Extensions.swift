//
//  UIView+Extensions.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

extension UIView {
  func setupView(_ view: UIView) {
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
  }

  func addDebugOutline(with color: UIColor = .red) {
    layer.borderWidth = 1
    layer.borderColor = color.cgColor
  }
}
