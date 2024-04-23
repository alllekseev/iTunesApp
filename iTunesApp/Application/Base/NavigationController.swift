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
    //    navigationBar.isTranslucent = false
    let layout = UICollectionViewLayout()
    let controllers = [MainCollectionViewController(collectionViewLayout: layout)]

    setViewControllers(controllers, animated: false)
  }

}
