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
          withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier,
          for: indexPath
        ) as! SearchItemCollectionViewCell

        let searchText = self.searchText.trimmingCharacters(in: .whitespaces)

        let text: NSAttributedString

        if resultsItem.name.lowercased().contains(searchText.lowercased()) {
          text = self.highlightMathces(in: resultsItem.name, searchString: searchText)
        } else if resultsItem.artist.lowercased().contains(searchText.lowercased()) {
          text = self.highlightMathces(in: resultsItem.artist, searchString: searchText)
        } else {
          text = NSAttributedString(string: resultsItem.name)
        }
        
        cell.configureCell(text)
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
  }

  private func highlightMathces(in text: String, searchString: String) -> NSAttributedString {
    let lowecasedText = text.lowercased()
    let lowercasedSearchString = searchString.lowercased()

    guard let range = lowecasedText.range(of: lowercasedSearchString) else {
      return NSAttributedString(string: text)
    }

    let nsRange = NSRange(range, in: text)
    let highlightedText = NSMutableAttributedString(string: text)
    highlightedText.addAttribute(.foregroundColor, value: UIColor.label, range: nsRange)

    return highlightedText
  }
}
