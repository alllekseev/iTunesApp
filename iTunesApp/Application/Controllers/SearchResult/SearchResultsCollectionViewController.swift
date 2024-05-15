//
//  SearchResultsCollectionViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06.04.2024.
//

import UIKit

protocol SearchResultsCellDelegate: AnyObject {
  func didSelectItem(with name: String)
}

final class SearchResultsCollectionViewController: UICollectionViewController {

  var searchRepository: SearchRepository

  weak var delegate: SearchResultsCellDelegate?

  init(_ searchRepository: SearchRepository) {
    self.searchRepository = searchRepository
    super.init(collectionViewLayout: UICollectionViewLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchSuggestion>
  typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchSuggestion>

  typealias Section = Int

  let ID = "cell"

  var dataSource: DataSource!
  var items = [SearchSuggestion]()
  var itemsSnapshot: Snapshot {
    var snaphot = Snapshot()
    snaphot.appendSections([0])
    snaphot.appendItems(items)
    return snaphot
  }

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
    delegate?.didSelectItem(with: items[indexPath.row].name)
  }


}

extension SearchResultsCollectionViewController: SearchBarTextDelegate {
  func searchTextDidChange(_ searchText: String) {
    self.searchText = searchText
  }
}

extension SearchResultsCollectionViewController: SearchRepositoryDelegate {
  func update() {

    switch searchRepository.resultsStateManager.state {
    case .empty: return
    case .loading: self.items = []
    case .loaded(let items): self.items = items.compactMap { $0 }
    case .error: items.append(SearchSuggestion(name: self.searchText))
    }

    dataSource.apply(itemsSnapshot, animatingDifferences: true)
  }
}
