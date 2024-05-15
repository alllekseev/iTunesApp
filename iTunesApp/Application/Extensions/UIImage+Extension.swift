//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

extension UIImage {
  convenience init?(systemName: String, size: CGFloat, and weight: UIFont.Weight) {
    let font = UIFont.systemFont(ofSize: size, weight: weight)
    let configuration = UIImage.SymbolConfiguration(font: font)
    self.init(systemName: systemName, withConfiguration: configuration)
  }
}
