//
//  SearchCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

final class SearchCollectionViewController: UICollectionViewController, CollectionViewControllerBuilder {

  struct SuggestionResults: Hashable, Identifiable {
    let id = UUID()
    let resultString: String
  }

  typealias Section = Int
  typealias ItemType = SuggestionResults

  let ID = "cell"

  let loadingViewController = LoadingViewController()

  var dataSource: DataSource!
  var items: [ItemType] = []
  var itemsSnapshot: Snapshot {
    var snaphot = Snapshot()
    snaphot.appendSections([0])
    snaphot.appendItems(items)
    return snaphot
  }

  var searchTask: Task<Void, Never>? = nil
  var imageLoadTask: [IndexPath: Task<Void, Error>] = [:]

  private var searchText: String = ""

  private var error: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: ID)

    let listLayout = listLayout()
    collectionView.collectionViewLayout = listLayout

    configureDataSource()

//    configureLoadingController()
  }

  func configureLoadingController() {
    addChild(loadingViewController)
    view.addSubview(loadingViewController.view)
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewListCell? in

      guard self.error == nil else {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: self.ID,
          for: indexPath
        ) as! UICollectionViewListCell

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = self.error

        cell.contentConfiguration = contentConfiguration
        return cell
      }

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: self.ID,
        for: indexPath
      ) as! UICollectionViewListCell

      var contentConfiguration = cell.defaultContentConfiguration()

      let resultText = item.resultString

      if let attributedText = self.attributedString(from: resultText) {
        contentConfiguration.attributedText = attributedText
      } else {
        contentConfiguration.text = item.resultString
      }

      cell.contentConfiguration = contentConfiguration
      return cell
    }
  }

  func attributedString(from resultText: String) -> NSMutableAttributedString? {
    guard let range = resultText.range(of: searchText, options: .caseInsensitive) else {
      return nil
    }
    let attributedString = NSMutableAttributedString(string: resultText)
    attributedString.addAttributes(
      [.font: UIFont.boldSystemFont(ofSize: 17)],
      range: NSRange(range, in: resultText)
    )
    return attributedString
  }

  private func listLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
    listConfiguration.backgroundColor = .clear
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
}

extension SearchCollectionViewController: SearchBarTextDelegate {
  func searchTextDidChange(_ searchText: String) {
    self.searchText = searchText
  }
}

extension SearchCollectionViewController: SearchObserver {
  func searchItemsDidFetch(_ items: [StoreItem]) {

    error = nil
    let items = items.compactMap { SuggestionResults(resultString: $0.name) }

    self.items = items
    dataSource.apply(itemsSnapshot, animatingDifferences: true)
  }

  func searchFetchFailed(with error: String) {
    self.error = error
    print("DEBUG: \(error)")
  }
}
