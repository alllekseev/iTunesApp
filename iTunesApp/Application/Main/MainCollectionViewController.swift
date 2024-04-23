//
//  MainCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

// TODO: create initializer
final class MainCollectionViewController: UICollectionViewController {

  // MARK: - Typealiases

  typealias DataSource = UICollectionViewDiffableDataSource<String, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>

  var loadingIndicator = LoaderView().loadar

  // MARK: - Class Instances

  var searchController = StoreSearchController()
  private lazy var errorViewController = ErrorView(frame: view.bounds)

  // MARK: - Properties

  var items = [StoreItem]()

  // MARK: - CollectionView Elements
  var dataSource: DataSource!

  var itemSnapshot: Snapshot {
    var snapshot = Snapshot()
    snapshot.appendSections(["Results"])
    snapshot.appendItems(items)
    return snapshot
  }

  // FIXME: - add AsyncSequence
  var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]

  // MARK: - viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(
      MainCollectionViewCell.self,
      forCellWithReuseIdentifier: MainCollectionViewCell.ID
    )

    configureColectionView()
    configureDataSource()
    prepareUI()
  }

  // MARK: - Prepare UI

  func prepareUI() {
    collectionView.backgroundColor = .systemBackground

    view.addSubview(loadingIndicator)
    view.addSubview(errorViewController)
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  // MARK: - Configure CollectionView
  func configureColectionView() {
    navigationItem.searchController = searchController
    collectionView.collectionViewLayout = configureLayout()
    searchController.searchRepository.addObserver(self)
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

  private func showCollectionView(with items: [StoreItem]) {
//    self.errorViewController.willMove(toParent: nil)
//    self.errorViewController.view.removeFromSuperview()
//    self.errorViewController.removeFromParent()
//    view = collectionView

    errorViewController.isHidden = true
    self.items = items
    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }

  private func showLoadingView() {
//    errorViewController.view.isHidden = true
    errorViewController.isHidden = true
  }

  // FIXME: - change naming
  private func showErrorView(with errorMessage: String) {
//    collectionView.isHidden = true
//    errorViewController.view.isHidden = false

//    self.addChild(self.errorViewController)
//    self.view.addSubview(self.errorViewController.view)
//    self.errorViewController.didMove(toParent: self)

    errorViewController.isHidden = false
    navigationItem.hidesSearchBarWhenScrolling = false

    let errorMessage = ErrorMessage(message: errorMessage)
    errorViewController.configureController(errorMessage: errorMessage)
  }
}

extension MainCollectionViewController: SearchObserver {
  
//  func searchItemsDidFetch(_ items: [StoreItem]) {
//    state = .loading
//    self.items = []
//    state = items.isEmpty ? .error(.itemsNotFound) : .loaded(items)
//  }
//
//  func searchFetchFailed(with error: StoreAPIError) {
//    state = .error(error)
//  }

  func update() {
    switch searchController.searchRepository.stateManager.state {
    case .empty:
//      loadingIndicator.stopAnimating()
      showErrorView(with: "Введи запрос")
    case .loading:
      showLoadingView()
      loadingIndicator.startAnimating()
      self.items = []
      dataSource.apply(itemSnapshot, animatingDifferences: true)
    case .loaded(let items):
      self.loadingIndicator.stopAnimating()
      self.showCollectionView(with: items)
    case .error(let error):
      loadingIndicator.stopAnimating()
      showErrorView(with: error.customDescription)
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
