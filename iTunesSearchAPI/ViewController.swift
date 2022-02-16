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
  var forceCastDays = [ForceCastDay]()

  override func viewDidLoad() {
    super.viewDidLoad()

    let view = UIView(frame: CGRect(x: 60, y: 70, width: 100, height: 100))
    view.backgroundColor = .red
    self.view.addSubview(view)

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
    networking.getData(for: "https://api.weatherapi.com/v1/forecast.json?key=6a88d36b6dff4782a03143907221102&q=London&days=10&aqi=no&alerts=no") { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          print("Location: \(response.forecast)")
          self?.forceCastDays = response.forecast.forecastday
          self?.tableView.reloadData()
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
    return forceCastDays.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section)"
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Ask for a cell of the appropriate type.
     let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
    
     // Configure the cell’s contents with the row and section number.
     // The Basic cell style guarantees a label view is present in textLabel.
    var config = cell.defaultContentConfiguration()
    config.text = "\(forceCastDays[indexPath.row].day.maxtemp_f)"
    config.secondaryText = "\(forceCastDays[indexPath.row].date)"
    cell.contentConfiguration = config
     return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(forceCastDays[indexPath.row].day.maxtemp_f)
    }
}

