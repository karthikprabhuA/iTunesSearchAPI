//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 1/31/22.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!

  var saveData: String = ""
  var album = [Album]()

  override func viewDidLoad() {
    super.viewDidLoad()
    downloadAndshowAppleLogo()
    setUpTableView()
    getiTunesAPI()
  }

  func setUpTableView() {
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
  }

  fileprivate func downloadAndshowAppleLogo() {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let imageData = try Data(contentsOf: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png")!)
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: imageData)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  fileprivate func getiTunesAPI() {
    // Do any additional setup after loading the view.
    let networking = Networking()
    networking.getData(for: "https://itunes.apple.com/search?term=jack+johnson") { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
//          let decoder = JSONDecoder()
//
//          do {
//              let decoded = try decoder.decode([Albums].self, from: data)
//              print(decoded[0].name)
//          } catch {
//              print("Failed to decode JSON")
//          }
          self?.album = response.results
          self?.tableView.reloadData()
          break

        case .failure(let error):
          print(error.description)
        }
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  // MARK: UITableviewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return album.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section)"
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Ask for a cell of the appropriate type.
     let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)

     // Configure the cell’s contents with the row and section number.
     // The Basic cell style guarantees a label view is present in textLabel.
      cell.textLabel!.text = album[indexPath.row].trackName
     return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(album[indexPath.row])
    }
}

