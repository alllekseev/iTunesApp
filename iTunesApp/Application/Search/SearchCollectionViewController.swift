//
//  SearchCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

struct Item: Hashable, Identifiable {
  let id = UUID()
  let name: String
}

final class SearchCollectionViewController: UICollectionViewController {

//  enum Item: Hashable {
//    case results(StoreItem)
//    case error(String?)
//  }



  var searchRepository = SearchRepository()

//  typealias ItemType = Item
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

  struct SuggestionResults: Hashable, Identifiable {
    let id = UUID()
    let resultString: String
  }

  typealias Section = Int
//  typealias ItemType = SuggestionResults

  let ID = "cell"

  let loadingViewController = LoadingViewController()
  var loadingIndicator = LoaderView().loadar

  var dataSource: DataSource!
  var items = [Item]()
  var itemsSnapshot: Snapshot {
    var snaphot = Snapshot()
    snaphot.appendSections([0])
    snaphot.appendItems(items)
    return snaphot
  }

//  var errorSnapshot: Snapshot {
//    var snaphot = Snapshot()
//    snaphot.appendSections([1])
//    snaphot.appendItems([.error(self.error)], toSection: 1)
//    return snaphot
//  }

  private var searchText: String = ""

  private var error: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemBackground

    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: ID)

    let listLayout = listLayout()
    collectionView.collectionViewLayout = listLayout

    configureDataSource()

    collectionView.dataSource = dataSource

//    view.addSubview(loadingIndicator)
//    NSLayoutConstraint.activate([
//      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//    ])
  }

  func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewListCell? in

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: self.ID,
        for: indexPath
      ) as! UICollectionViewListCell

      var contentConfiguration = cell.defaultContentConfiguration()
      let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 16))
      contentConfiguration.image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration)
      contentConfiguration.imageProperties.tintColor = .systemGray


//      switch item {
//      case .results(let item):
//        let resultText = item.name
//        if let attributedText = self.attributedString(from: resultText) {
//          contentConfiguration.attributedText = attributedText
//        } else {
//          contentConfiguration.text = resultText
//        }
//      case .error(let error):
//        if let error = error {
//          contentConfiguration.text = error
//        }
//      }

      let resultText = item.name
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


  private func listLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
    listConfiguration.backgroundColor = .clear
    listConfiguration.itemSeparatorHandler = {
      (indexPath, sectionSeparatorConfiguration) in
      var configuration = sectionSeparatorConfiguration
      configuration.bottomSeparatorInsets.leading = 0
      return configuration
    }
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }


}

extension SearchCollectionViewController: SearchBarTextDelegate {
  func searchTextDidChange(_ searchText: String) {
    self.searchText = searchText
  }
}

extension SearchCollectionViewController: SearchObserver {
  func update() {
    switch searchRepository.stateManager.state {
    case .empty:
//      loadingIndicator.stopAnimating()
      return
    case .loading:
      self.items = []
//      loadingIndicator.startAnimating()
    case .loaded(let items):
//      loadingIndicator.stopAnimating()
      self.items = items.compactMap { Item(name: $0.name) }
      dataSource.apply(itemsSnapshot, animatingDifferences: true)
    case .error:
//      loadingIndicator.stopAnimating()
      items.append(Item(name: self.searchText))
      dataSource.apply(itemsSnapshot, animatingDifferences: true)
    }
  }
}
