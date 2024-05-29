//
//  ActivityIndicator.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

struct ActivityIndicator {
  let view: UIView
  private let activityIndicatorTag: Int = 100
  private let activityIndicator: UIActivityIndicatorView

  init(view: UIView, style: UIActivityIndicatorView.Style = .medium) {
    self.view = view
    self.activityIndicator = UIActivityIndicatorView(style: style)
  }

  func showIndicator() {
    addIndicatorOnView()
    activityIndicator.startAnimating()
  }

  func hideIndicator() {
    activityIndicator.stopAnimating()
    removeIndicatorFromView()
  }

  private func addIndicatorOnView() {
    activityIndicator.center = CGPoint(
      x: view.bounds.midX,
      y: view.bounds.midY
    )
    activityIndicator.tag = activityIndicatorTag
    view.addSubview(activityIndicator)
  }

  private func removeIndicatorFromView() {
    view.subviews.first(where: { $0.tag == activityIndicatorTag })?.removeFromSuperview()
  }
}
