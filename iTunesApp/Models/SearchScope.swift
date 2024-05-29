//
//  SearchScope.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

enum SearchScope: Int, CaseIterable {
  case all, movies, music, apps, books

  var title: String {
    switch self {
    case .all: return "All"
    case .movies: return "Movies"
    case .music: return "Music"
    case .apps: return "Apps"
    case .books: return "Books"
    }
  }

  var mediaType: String {
    switch self {
    case .all:
      return "all"
    case .movies:
      return "movie"
    case .music:
      return "music"
    case .apps:
      return "software"
    case .books: return "ebook"
    }
  }

  var entity: String {
    switch self {
    case .all:
      return "movie, audiobook, tvSeason, allTrack"
    case .movies:
      return "movie"
    case .music:
      return "song"
    case .apps:
      return "software"
    case .books:
      return "ebook"
    }
  }
}
