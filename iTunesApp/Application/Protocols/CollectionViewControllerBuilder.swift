//
//  CollectionViewControllerBuilder.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 12/04/2024.
//

import UIKit

protocol CollectionViewControllerBuilder {
  associatedtype Section: Hashable
  associatedtype ItemType: Hashable

  typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>

  var dataSource: DataSource! { get set }
  var items: [ItemType] { get set }
  var itemsSnapshot: Snapshot { get }

  func configureDataSource()
}
