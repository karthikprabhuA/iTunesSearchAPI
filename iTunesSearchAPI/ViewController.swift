//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 1/31/22.
//

import UIKit

class ViewController: UIViewController, NetworkingDelegate {

  var mobileNetwork: String = "ATT"


  @IBOutlet weak var tableView: UITableView!

  var saveData: String = ""
  var countries:[String] = ["US", "UK", "ITALY"]
  var asia:[String] = ["INDIA", "JAPAN","CHINA"]


  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    getiTunesAPI()
  }

  func setUpTableView() {
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
  }

  fileprivate func getiTunesAPI() {
    // Do any additional setup after loading the view.

    let networking = Networking() //https://itunes.apple.com/search?term=jack+johnson
    networking.delegate = self
    networking.getData(for: "https://itunes.apple.com/search?term=jack+johnson") { [weak self] result in
      print(self?.mobileNetwork)
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          print(response)
        case .failure(let error):
          print(error.description)
        }
      }
    }
  }

  // MARK: NetworkDelegate
  func didReceiveResponse(_ response: String) {
    DispatchQueue.main.async {
      print(response)
    }
  }

  func didReceiveError(_ error: Networking.NetworkError) {
    DispatchQueue.main.async {
      print(error.description)
    }
  }


}

extension ViewController: UITableViewDataSource {
  // MARK: UITableviewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return asia.count
    }
    return countries.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section)"
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Ask for a cell of the appropriate type.
     let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)

     // Configure the cell’s contents with the row and section number.
     // The Basic cell style guarantees a label view is present in textLabel.
    if indexPath.section == 1 {
      cell.textLabel!.text = asia[indexPath.row]
    } else {
     cell.textLabel!.text = countries[indexPath.row]
    }
     return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      print(asia[indexPath.row])
    } else {
      print(countries[indexPath.row])
    }
  }

}
