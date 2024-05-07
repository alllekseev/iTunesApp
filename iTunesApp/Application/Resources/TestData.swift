//
//  TestData.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 06/05/2024.
//

import Foundation

let testStoreItemsData: Data = """
{
  "results": [
    {
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "artistName": "twenty one pilots",
      "kind": "song",
      "longDescription": "",
      "trackId": 974485474,
      "trackName": "Stressed Out",
      "collectionId": 974485462
    },
    {
      "trackId": 974485805,
      "longDescription": "",
      "kind": "song",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "collectionId": 974485462,
      "artistName": "twenty one pilots",
      "trackName": "Ride"
    },
    {
      "trackId": 1125281487,
      "kind": "song",
      "artistName": "twenty one pilots",
      "longDescription": "",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/2f/76/c0/2f76c0c7-5aaf-eb97-2002-f40c9ecde722/075679910486.jpg/100x100bb.jpg",
      "collectionId": 1125281254,
      "trackName": "Heathens"
    },
    {
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "artistName": "twenty one pilots",
      "longDescription": "",
      "trackName": "Tear In My Heart",
      "trackId": 974485807,
      "collectionId": 974485462,
      "kind": "song"
    },
    {
      "longDescription": "",
      "artistName": "twenty one pilots",
      "collectionId": 974485462,
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "kind": "song",
      "trackId": 974485473,
      "trackName": "Heavydirtysoul"
    },
    {
      "trackId": 974485808,
      "collectionId": 974485462,
      "kind": "song",
      "longDescription": "",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "trackName": "Lane Boy",
      "artistName": "twenty one pilots"
    },
    {
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "collectionId": 974485462,
      "kind": "song",
      "trackId": 974485806,
      "longDescription": "",
      "trackName": "Fairly Local",
      "artistName": "twenty one pilots"
    },
    {
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/67/ea/fb/67eafbb3-9be8-9289-3e62-e4bab20fa916/075679957924.jpg/100x100bb.jpg",
      "artistName": "twenty one pilots",
      "trackId": 585128671,
      "longDescription": "",
      "collectionId": 585128397,
      "trackName": "Car Radio",
      "kind": "song"
    },
    {
      "kind": "song",
      "trackName": "Doubt",
      "collectionId": 974485462,
      "trackId": 974485810,
      "artistName": "twenty one pilots",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "longDescription": ""
    },
    {
      "artistName": "twenty one pilots",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/91/8a/12/918a1237-5216-1dff-9ca8-47b4ca8f9822/075679926951.jpg/100x100bb.jpg",
      "kind": "song",
      "trackId": 974485809,
      "longDescription": "",
      "trackName": "The Judge",
      "collectionId": 974485462
    }
  ]
}
""".data(using: .utf8)!
