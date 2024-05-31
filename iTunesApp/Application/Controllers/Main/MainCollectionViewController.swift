//
//  MainCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import UIKit

final class MainCollectionViewController: UICollectionViewController {

  // MARK: - Type Definitions
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, StoreItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StoreItem>

  // MARK: - Sections

  enum Section {
    case storeItems
  }

  // MARK: - Collection State Manager

  private enum MainCollectionStateManager {
    case loading
    case loaded(items: [StoreItem])
    case info(message: String)
  }

  // MARK: - Response Data

  struct ResponseData {
    var service: ServiceType
    var mediaType: SearchScope
    var elementsAmount: Int
  }

  // MARK: - Collection View Properties

  private let coreDataManager = DataManager()

  private var items = [StoreItem]()

  var dataSource: DataSource!
  
  private var itemSnapshot: Snapshot {
    var snapshot = Snapshot()
    snapshot.appendSections([.storeItems])
    snapshot.appendItems(items)
    return snapshot
  }

  private var collectionState: MainCollectionStateManager = .loading {
    didSet {
      updateUI()
    }
  }

  // MARK: - Private Properties

  // MARK: - Additional Views
  private lazy var activityIndicator = ActivityIndicator(view: view, style: .large)
  private lazy var errorView = ErrorView(frame: view.bounds)
  

  // MARK: - Network Properties
  var searchRepository = SearchRepository()
  var workItem: DispatchWorkItem?


  // MARK: - SearchController

  var searchController: UISearchController
  var resultsController: SearchResultsCollectionViewController
  var queryOptions = SearchScope.allCases.map{ $0 }

  var textDidChange: ((String) -> Void)?

  lazy var responseData = ResponseData(
    service: .storeItems,
    mediaType: queryOptions[searchController.searchBar.selectedScopeButtonIndex],
    elementsAmount: 50
  )

  // MARK: - Initializers

  init() {
    resultsController = SearchResultsCollectionViewController(
      searchRepository,
      coreDataManager: coreDataManager
    )
    searchController = UISearchController(searchResultsController: resultsController)
    super.init(collectionViewLayout: UICollectionViewLayout())
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

    setupSearchBar()
    setupResultsController()
    prepareUI()
    configureColectionView()
    configureDataSource()
  }

  private func prepareUI() {
    collectionView.backgroundColor = .systemBackground
    view.addSubview(errorView)
  }

  private func configureColectionView() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    collectionView.collectionViewLayout = configureLayout()
    searchRepository.delegate = self
  }

  private func updateUI() {
    switch collectionState {
    case .loading:
      errorView.isHidden = true
      activityIndicator.showIndicator()
      return
    case .loaded(let items):
      errorView.isHidden = true
      self.items = items
    case .info(let message):
      errorView.isHidden = false
      let errorContext = ErrorContext(message: message)
      errorView.configureController(errorContext)
    }
    activityIndicator.hideIndicator()
  }

  // MARK: - Override Methods

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = DetailViewController(itemDetails: items[indexPath.item])
    coreDataManager.save(item: items[indexPath.item])
    navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: - Private Methods
}

extension MainCollectionViewController: SearchRepositoryDelegate {

  func update() {
    self.items = []
    switch searchRepository.storeStateManager.state {
    case .empty:
      collectionState = .info(message: Strings.placeholder)
    case .loading:
      collectionState = .loading
    case .loaded(let items):
      collectionState = .loaded(items: items)
    case .error(let error):
      collectionState = .info(message: error.customDescription)
    }
    dataSource.apply(itemSnapshot, animatingDifferences: true)
  }
}
