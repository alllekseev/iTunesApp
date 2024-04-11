//
//  SearchTableViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
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

final class SearchCollectionViewController: UICollectionViewController, CollectionViewControllerBuilder {

  typealias Section = Int
  typealias ItemType = StoreItem

  let ID = "cell"

  var dataSource: DataSource!
  var items: [StoreItem] = []
  var itemsSnapshot: Snapshot {
    var snaphot = Snapshot()
    snaphot.appendSections([0])
    snaphot.appendItems(items)
    return snaphot
  }

  var searchTask: Task<Void, Never>? = nil
  var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()

    let listLayout = listLayout()
    collectionView.collectionViewLayout = listLayout

    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: ID)
    configureDataSource()
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, itemIdentifier) -> UICollectionViewListCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.ID, for: indexPath) as! UICollectionViewListCell
      Task {
        do {
          var contentConfiguration = cell.defaultContentConfiguration()

          let storeItem = self.items[indexPath.item]

          contentConfiguration.text = storeItem.name
          contentConfiguration.secondaryText = storeItem.artist
          contentConfiguration.secondaryTextProperties.color = .lightGray
          contentConfiguration.image = try? await  UIImage.fetchImage(from: storeItem.artworkURL)
          cell.contentConfiguration = contentConfiguration
        }
      }

      return cell
    }
  }

  private func listLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
    listConfiguration.backgroundColor = .clear
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }

//  override func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//  ) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! UICollectionViewListCell
//    Task {
//      do {
//        var contentConfiguration = cell.defaultContentConfiguration()
//
//        let storeItem = self.items[indexPath.item]
//
//        contentConfiguration.text = storeItem.name
//        contentConfiguration.secondaryText = storeItem.artist
//        contentConfiguration.secondaryTextProperties.color = .lightGray
//        contentConfiguration.image = try? await  UIImage.fetchImage(from: storeItem.artworkURL)
//        cell.contentConfiguration = contentConfiguration
//      }
//    }
//
//    return cell
//  }
}

protocol ItemDisplaing {
  var itemImageView: UIImageView { get set }
  var titleLabel: UILabel { get set }
  var detailLabel: UILabel { get set }
}

@MainActor
extension ItemDisplaing {
  func configure(for item: StoreItem) async throws {
    titleLabel.text = item.name
    detailLabel.text = item.artist
    itemImageView.image = UIImage(systemName: "photo")

    do {
      let image = try await UIImage.fetchImage(from: item.artworkURL)

      itemImageView.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancelation errors
    } catch {

      print("DEBUG Error fetching image: \(error)")
      throw APIRequestError.imageDataMissing
    }
  }
}
