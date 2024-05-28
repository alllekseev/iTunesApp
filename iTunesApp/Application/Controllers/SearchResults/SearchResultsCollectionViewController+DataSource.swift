//
//  SearchResultsCollectionViewController+DataSource.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 28/05/2024.
//

import UIKit

// MARK: - Configure DataSource

extension SearchResultsCollectionViewController {
  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      collectionView,
      indexPath,
      item in
      switch item {
      case .history(let storeItem):
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier,
          for: indexPath
        ) as! SearchHistoryCollectionViewCell
        cell.configureCell(for: storeItem)
        return cell
      case .results(let resultsItem):
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: self.ID,
          for: indexPath
        ) as! UICollectionViewListCell

        var contentConfiguration = cell.defaultContentConfiguration()
        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 16))
        contentConfiguration.image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration)
        contentConfiguration.imageProperties.tintColor = .systemGray

        let resultText = resultsItem.name
        contentConfiguration.textProperties.color = .systemGray
        if let attributedText = self.attributedString(from: resultText) {
          contentConfiguration.attributedText = attributedText
        } else {
          contentConfiguration.text = resultText
        }

        cell.contentConfiguration = contentConfiguration
        return cell
      }
    }

    dataSource.supplementaryViewProvider = {
      collectionView,
      kind,
      indexPath -> UICollectionReusableView? in

      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: SupplementaryViewKind.header,
        withReuseIdentifier: SectionHeaderView.reuseIdentifier,
        for: indexPath
      ) as! SectionHeaderView
      headerView.delegate = self

      return headerView
    }

//    updateSnapshot()
//    dataSource.apply(itemsSnapshot)
  }

  private func attributedString(from resultText: String) -> NSMutableAttributedString? {
    guard let range = resultText.range(of: searchText, options: .caseInsensitive) else {
      return nil
    }
    let attributedString = NSMutableAttributedString(string: resultText)
    attributedString.addAttributes(
      [
        .font: UIFont.boldSystemFont(ofSize: 17),
        .foregroundColor: UIColor.label
      ],
      range: NSRange(range, in: resultText)
    )
    return attributedString
  }
}
