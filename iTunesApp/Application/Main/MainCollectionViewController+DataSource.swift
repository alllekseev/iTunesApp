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
      // FIXME: Remove Task from here
      self.imageLoadTask[indexPath]?.cancel()
      self.imageLoadTask[indexPath] = Task {
        try? await cell.configure(for: item)
        self.imageLoadTask[indexPath] = nil
      }
      return cell
    }
  }
}
