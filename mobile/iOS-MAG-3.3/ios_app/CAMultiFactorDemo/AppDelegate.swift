//
//  AppDelegate.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/26/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // Set background fetch intervals
    application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
    // Initialize CAPresalesPro
    CAPresalesPro.sharedInstance
    
    MAS.setWillHandleOTPAuthentication(false)
    
    MAS.setGatewayMonitor { (status: MASGatewayMonitoringStatus) in
      
      print("\n**********************\n received gateway monitoring updated status: \n"+MAS.gatewayMonitoringStatusAsString()+"\n**********************\n\n");
    }
    
    //
    // You need this in a common area that will always be called during startup
    // Putting it in the login view controller means it won't ever be called
    // unless that view controller is shown ... and start must always be called
    // on every startup
    //
    // The app delegate or the first guaranteed view controller to startup
    // are the places it should almost always be.  It DOES NOT mean
    // that login always happens ... the device registration only happens
    // once during the lifetime of the app, the first time it is run after
    // installation .. subsequent times it detects it has already registered
    // and skips that step
    //
    // But start always needs to be called regardless so that the process
    // are running ... its not all about device registeration
    //
    print("Attempting MAS start");
    
    self.startMAS { () in
      
    }
    
    return true
  }
  
  func startMAS(callback: () -> Void)
  {
    CAPresalesPro.sharedInstance.setStatus(.Starting)
    MAS.start { (complete: Bool, error: NSError!) in
      print("MAS.start called");
      
      // Check for error and stop here if found
      if error != nil {
        print("Error.description: \(error.description)")
        print("Error.code: \(error.code)")
        if error.code == 25 {
          if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
              CAPresalesPro.sharedInstance.setStatus(.LocationDisabled)
            default:
              break
            }
          } else {
            CAPresalesPro.sharedInstance.setStatus(.LocationDisabled)
          }
        } else if error.code == -1001 {
          CAPresalesPro.sharedInstance.setStatus(.TimedOut)
        } else if error.code == -1004 {
          CAPresalesPro.sharedInstance.setStatus(.NotAvailable)
        } else {
          MASDevice.currentDevice().resetLocally()
//          MASDevice.currentDevice().resetLocallyWithCompletion { (complete: Bool, error: NSError!) in
////          MASDevice.currentDevice().resetLocally { (complete: Bool, error: NSError!) in
//            if error != nil {
//              print("error resetLocallyWithCompletion: \(error)")
//              CAPresalesPro.sharedInstance.setStatus(.Error)
//            }
            CAPresalesPro.sharedInstance.setStatus(.Stopped)
//          }
        }
        // Call Back Function
        callback()
        return;
      }
      print("MAS.start done successfully");
      CAPresalesPro.sharedInstance.setStatus(.Started)
      
      MAS.enableLocalStorage()
      
      if !CAPresalesPro.sharedInstance.isSimulated() {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        if !CAPresalesPro.sharedInstance.isSimulated() {
          UIApplication.sharedApplication().registerForRemoteNotifications()
        }
      }
    }
    
  }
  
  private func convertDeviceTokenToString(deviceToken:NSData) -> String {
    //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
    var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", options: .CaseInsensitiveSearch, range: nil)
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", options: .CaseInsensitiveSearch, range: nil)
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: .CaseInsensitiveSearch, range: nil)
    
    // Our API returns token in all uppercase, regardless how it was originally sent.
    // To make the two consistent, I am uppercasing the token string here.
    deviceTokenStr = deviceTokenStr.uppercaseString
    return deviceTokenStr
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    print("Registered for remote notifications...")
    let deviceTokenStr = convertDeviceTokenToString(deviceToken)
    print("Device Token: "+deviceTokenStr)
    // ...register device token with something
    CAPresalesPro.deviceID = deviceTokenStr
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("Device token for push notifications: FAIL -- ")
    print(error.description)
  }
  
  // Called when a notification is received and the app is in the
  // foreground (or if the app was in the background and the user clicks on the notification).
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    // display the userInfo
    if let notify = userInfo["aps"] as? NSDictionary {
      NSNotificationCenter.defaultCenter().postNotificationName(CAPresalesPro.CAPresalesProPushNotificactionReceived, object: nil, userInfo: notify as [NSObject : AnyObject])
      completionHandler(.NoData)
      
    }
  }
  
  // For local notifications
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    let userInfo = notification.userInfo
    if let action = userInfo!["action"] as? String {
      if action == "userchat"
      {
        // Put some function here to open to the actual user chat
      }
    }
    print(notification.userInfo)
    
    
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // If we've opted to send a background notification... send it.
    
    if CAPresalesPro.sharedInstance.backgroundNotification {
      sleep(1)
      MAS.getFrom("/pushitgood", withParameters: [:], andHeaders: ["deviceID":CAPresalesPro.deviceID, "delay":"0"]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        if(error != nil)
        {
          print("Could not send background push notification...")
          print(error?.description)
        }
      }
      CAPresalesPro.sharedInstance.backgroundNotification = false
    }
    
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    MAS.stop { (complete: Bool, error: NSError!) in
      
    }
  }
  
  // Background Fetch
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    if CAPresalesPro.sharedInstance.backgroundNotification {
      MAS.getFrom("/pushitgood", withParameters: [:], andHeaders: ["deviceID":CAPresalesPro.deviceID, "delay":"0"]) { (response: [NSObject : AnyObject]!, error: NSError?) in
        if(error != nil)
        {
          print("Could not send background push notification...")
          print(error?.description)
        }
      }
      CAPresalesPro.sharedInstance.backgroundNotification = false
    }
  }
  
  // Wake from Watch
  func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
    // If MAS is not started, lets try to start it
    let status = CAPresalesPro.sharedInstance.getStatus()
    if status != .Started && status != .Starting {
      self.startMAS({
        if CAPresalesPro.sharedInstance.getStatus() == .Started {
          if MASUser.currentUser() != nil && MASUser.currentUser().isAuthenticated {
            reply(["connected":"authenticated"])
          } else {
            reply(["connected":"connected"])
          }
        } else {
          reply(["connected":"disconnected"])
        }
      })
    } else if status == .Started {
      if MASUser.currentUser() != nil && MASUser.currentUser().isAuthenticated {
        reply(["connected":"authenticated"])
      } else {
        reply(["connected":"connected"])
      }
    }
  }
  
}

