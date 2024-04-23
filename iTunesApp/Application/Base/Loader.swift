//
//  Loader.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

struct Loader {
  let style: UIActivityIndicatorView.Style = .large

  var indicator: UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: style)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }
}
