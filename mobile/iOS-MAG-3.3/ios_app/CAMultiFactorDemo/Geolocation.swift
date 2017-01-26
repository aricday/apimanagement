//
//  Geolocation.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 5/17/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class Geolocation: BaseDemo {
  
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  @IBOutlet weak var degreesLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var iconView: UIImageView!
  
  override var demoTitle: String {
    return "Geolocation"
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // Get weather
    progressIndicator.startAnimating()
    dispatch_async(dispatch_get_main_queue()) {
      MAS.getFrom("/weather", withParameters: [:], andHeaders: [:]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        self.progressIndicator.stopAnimating()
        if(error != nil)
        {
          print("Could not retrieve weather...")
        } else {
          if let json = response[MASResponseInfoBodyInfoKey] as? [String: String] {
            let weather = json["weather"]
            let location = json["location"]
            let temp = json["temp"]! + (NSString(format:"%@", "\u{00B0}") as String)+"F"
            let icon = json["icon"]!
            
            self.locationLabel.text = location
            self.degreesLabel.text = temp
            
            switch(icon){
            case "chanceflurries","chancesnow","snow","flurries","int_chanceflurries","int_chancesnow","int_snow","int_flurries":
              self.iconView.image = UIImage(named: "snow")
              break;
            case "clear","sunny":
              self.iconView.image = UIImage(named: "sunny")
              break;
            case "chancerain","rain":
              self.iconView.image = UIImage(named: "heavyrain")
              break;
            case "chancesleet","sleet":
              self.iconView.image = UIImage(named: "rain")
              break;
            case "int_clear","int_sunny":
              self.iconView.image = UIImage(named: "nighttime")
              break;
            default:
              break;
              
            }
            
          }
        }
      }
    }
    
  }
  
}
