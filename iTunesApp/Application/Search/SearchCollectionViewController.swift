//
//  SearchCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

final class SearchCollectionViewController: UICollectionViewController, CollectionViewControllerBuilder {

  typealias Section = Int
  typealias ItemType = StoreItem

  let ID = "cell"

  let loadingViewController = LoadingViewController()

  var dataSource: DataSource!
  var items: [StoreItem] = []
  var itemsSnapshot: Snapshot {
    var snaphot = Snapshot()
    snaphot.appendSections([0])
    snaphot.appendItems(items)
    return snaphot
  }

  var searchTask: Task<Void, Never>? = nil
  var imageLoadTask: [IndexPath: Task<Void, Error>] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.ID)

    let listLayout = listLayout()
    collectionView.collectionViewLayout = listLayout


    configureDataSource()

    configureLoadingController()
  }

  func configureLoadingController() {
    addChild(loadingViewController)
    view.addSubview(loadingViewController.view)
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewListCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.ID, for: indexPath) as! SearchCollectionViewCell

      self.imageLoadTask[indexPath]?.cancel()
      self.imageLoadTask[indexPath] = Task {
        try await cell.configure(for: item)
        self.imageLoadTask[indexPath] = nil
      }
      return cell
    }
  }

  private func listLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
    listConfiguration.backgroundColor = .clear
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
}
