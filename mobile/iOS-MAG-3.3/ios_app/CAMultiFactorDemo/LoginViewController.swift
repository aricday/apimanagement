//
//  LoginViewController.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/29/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var lookingLabel: UILabel!
  
  // Logout Function
  @IBAction func unwindToLogin(segue:UIStoryboardSegue)
  {
    // ** nothing to do now
    
  }
  
  @IBAction func doLogin()
  {
    //
    // A current user could be there and just NOT authenticated that, checking for nil would stop
    // it in its tracks if that is the case ... currently it will almost never be nil, only
    // on the first time running of the application.
    //
    
    // THIS WILL STOP IT RUNNING TWICE
    //if (MASUser.currentUser() == nil)
    
    
    // ** Do this instead
    if(MASUser.currentUser() == nil || MASUser.currentUser().isAuthenticated == false)
    {
      print("doLogin called and needs authentication");
      
      //
      // ** Start showing that we are waiting for login to succeed ...or fail :)
      //
      self.activityIndicator.startAnimating();
      
      //
      // ** It has been determined that either there is no current user OR there is one but it
      // is no longer authenticated (it is the previous user who was logged out or creds timed out)
      // so a login is needed.
      //
      MASUser.loginWithUserName(usernameTextField.text!, password: passwordTextField.text!)
      { (complete: Bool, error: NSError!) in
        
        print("loginWithUserName called");
        
        //
        // ** Stop showing the activity on success or failure
        //
        self.activityIndicator.stopAnimating();
        
        //
        // ** Handle error if present and stop there if found
        //
        if(error != nil)
        {
          //
          // ** Errors are valid if there is a bad username and/or password among other things
          //
          print("MAS code: \(error.code), details: \(error.localizedDescription)")
          // TODO let's try to de-register          
          //
          // ** Show the error visually so you know
          //
          let alert: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
          
          // ** Add a simple OK action to dismiss the controller
          let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
            // Doing nothing just dismisses the alert
          }
          alert.addAction(okAction)
          
          // ** Present the AlertController
          self.presentViewController(alert, animated: true, completion: nil)
          return
        }
        
        print("loginWithUserName done successfully");
        
        // ** If you reach this point the login completed successfully
        
        // ** this print line should show the users info, including isAuthenticated = true
        // If its not then its a bug
        print("Is the current user now authenticated: " + (MASUser.currentUser().isAuthenticated ? "YES" : "NO"))
        
        // Restart our message hub...
        MessageHub.sharedInstance?.reload()
        // ** All you should need to do now is segue
        self.performSegueWithIdentifier("mainMenuSegue", sender: self)
        
      }
    }
      
      //
      // Else the current user is authenticated, no need for a login just segue
      //
    else
    {
      print("doLogin called but NO authentication needed");
      
      // Restart our message hub...
      MessageHub.sharedInstance?.reload()
      
      self.performSegueWithIdentifier("mainMenuSegue", sender: self)
    }
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.usernameTextField.text = ""
    self.passwordTextField.text = ""
    usernameTextField.hidden = true
    passwordTextField.hidden = true
    lookingLabel.hidden = false
    loginBtn.hidden = true
    activityIndicator.startAnimating()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("LoginViewController.viewDidAppear")
    print("CAPresalesPro.fingerprintAuthenticationEnabled: ", CAPresalesPro.fingerprintAuthenticationEnabled)
    print("CAPresalesPro.fingerprintStrongAuthenticationEnabled: ", CAPresalesPro.fingerprintStrongAuthenticationEnabled)
    // ** If already logged in you can go straight past the login view
    
    if(MASUser.currentUser() != nil && MASUser.currentUser().isAuthenticated == true)
    {
      print("'\(MASUser.currentUser().userName)' is authenticated.")
      // app instance variables do not persist
      //      if CAPresalesPro.fingerprintStrongAuthenticationEnabled == true {
      //        print("need to step-up localauth here")
      //      }
      MessageHub.sharedInstance?.reload()
      self.performSegueWithIdentifier("mainMenuSegue", sender: self)
      
    } else if (MASUser.currentUser() != nil && MASUser.currentUser().isSessionLocked == true) {
      print("\(MASUser.currentUser().userName)'s session is locked")
      let alert:UIAlertController = UIAlertController(title: "Device is Locked!",
                                                      message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
      let unlockAction = UIAlertAction(title: "Unlock \(MASUser.currentUser().userName)'s session?", style: UIAlertActionStyle.Default, handler: {
        (alert: UIAlertAction!) -> Void in
        let message = "Fingerprint Authentication is Required"
        print("\(message). Trying to unlock session...")
        self.isLocallyAuthenticated(message, completionHandler: { (success: Bool) in
          if success {
            MASUser.currentUser().unlockSessionWithCompletion({ (complete: Bool, error: NSError!) in
              //        MASUser.currentUser().unlockSessionWithUserOperationPromptMessage("Session unlocked!", completion: { (complete: Bool, error: NSError!) in
              print("User session unlocked!")
              //          MASUser.currentUser().removeSessionLock()
              print("Is the current user now authenticated: " + (MASUser.currentUser().isAuthenticated ? "YES" : "NO"))

              //TODO error here
//              // Restart our message hub...
//              MessageHub.sharedInstance?.reload()
              
              // ** All you should need to do now is segue
              self.performSegueWithIdentifier("mainMenuSegue", sender: self)
            })
//          } else {
//            presentViewController(alert, animated: true, completion: nil)
          }
        })
      })
      let clearAction = UIAlertAction(title: "Clear session?", style: UIAlertActionStyle.Cancel, handler: {
        (alert: UIAlertAction!) -> Void in
        print("Trying to clear session...")
        MASUser.currentUser().removeSessionLock()
        if MASUser.currentUser() != nil {
          print("Is the current user now authenticated: " + (MASUser.currentUser().isAuthenticated ? "YES" : "NO"))
        }
        self.showLoginForm()
      })
      
      alert.addAction(unlockAction)
      alert.addAction(clearAction)
      //      alert.addAction(cancelAction)
      
      presentViewController(alert, animated: true, completion: nil)
    } else {
      showLoginForm()
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("LoginViewController.viewDidLoad")
    
    passwordTextField.delegate = self
    usernameTextField.delegate = self
    usernameTextField.hidden = false
    passwordTextField.hidden = false
    passwordTextField.text = ""
    usernameTextField.text = ""
    loginBtn.hidden = false
    lookingLabel.hidden = true
  }
  
  func failedToRegister(notification: NSNotification)
  {
    
  }
  
  // MARK - Login form textfield and animations
  
  // Show the Login form as a function
  func showLoginForm(){
    usernameTextField.hidden = false
    passwordTextField.hidden = false
    loginBtn.hidden = false
    lookingLabel.hidden = true
    activityIndicator.stopAnimating()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    print("textFieldShouldReturn")
    print("CAPresalesPro.fingerprintStrongAuthenticationEnabled ", CAPresalesPro.fingerprintStrongAuthenticationEnabled)
    // Let's check if fingerprintStrongAuthenticationEnabled is enabled
    if CAPresalesPro.fingerprintStrongAuthenticationEnabled == true {
      let message = "Fingerprint Strong Authentication is Required"
      print("\(message). Trying to step-up authentication")
      self.isLocallyAuthenticated(message, completionHandler: { (success: Bool) in
        if success {
          self.doLogin()
        }
      })
    } else if CAPresalesPro.oneTimePasswordStrongAuthenticationEnabled == true {
      let message = "One-Time Password Strong Authentication is Required"
      print("\(message). Trying to step-up authentication")
      self.doLogin()
    } else {
      self.doLogin()
    }
    return true
  }

  // MARK -- local authentication
  
  // check if a local fingerprint authentication is valid with completion
  func isLocallyAuthenticated(reasonString: NSString, completionHandler: (Bool) -> ()) {
    // Get the current authentication context
    let context : LAContext = LAContext()
    var error : NSError?
    var message: String!
    
    let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Disable the local Password option
    context.localizedFallbackTitle = ""
    
    // Check if the device can evaluate the policy.
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
      [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString as String,
        reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
          if success {
            message = "TouchID Authenticated"
            print(message)
            completionHandler(true)
          } else {
            // If authentication failed then show a message to the console with a short description.
            // In case that the error is a user fallback, then show the password alert view.
            print(evalPolicyError?.localizedDescription)
            alertController.title = "Failure"
            alertController.addAction(cancelAction)
            switch evalPolicyError!.code {
            case LAError.SystemCancel.rawValue:
              message = "Authentication was cancelled by the system"
              alertController.message = message
            case LAError.UserCancel.rawValue:
              message = "Authentication was cancelled by the user"
              alertController.message = message
            //            self.navigationController?.popViewControllerAnimated(true);
            case LAError.UserFallback.rawValue:
              message = "User selected to enter custom password"
              alertController.message = message
            default:
              message = "Authentication failed"
              alertController.message = message
            }
            print(message)
            //          self.presentViewController(alertController, animated: true, completion: nil)
            self.presentViewController(alertController, animated: true, completion: nil)
          }
      })]
    } else {
      print(error?.localizedDescription)
      alertController.title = "Failure"
      alertController.addAction(cancelAction)
      // If the security policy cannot be evaluated then show a short message depending on the error.
      switch error!.code{
      case LAError.TouchIDNotEnrolled.rawValue:
        message = "TouchID is not enrolled"
        alertController.message = message
      case LAError.PasscodeNotSet.rawValue:
        message = "A passcode has not been set"
        alertController.message = message
      default:
        // The LAError.TouchIDNotAvailable case.
        message = "TouchID not available"
        alertController.message = message
      }
      // Show the custom alert view to allow users to enter the password.
      self.presentViewController(alertController, animated: true, completion: nil)
    }
    completionHandler(false)
  }
  
}
