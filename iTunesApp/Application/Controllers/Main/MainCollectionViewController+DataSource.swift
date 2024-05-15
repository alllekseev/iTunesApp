//
//  MainCollectionViewController+DataSource.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 17/04/2024.
//

import UIKit

extension MainCollectionViewController {
  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MainCollectionViewCell.ID,
        for: indexPath
      ) as! MainCollectionViewCell
      cell.configure(for: item)
      return cell
    }
  }
}
