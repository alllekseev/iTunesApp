//
//  ErrorContext.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 23/04/2024.
//

import Foundation

struct ErrorContext {
  var message: String
  var iconName: String = "magnifyingglass"

  init(message: String) {
    self.message = message
  }
}
