//
//  MainCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

// TODO: create initializer
class MainCollectionViewController: UICollectionViewController {

  let errorViewController = ErrorView()

  // MARK: - Typealiases

  typealias DataSource = UICollectionViewDiffableDataSource<String, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>

  // MARK: - Properties

  var searchController = StoreSearchController()

  var dataSource: DataSource!

  var items = [StoreItem]()
  var itemSnapshot: Snapshot {
    var snapshot = Snapshot()
    snapshot.appendSections(["Results"])
    snapshot.appendItems(items)
    return snapshot
  }

  var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.searchController = searchController

    collectionView.backgroundColor = .white
    collectionView.collectionViewLayout = configureLayout()
    collectionView.register(
      MainCollectionViewCell.self,
      forCellWithReuseIdentifier: MainCollectionViewCell.ID
    )
    configureDataSource()

    showEmptyScreen()

    searchController.searchRepository.addObserver(self)
    searchController.searchTextHandler = {
      self.showEmptyScreen()
    }
  }

  // MARK: - Configure Layout

  func configureLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 4,
      leading: 4,
      bottom: 4,
      trailing: 4
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: 2
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 8,
      leading: 8,
      bottom: 8,
      trailing: 8
    )
    section.interGroupSpacing = 8

    return UICollectionViewCompositionalLayout(section: section)
  }

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

extension MainCollectionViewController: SearchObserver {
  
  func searchItemsDidFetch(_ items: [StoreItem]) {
    self.items = items

    if self.items.isEmpty {
      showErrorView(with: "Элементы не найдены")
    } else {
      hideErrorView()
    }

    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }

  func searchFetchFailed(with error: String) {
    showErrorView(with: error)
  }

  func showErrorView(with error: String) {

    var errorMessage = ErrorMessage()
    errorMessage.message = error
    errorViewController.configureController(errorMessage: errorMessage)

    DispatchQueue.main.async {
      self.view.addSubview(self.errorViewController.view)
      self.addChild(self.errorViewController)
      self.errorViewController.didMove(toParent: self)
    }
  }

  func hideErrorView() {
    DispatchQueue.main.async {
      self.errorViewController.willMove(toParent: nil)
      self.errorViewController.view.removeFromSuperview()
      self.errorViewController.removeFromParent()
    }
  }

  func showEmptyScreen() {
    if let searchBarText = searchController.searchBar.text,
       searchBarText.isEmpty {
      showErrorView(with: "Введите запрос")
    }
  }
}

// MARK: - WebView
/*
 func showContentsWebSite(with url: URL) {
         webViewController = SFSafariViewController(url: url)
         present(webViewController, animated: true, completion: nil)

     }
 */

// MARK: - open detail view
/*
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         let musicItem = self.searchViewModel.searhResults[indexPath.row]

         self.performSegue(withIdentifier: "PreviewMusic_Identifier", sender: musicItem)

     }
 */
