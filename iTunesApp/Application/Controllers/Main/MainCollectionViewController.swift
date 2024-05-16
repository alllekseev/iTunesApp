//
//  MainCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit


/* The Vision of Hell `app` */
// TODO: create initializer
final class MainCollectionViewController: UICollectionViewController {

  // MARK: - Typealiases

  typealias DataSource = UICollectionViewDiffableDataSource<String, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>

  // MARK: - Properties

  var items = [StoreItem]()
  var dataSource: DataSource!

  // MARK: - Class Instances

  var searchController = SearchController()
  var searchRepository: SearchRepository
  lazy var activityIndicator = ActivityIndicator(view: view, style: .large)
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

  //MARK: - Initializer

  override init(collectionViewLayout: UICollectionViewLayout) {
    searchRepository = searchController.searchRepository
    super.init(collectionViewLayout: collectionViewLayout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = DetailViewController(itemDetails: items[indexPath.item])
    navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: - Prepare UI

  func prepareUI() {
    collectionView.backgroundColor = .systemBackground
    view.addSubview(errorView)
  }

  // MARK: - Configure CollectionView

  func configureColectionView() {
    navigationItem.searchController = searchController
//    resultSearchController.searchBar.delegate = self
    navigationItem.hidesSearchBarWhenScrolling = false
    collectionView.collectionViewLayout = configureLayout()
    searchController.searchRepository.delegate = self
  }

  // MARK: - Layout

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
  }

  private func showLoadingView() {
    errorView.isHidden = true
    activityIndicator.showIndicator()
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
    switch searchController.searchRepository.storeStateManager.state {
    case .empty:
      activityIndicator.hideIndicator()
      showErrorView(with: "Введи запрос")
    case .loading:
      showLoadingView()
    case .loaded(let items):
      self.activityIndicator.hideIndicator()
      self.showCollectionView(with: items)
    case .error(let error):
      activityIndicator.hideIndicator()
      showErrorView(with: error.customDescription)
    }
    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }
}

// MARK: - WebView
/*
 func showContentsWebSite(with url: URL) {
         webViewController = SFSafariViewController(url: url)
         present(webViewController, animated: true, completion: nil)

     }
 */
