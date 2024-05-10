//
//  PrepareView.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

// TODO: add method configureAppearance and check in all classes
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
