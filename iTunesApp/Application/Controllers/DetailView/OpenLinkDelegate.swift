//
//  OpenLinkDelegate.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 15/05/2024.
//

import Foundation

protocol OpenLinkDelegate: AnyObject {
  func openLink(with url: URL?)
}
