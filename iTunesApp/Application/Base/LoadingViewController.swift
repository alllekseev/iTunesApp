//
//  LoadingViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

final class LoadingViewController: UIViewController {
  let activityIndicator = UIActivityIndicatorView(style: .medium)

  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    view.addSubview(activityIndicator)
  }

  func startLoading() {
    activityIndicator.startAnimating()
  }

  func stopLoading() {
    activityIndicator.stopAnimating()
  }
}
