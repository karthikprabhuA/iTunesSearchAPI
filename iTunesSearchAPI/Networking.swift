//
//  Networking.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 1/31/22.
//

import Foundation

typealias CompletionHandler = (Result<String,Networking.NetworkError>) -> Void

protocol NetworkingDelegate: AnyObject   {
  var mobileNetwork: String { get set }
  func didReceiveResponse(_ response: String)
  func didReceiveError(_ error: Networking.NetworkError)
}


class Networking {

  weak var delegate: NetworkingDelegate?

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
  func getData(for url: String, completion: @escaping CompletionHandler) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = URL(string: url) else {
      self.delegate?.didReceiveError(.badURLError)
      completion(.failure(.badURLError))
      return
    }
    print(self.delegate?.mobileNetwork)
    self.delegate?.mobileNetwork = "T-Mobile"
    let task = session.dataTask(with: url) {[weak self] data, response, error in
      // ensure there is no error for this HTTP response
      guard error == nil else {
        print ("error: \(error!)")
        self?.delegate?.didReceiveError(.responseError)
        completion(.failure(.responseError))
        return
      }

      // ensure there is data returned from this HTTP response
      guard let content = data else {
        print("No data")
        self?.delegate?.didReceiveError(.dataNotFoundError)
        completion(.failure(.dataNotFoundError))
        return
      }

      // serialise the data / NSData object into Dictionary [String : Any]
      guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
        print("Not containing JSON")
        self?.delegate?.didReceiveError(.jsonParserError)
        completion(.failure(.jsonParserError))

        return
      }

      print("gotten json response dictionary is \n \(json)")
      self?.delegate?.didReceiveResponse("gotten json response dictionary is \n \(json)")
      completion(.success("gotten json response dictionary is \n \(json)"))
      // update UI using the response here
    }

    // execute the HTTP request
    task.resume()
  }

}
