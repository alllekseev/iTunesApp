//
//  NavigationController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

class NavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    config()
  }


  private func config() {
    let controllers = [MainCollectionViewController()]

    setViewControllers(controllers, animated: false)
  }

}
