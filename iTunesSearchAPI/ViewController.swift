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
  private var queue:OperationQueue!
  private var isAlreadyLauched = false

  private let weatherTableViewCellIdentifier = "WeatherTableViewCellIdentifier"

  override func viewDidLoad() {
    super.viewDidLoad()

    let userdefault = UserDefaults.standard
    isAlreadyLauched = userdefault.bool(forKey: "isAlreadyLauched")

    if !isAlreadyLauched {
      userdefault.set(true, forKey: "isAlreadyLauched")
      let alert = UIAlertController(title: "ITunes", message: "Welcome", preferredStyle: .alert)
      present(alert, animated: true, completion: nil)
    }

    queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    let view = UIView(frame: CGRect(x: 60, y: 70, width: 100, height: 100))
    view.backgroundColor = .red
    self.view.addSubview(view)

    downloadAndshowAppleLogo()
    setUpTableView()
    getiTunesAPI()
    tableView.reloadData()
    tableView.reloadRows(at: [IndexPath(row: 10, section: 1), IndexPath(row: 0, section: 0)], with: .top)
  }

  func setUpTableView() {
//    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "rightDetailCellIdentifier")
    self.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: weatherTableViewCellIdentifier)
  }

  fileprivate func downloadAndshowAppleLogo() {
    let logoDownloadOperation = DownloadOperation(with: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png")
    logoDownloadOperation.index = 100
    logoDownloadOperation.completionBlock = {
      print(logoDownloadOperation.index)
      DispatchQueue.main.async {
        self.imageView.image = UIImage(data: logoDownloadOperation.data!)
      }
    }
    queue.addOperation(logoDownloadOperation)

  }

  fileprivate func getiTunesAPI() {
    // Do any additional setup after loading the view.
    let networking = Networking.sharedInstance
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
    let cell = tableView.dequeueReusableCell(withIdentifier: weatherTableViewCellIdentifier, for: indexPath) as! WeatherTableViewCell
    cell.rightTextLabel.text = "\(forceCastDays[indexPath.row].day.maxtemp_f)"
    cell.leftTextLabel.text = forceCastDays[indexPath.row].date

    let iconUrlString = "https:" + self.forceCastDays[indexPath.row].day.condition.icon
      let downloadOperation = DownloadOperation(with: iconUrlString)
      downloadOperation.index = indexPath.row
      downloadOperation.completionBlock = {
        print(downloadOperation.index)
        DispatchQueue.main.async {
         cell.imageIconView.image = UIImage(data: downloadOperation.data!)
        }
      }
     queue.addOperation(downloadOperation)
     return cell
  }
}
#if DEBUG


#endif

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(forceCastDays[indexPath.row].day.maxtemp_f)
    performSegue(withIdentifier: "WeatherDetailViewcontrollerIdentifier", sender: nil)
    }
}

class DownloadOperation: Operation {

  private var urlString: String
  var index: Int!
  var data: Data?
  init(with urlString: String) {
    self.urlString = urlString
  }

  override func main() {
    if let url = URL(string: self.urlString),
       let imageData = try? Data(contentsOf: url) {
      self.data = imageData
    }
  }
}

/*
 let defaults = UserDefaults.standard

 defaults.set(101, forKey: "AnyInt")
 print(defaults.integer(forKey: "AnyInt"))

 defaults.set(true, forKey: "Your flag")
 print(defaults.bool(forKey: "Your flag"))

 defaults.set("Your name ", forKey: "Name")
 print(defaults.string(forKey:"Name")!)

 let array = ["INDIA", "US"]
 defaults.set(array, forKey: "countries")
 print(defaults.array(forKey: "countries")!)


 let dict = ["Programming": "Swift", "Country": "US"]
 defaults.set(dict, forKey: "details")
 print(defaults.dictionary(forKey: "details")!)

 */

