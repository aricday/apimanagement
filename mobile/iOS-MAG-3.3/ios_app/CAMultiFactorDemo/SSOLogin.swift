//
//  SSOLogin.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class SSOLogin: BaseDemo {
  
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var uuidLabel: UILabel!
  @IBOutlet weak var accessTokenLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var secureMessageLabel: UILabel!
  
  
  override var demoTitle: String {
    return "Secure APIs"
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("SSOLogin.viewDidAppear")
    getData()
  }
  
  @IBAction func getData()
  {
    // Get secured data
    progressIndicator.startAnimating()
    dispatch_async(dispatch_get_main_queue()) {
      MAS.getFrom("/secure", withParameters: [:], andHeaders: [:]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        self.progressIndicator.stopAnimating()
        if(error != nil)
        {
          print("Could not retrieve secure API...")
        } else {
          if let json = response[MASResponseInfoBodyInfoKey] as? [String: AnyObject] {
            self.userLabel.text = json["user"] as? String
            self.urlLabel.text = json["url"] as? String
            self.uuidLabel.text = json["mag_identifier"] as? String
            self.accessTokenLabel.text = json["access_token"] as? String
            self.locationLabel.text = json["geolocation"] as? String
            self.secureMessageLabel.text = json["secure_data"] as? String
          }
        }
      }
    }
    
  }
  
}
