//
//  SSOLogin.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class OTPSecureAPI: BaseDemo {
  
  
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var uuidLabel: UILabel!
  @IBOutlet weak var accessTokenLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var secureMessageLabel: UILabel!
  
  var otp: String?
  
  override var demoTitle: String {
    return "OTP Secure API"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.otp == nil {
      self.generateOTP()
      //      self.showOtpSubmitForm()
    } else {
      self.getDataWithOTP(self.otp!)
    }
  }
  
  @IBAction func getData()
  {
    print("getData clicked")
    if self.otp == nil {
      self.generateOTP()
    } else {
      self.getDataWithOTP(self.otp!)
    }
  }
  
  // Generate the OTP if value DNE
  func generateOTP()
  {
    // Get secured data
    progressIndicator.startAnimating()
    let headers: NSDictionary = ["X-OTP-CHANNEL": CAPresalesPro.oneTimePasswordChannel]
    let protectedUrl: String = "/auth/generateOTP"
    print("protectedUrl: \(protectedUrl), headers: \(headers)")
    dispatch_async(dispatch_get_main_queue()) {
      MAS.getFrom(protectedUrl, withParameters: [:], andHeaders: headers as [NSObject : AnyObject]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        self.progressIndicator.stopAnimating()
        if(error != nil)
        {
          print("Could not retrieve secure API...\(error)")
        } else {
          // initial OTP generation was successful, show the alert message
          if let headerResponse = response[MASResponseInfoHeaderInfoKey] as? [String: AnyObject] {
            print(headerResponse)
          }
          self.showOtpSubmitForm()
        }
      }
    }
    
  }
  
  // Get the OTP data if value DNE
  func getDataWithOTP(otp: String)
  {
    // Get secured data
    progressIndicator.startAnimating()
    let headers: NSDictionary = ["X-OTP-CHANNEL": CAPresalesPro.oneTimePasswordChannel, "X-OTP": otp]
    let protectedUrl: String = "/secure/otp"
    print("protectedUrl: \(protectedUrl), headers: \(headers)")
    dispatch_async(dispatch_get_main_queue()) {
      MAS.getFrom(protectedUrl, withParameters: [:], andHeaders: headers as [NSObject : AnyObject]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        self.progressIndicator.stopAnimating()
        self.otp = nil
        if(error != nil)
        {
          print("Could not retrieve secure API...\(error)")
          self.dismissViewControllerAnimated(true, completion: {});

        } else {
          // set the controller var back to nil
          if let json = response[MASResponseInfoBodyInfoKey] as? [String: AnyObject] {
            self.userLabel.text = json["user"] as? String
            self.urlLabel.text = json["url"] as? String
            self.uuidLabel.text = json["mag_identifier"] as? String
            self.accessTokenLabel.text = json["access_token"] as? String
            self.locationLabel.text = json["geolocation"] as? String
            self.secureMessageLabel.text = json["secure_data"] as? String
          }
          if let headerResponse = response[MASResponseInfoHeaderInfoKey] as? [String: AnyObject] {
            print(headerResponse)
          }
        }
      }
    }
    
  }
  
  // simple otp form
  func showOtpSubmitForm() {
    // New way to present an alert view using UIAlertController
    let alertController : UIAlertController = UIAlertController(title:"Submit OTP Password" , message: "Please enter password", preferredStyle: .Alert)
    alertController.modalPresentationStyle = .Popover
    // We define the actions to add to the alert controller
    let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: {});
    }
    let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
      let passwordTextField = alertController.textFields![0] as UITextField
      if let text = passwordTextField.text {
        self.otp = text
        self.getDataWithOTP(self.otp!)
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
    
    self.presentViewController(alertController, animated: true, completion: nil)

  }
  
  
  
  
}
