//
//  MainMenuViewController.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/26/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var tableView:UITableView?
  @IBOutlet weak var userName: UILabel?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if MASUser.currentUser() != nil {
      userName?.text = MASUser.currentUser().userName
    } else {
      userName?.text = "Unknown"
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    let nib = UINib(nibName: "MainMenuCell", bundle: nil)
    self.tableView!.registerNib(nib, forCellReuseIdentifier: "MainMenuCell")
    self.tableView!.rowHeight = 70
    self.tableView!.delegate = self
    self.tableView!.dataSource = self
    self.tableView!.reloadData()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func settingsButtonClicked(sender: AnyObject) {
    print("settingsButtonClicked")
  }
  
  @IBAction func doLogout()
  {
    //
    // ** Start showing that we are waiting for logout to succeed ...or fail :)
    //
    self.activityIndicator.startAnimating();
    
    // Check if CAP
    //
    // ** Perform loggoff and WAIT for completion
    //
    if CAPresalesPro.fingerprintAuthenticationEnabled {
      print("Let's try to lock the device")
      MASUser.currentUser().lockSessionWithCompletion{(complete: Bool, error: NSError!) in
        //
        // ** Stop showing the activity on success or failure
        //
        self.activityIndicator.stopAnimating();
        
        if (error != nil) {
          //
          // ** Errors are can sometimes be valid for various reasons
          //
          print(error.localizedDescription)
          
          //
          // ** Show the error visually so you know the logout didn't work
          //
          let alert: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
          
          // ** Add a simple OK action to dismiss the controller
          let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
            // Doing nothing just dismisses the alert
          }
          alert.addAction(okAction)
          return;
        } else {
          print("Device Locked!")
          
          // ** If you reach this point the logoff completed successfully
          
          // NOTE: the MASUser does NOT become nil, it is still there just marked isAuthenticated = false
          
          // ** this print line should show the users info, including isAuthenticated = false
          // If its not then its a bug
          if MASUser.currentUser() != nil {
            print("Is the current user still authenticated: " + (MASUser.currentUser().isAuthenticated ? "YES" : "NO"))
          }
          //
          // ** If the above is true then it did successfully logoff ... only now perform the unwind
          //
          self.performSegueWithIdentifier("unwindToLogin", sender: self)
        }
      }
    } else {
      //    MASUser.currentUser().logoffWithCompletion { (complete: Bool, error: NSError!) in
      MASUser.currentUser().logoutWithCompletion { (complete: Bool, error: NSError!) in
        
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
          // ** Errors are can sometimes be valid for various reasons
          //
          print(error.localizedDescription)
          
          //
          // ** Show the error visually so you know the logout didn't work
          //
          let alert: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
          
          // ** Add a simple OK action to dismiss the controller
          let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
            // Doing nothing just dismisses the alert
          }
          alert.addAction(okAction)
          
          // ** Present the AlertController
          self.presentViewController(alert, animated: true, completion: nil)
          return;
        }
        
        // ** If you reach this point the logoff completed successfully
        
        // NOTE: the MASUser does NOT become nil, it is still there just marked isAuthenticated = false
        
        // ** this print line should show the users info, including isAuthenticated = false
        // If its not then its a bug
        if MASUser.currentUser() != nil {
          print("Is the current user still authenticated: " + (MASUser.currentUser().isAuthenticated ? "YES" : "NO"))
        }
        //
        // ** If the above is true then it did successfully logoff ... only now perform the unwind
        //
        self.performSegueWithIdentifier("unwindToLogin", sender: self)
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CAPresalesPro.sharedInstance.demos().count;
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:MainMenuTableViewCell = self.tableView!.dequeueReusableCellWithIdentifier("MainMenuCell") as! MainMenuTableViewCell
    
    let (title, description, image, _, _) = CAPresalesPro.sharedInstance.demos()[indexPath.row]
    
    cell.loadItem(image, title: title, description: description)
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    // Perform segue to demo
    let (_, _, _, demo_storyboard, _) = CAPresalesPro.sharedInstance.demos()[indexPath.row]
    let storyboard = UIStoryboard(name: demo_storyboard, bundle: nil)
    let controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
    
    self.presentViewController(controller, animated: true, completion: nil)
    
    
  }
}

