//
//  HomeViewController.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 2/7/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    print("HomeViewController:" + (Networking.sharedInstance.lastURL ?? "No Last URL"))
  }

  @IBAction func buttontapped(_ sender: UIButton) {
    print("buttonTapped")
    performSegue(withIdentifier: "showViewcontrollerIdentifier", sender: nil)
  }
}
