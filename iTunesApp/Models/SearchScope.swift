//
//  SearchScope.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 05.04.2024.
//

import Foundation

enum SearchScope: CaseIterable {
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
      return "movie, album, allArtist, podcast, musicVideo, mix, audiobook, tvSeason, allTrack"
    case .movies:
      return "movieArtist, movie"
    case .music:
      return "musicArtist, musicTrack, album, musicVideo, mix, song"
    case .apps:
      return "software"
    case .books: return "ebook"
    }
  }
}
