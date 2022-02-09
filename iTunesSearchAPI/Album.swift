//
//  Album.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 2/8/22.
//

import Foundation

struct Album {
  var trackName: String
  var artworkUrl100: String
  var collectionName: String?
}

struct Albums {
  var resultCount: Int
  var results: [Album]
}
