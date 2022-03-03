//
//  Networking.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 1/31/22.
//

import Foundation

typealias CompletionHandler = (Result<Weather,Networking.NetworkError>) -> Void

class Networking {
  var lastURL: String?
  static let sharedInstance = Networking()

  private init() {
    //singleton
  }
  
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
    self.lastURL = url
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
      let decoder = JSONDecoder()
      do {
        let albums = try decoder.decode(Weather.self, from: content)
          print(albums)
          completion(.success(albums))
// Make Albums or Album Struct model confirms to Codable protocol
//        let encoder = JSONEncoder()
//        let result = try? encoder.encode(albums)
//        print(String(data:result!, encoding:.utf8)!)
//
      } catch {
        print(error.localizedDescription)
        completion(.failure(.jsonParserError))
      }
    }

    // execute the HTTP request
    task.resume()
  }

}
