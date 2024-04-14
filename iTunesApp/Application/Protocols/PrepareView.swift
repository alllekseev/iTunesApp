//
//  PrepareView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

protocol PrepareView {
  func setupViews()
  func configureConstraints()
  func prepareUI()
}

extension PrepareView {
  func prepareUI() {
    setupViews()
    configureConstraints()
  }
}
