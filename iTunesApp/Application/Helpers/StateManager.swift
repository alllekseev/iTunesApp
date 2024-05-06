//
//  StateManager.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 18/04/2024.
//

import Foundation

class StateManager<Element: Decodable> {

  enum State {
    case empty
    case loading
    case loaded([Element])
    case error(APIError)
  }

  var updateUI: (() -> Void)

  var state: State {
    didSet {

      DispatchQueue.main.async { [weak self] in
        self?.updateUI()
      }
    }
  }

  init(updateUI: @escaping () -> Void) {
    self.updateUI = updateUI
    state = .empty
  }
}
