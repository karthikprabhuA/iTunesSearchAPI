//
//  Album.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 2/8/22.
//

import Foundation

struct Album: Decodable {
  var trackName: String
  var artworkUrl: String
  var collectionName: String?

  enum CodingKeys: String, CodingKey {
    case artworkUrl = "artworkUrl100"
    case trackName
    case collectionName
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    artworkUrl = try container.decode(String.self, forKey: .artworkUrl)
    trackName = try container.decode(String.self, forKey: .trackName)
    collectionName = try? container.decode(String.self, forKey: .collectionName)
  }
}

struct Albums: Decodable {
  var resultCount: Int
  var results: [Album]
}
