//
//  SearchBarTextDelegate.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 14/04/2024.
//

import Foundation

protocol SearchBarTextDelegate: AnyObject {
  func searchTextDidChange(_ searchText: String)
}
