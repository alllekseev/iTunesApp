//
//  SearchResultsCollectionViewController+Layout.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 28/05/2024.
//

import UIKit

// MARK: - Configure List Layout
extension SearchResultsCollectionViewController {
  
  func configureListLayout() -> UICollectionViewLayout {
    let verticalSpacing: CGFloat = 0
    let horizontalSpacing: CGFloat = 4

    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.backgroundColor = .clear

    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

      let section = self.sections[sectionIndex]

      let headerItemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.92),
          heightDimension: .estimated(44))
      let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerItemSize,
          elementKind: SupplementaryViewKind.header, alignment: .top)
      headerItem.contentInsets = NSDirectionalEdgeInsets(
        top: verticalSpacing,
        leading: horizontalSpacing,
        bottom: verticalSpacing,
        trailing: horizontalSpacing
      )

      let supplementaryItemContentInsets = NSDirectionalEdgeInsets(
        top: verticalSpacing,
        leading: horizontalSpacing,
        bottom: verticalSpacing,
        trailing: horizontalSpacing
      )

      headerItem.contentInsets = supplementaryItemContentInsets

      switch section {
      case .histroy:
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
        section.boundarySupplementaryItems = [headerItem]
        return section
      case .results:
        listConfiguration.itemSeparatorHandler = {
          (indexPath, sectionSeparatorConfiguration) in
          var configuration = sectionSeparatorConfiguration
          configuration.topSeparatorInsets.leading = 0
          configuration.bottomSeparatorInsets.leading = 0
          return configuration
        }
        return NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
      }
    }

    return layout
  }
}
