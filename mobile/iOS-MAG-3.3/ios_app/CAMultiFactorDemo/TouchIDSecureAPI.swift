//
//  SSOLogin.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDSecureAPI: BaseDemo {
  
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var uuidLabel: UILabel!
  @IBOutlet weak var accessTokenLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var secureMessageLabel: UILabel!
  
  
  override var demoTitle: String {
    return "Disarm/Arm with TouchID"
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("TouchIDSecureAPI.viewDidAppear")
    authenticateUser()
  }
  
  
  @IBAction func getData()
  {
    // Get secured data
    progressIndicator.startAnimating()
    dispatch_async(dispatch_get_main_queue()) {
      MAS.getFrom("/secure/touchid", withParameters: [:], andHeaders: [:]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        self.progressIndicator.stopAnimating()
        if(error != nil)
        {
          print("Could not retrieve secure API...\(error)")
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
  
  
  // TouchID validation
  func authenticateUser() {
    // Get the current authentication context
    let context : LAContext = LAContext()
    var error : NSError?
    let reasonString : NSString = "Authentication is required"
    
    // Check if the device can evaluate the policy.
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
      [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString as String, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
        if success {
          print("TouchID Authenticated")
          self.getData()
        } else {
          // If authentication failed then show a message to the console with a short description.
          // In case that the error is a user fallback, then show the password alert view.
          print(evalPolicyError?.localizedDescription)
          
          switch evalPolicyError!.code {
            
          case LAError.SystemCancel.rawValue:
            print("Authentication was cancelled by the system")
            
          case LAError.UserCancel.rawValue:
            print("Authentication was cancelled by the user")
            //            self.navigationController?.popViewControllerAnimated(true);
            self.dismissViewControllerAnimated(true, completion: {});
            
          case LAError.UserFallback.rawValue:
            print("User selected to enter custom password")
            self.showPasswordAlert()
            
          default:
            print("Authentication failed")
            self.showPasswordAlert()
          }
        }
        
      })]
    }
    else{
      // If the security policy cannot be evaluated then show a short message depending on the error.
      switch error!.code{
        
      case LAError.TouchIDNotEnrolled.rawValue:
        print("TouchID is not enrolled")
        
      case LAError.PasscodeNotSet.rawValue:
        print("A passcode has not been set")
        
      default:
        // The LAError.TouchIDNotAvailable case.
        print("TouchID not available")
      }
      
      // Optionally the error description can be displayed on the console.
      print(error?.localizedDescription)
      
      // Show the custom alert view to allow users to enter the password.
      self.showPasswordAlert()
    }
  }
  
  // simple alert message
  func showPasswordAlert() {
    // New way to present an alert view using UIAlertController
    let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter password", preferredStyle: .Alert)
    
    // We define the actions to add to the alert controller
    let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: {});
    }
    let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
      let passwordTextField = alertController.textFields![0] as UITextField
      if let text = passwordTextField.text {
        if text == "CAdemo123" {
          self.getData()
        } else {
          print(action)
          self.dismissViewControllerAnimated(true, completion: {});
        }
      }
    }
    doneAction.enabled = false
    
    // We are customizing the text field using a configuration handler
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Password"
      textField.secureTextEntry = true
      
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
        doneAction.enabled = textField.text != ""
      })
    }
    alertController.addAction(cancelAction)
    alertController.addAction(doneAction)
    
    self.presentViewController(alertController, animated: true) {
      // Nothing to do here
    }
  }
  
}
