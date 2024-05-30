//
//  SearchResultsCollectionViewController+FindMatches.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 29/05/2024.
//

import Foundation

extension SearchResultsCollectionViewController {

  private func findMatches(searchString: String) -> NSCompoundPredicate {

    let nameKey = "name"
    let artistKey = "artist"

    var searchItemsPredicate = [NSPredicate]()

    let searchStringExpression = NSExpression(forConstantValue: searchString)

    let nameExpression = NSExpression(forKeyPath: nameKey)

    let nameSearchComparisonPredicate = NSComparisonPredicate(
      leftExpression: nameExpression,
      rightExpression: searchStringExpression,
      modifier: .direct,
      type: .contains,
      options: [.caseInsensitive, .diacriticInsensitive]
    )

    searchItemsPredicate.append(nameSearchComparisonPredicate)

    let artistExpression = NSExpression(forKeyPath: artistKey)

    let artistComparisonPredicate = NSComparisonPredicate(
      leftExpression: artistExpression,
      rightExpression: searchStringExpression,
      modifier: .direct,
      type: .contains,
      options: [.caseInsensitive, .diacriticInsensitive]
    )

    searchItemsPredicate.append(artistComparisonPredicate)

    return NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
  }

  func filterLoadedItems() {
    let searchText = self.searchText.trimmingCharacters(in: .whitespaces)
    guard !searchText.isEmpty else { return }

    let predicate = findMatches(searchString: searchText)
    var filteredItems = self.items.filter { predicate.evaluate(with: $0.dictionaryRepresentation) }
    filteredItems = filteredItems.sorted(by: <)

    // Limit the number of items to 10
    self.items = Array(filteredItems.prefix(10))
  }
}

extension Sequence where Iterator.Element: Hashable {
  func uniq() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}
