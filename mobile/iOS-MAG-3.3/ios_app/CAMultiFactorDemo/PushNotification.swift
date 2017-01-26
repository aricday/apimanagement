//
//  PushNotification.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/7/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class PushNotification: BaseDemo {
    
    @IBOutlet weak var delay: UITextField?
    @IBOutlet weak var backgroundNotification: UISwitch?
    
    override var demoTitle: String {
        return "Push Notifications"
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(showNotification),
            name: CAPresalesPro.CAPresalesProPushNotificactionReceived,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(updateBackground),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(updateBackground),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        backgroundNotification?.addTarget(self,action: #selector(setState), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundNotification?.setOn(CAPresalesPro.sharedInstance.backgroundNotification, animated: false)
    }
    
    @IBAction func pushIt()
    {
        if let delay = Double((self.delay?.text!)!) {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                MAS.getFrom("/pushitgood", withParameters: [:], andHeaders: ["deviceID":CAPresalesPro.deviceID, "delay":self.delay!.text!]) { (response: [NSObject : AnyObject]!, error: NSError?) in
                    if(error != nil)
                    {
                        print("Could not send push notification...")
                    }
                }
            }
        }
        
    }
    
    // Update Background notification
    func setState(sender: UISwitch)
    {
        CAPresalesPro.sharedInstance.backgroundNotification = sender.on
    }
    
    func updateBackground()
    {
        self.backgroundNotification?.setOn(CAPresalesPro.sharedInstance.backgroundNotification, animated: false)
    }
    
    func showNotification(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        if let data = userInfo!["alert"]!["body"] as? String {
            let alert: UIAlertController = UIAlertController(title: "Push Notification", message: data, preferredStyle: .Alert)
            
            // ** Add a simple OK action to dismiss the controller
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                
                // Doing nothing just dismisses the alert
            }
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}

