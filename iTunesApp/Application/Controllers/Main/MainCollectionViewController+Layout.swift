//
//  MainCollectionViewController+Layout.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 25/05/2024.
//

import UIKit

extension MainCollectionViewController {

  func configureLayout() -> UICollectionViewLayout {
    let sectionSpacing: CGFloat = 16
    let innerSpacing: CGFloat = 14
    let subitemsCount = 2

    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalWidth(0.5)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: subitemsCount
    )
    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(innerSpacing)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: sectionSpacing,
      leading: sectionSpacing,
      bottom: sectionSpacing,
      trailing: sectionSpacing
    )
    section.interGroupSpacing = innerSpacing

    return UICollectionViewCompositionalLayout(section: section)
  }
}
