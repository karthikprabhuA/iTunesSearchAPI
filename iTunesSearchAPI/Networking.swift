//
//  Networking.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 1/31/22.
//

import Foundation

typealias CompletionHandler = (Result<Albums,Networking.NetworkError>) -> Void

class Networking {

  enum NetworkError: Error {
    case badURLError
    case jsonParserError
    case responseError
    case dataNotFoundError

    var description: String {
      switch self {
      case .badURLError:
        return "URL error"
      case .jsonParserError:
        return "json Parser error"
      case .responseError:
        return "response error"
      case .dataNotFoundError:
        return "data Not Found error"
      }
    }

  }
  //
  func getData(for url: String, completion: @escaping CompletionHandler) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = URL(string: url) else {
      completion(.failure(.badURLError))
      return
    }

    let task = session.dataTask(with: url) {[weak self] data, response, error in
      // ensure there is no error for this HTTP response
      guard error == nil else {
        print ("error: \(error!)")
        completion(.failure(.responseError))
        return
      }

      // ensure there is data returned from this HTTP response
      guard let content = data else {
        print("No data")
        completion(.failure(.dataNotFoundError))
        return
      }

      // serialise the data / NSData object into Dictionary [String : Any]
      guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
        print("Not containing JSON")
        completion(.failure(.jsonParserError))
        return
      }
      let resultArray = json["results"] as! [[String:Any]]
      let resultCount = json["resultCount"] as! Int
      var arrAlbums = [Album]()
      for result in resultArray {
        let album = Album(trackName: result["trackName"] as! String, artworkUrl100: result["artworkUrl100"] as! String, collectionName: result["collectionName"] as? String)
        arrAlbums.append(album)
      }
      let albums = Albums(resultCount: resultCount, results: arrAlbums)
      print(albums)
      //print("gotten json response dictionary is \n \(json)")
      completion(.success(albums))
      // update UI using the response here
    }

    // execute the HTTP request
    task.resume()
  }

}
