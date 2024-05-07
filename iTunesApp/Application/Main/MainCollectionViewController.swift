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

  // MARK: - Properties

  var items = [StoreItem]()
  var dataSource: DataSource!

  // MARK: - Class Instances

  var resultSearchController = SearchController()
  var searchRepository = SearchRepository()
  var loadingIndicator = Loader().indicator
  private lazy var errorView = ErrorView(frame: view.bounds)

  // MARK: - Snapshot

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
    view.addSubview(errorView)

    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  // MARK: - Configure CollectionView

  func configureColectionView() {
    navigationItem.searchController = resultSearchController
//    resultSearchController.searchBar.delegate = self
    navigationItem.hidesSearchBarWhenScrolling = false
    collectionView.collectionViewLayout = configureLayout()
    resultSearchController.searchRepository.delegate = self
  }

  // MARK: - Configure Layout

  func configureLayout() -> UICollectionViewLayout {
    let sectionSpacing: CGFloat = 16
    let innerSpacing: CGFloat = 14

    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalWidth(0.5)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: 2
    )
    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(innerSpacing)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: sectionSpacing,
      leading: sectionSpacing,
      bottom: sectionSpacing,
      trailing: sectionSpacing
    )
    section.interGroupSpacing = innerSpacing

    return UICollectionViewCompositionalLayout(section: section)
  }

  // MARK: - Screen Management

  private func showCollectionView(with items: [StoreItem]) {
    errorView.isHidden = true
    self.items = items
    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }

  private func showLoadingView() {
    errorView.isHidden = true
    loadingIndicator.startAnimating()
  }

  private func showErrorView(with message: String) {
    errorView.isHidden = false

    let errorContext = ErrorContext(message: message)
    errorView.configureController(errorContext)
  }
}

extension MainCollectionViewController: SearchRepositoryDelegate {

  func update() {
    self.items = []
    switch resultSearchController.searchRepository.storeStateManager.state {
    case .empty:
      loadingIndicator.stopAnimating()
      showErrorView(with: "Введи запрос")
    case .loading:
      showLoadingView()
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
