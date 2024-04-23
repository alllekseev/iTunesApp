//
//  StateManager.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/04/2024.
//

import Foundation

enum State {
  case empty
  case loading
  case loaded([StoreItem])
  case error(APIError)
}

final class StateManager {

  var state: State {
    didSet {

      DispatchQueue.main.async {
        self.updateUI()
      }
    }
  }

  var updateUI: (() -> Void)

  init(updateUI: @escaping () -> Void) {
    self.updateUI = updateUI
    state = .empty
  }
}
