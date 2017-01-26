//
//  LaunchScreen.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 5/18/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit
import CoreLocation

class LaunchScreen: UIViewController {
  
  @IBOutlet weak var CAlogo: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    checkStatus()
    
  }
  
  func checkStatus()
  {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      print("Current CAPresalesPro.sharedInstance.getStatus(): \(CAPresalesPro.sharedInstance.getStatus())")
      if(CAPresalesPro.sharedInstance.getStatus() != .Started)
      {
        switch(CAPresalesPro.sharedInstance.getStatus())
        {
        case .Error:
          print("An error has occurred")
          self.statusLabel.text = "An Error has Occurred. Restart the app!"
          break
        case .TimedOut:
          print("Is the MAS/MAG server online?")
          self.statusLabel.text = "The network request has timed out.\nIs the MAS/MAG server online?\nVerify connectivity and restart the app!"
          break
        case .NotAvailable:
          print("Is the MAS/MAG service running?")
          self.statusLabel.text = "The network host is not currently reachable.\nIs the MAS/MAG service running?\nVerify connectivity and restart the app!"
          break
        case .LocationDisabled:
          print("Location must be enabled...")
          self.statusLabel.text = "Location Services Required"
          let alertController = UIAlertController (title: "Location Required", message: "This app requires location to work! Please go to your settings, turn on location services, and restart the app.", preferredStyle: .Alert)
          
          let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
              UIApplication.sharedApplication().openURL(url)
            }
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
          alertController.addAction(settingsAction)
          alertController.addAction(cancelAction)
          
          self.presentViewController(alertController, animated: true, completion: nil);
          break
        case .Stopped:
          break
        case .Starting:
          self.checkStatus()
          break
        default:
          break
        }
      } else {
        self.statusLabel.hidden = true
        self.animateImage()
      }
    }
  }
  
  func animateImage()
  {
    // Fade out our logo...
    UIView.animateWithDuration(1.0, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: {() in
      self.CAlogo.alpha = 0.0;
      },
                               completion: {(Bool) in
                                self.performSegueWithIdentifier("splashToLogin", sender: nil)
    })
  }
}
