//
//  CAPresalesPro.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Foundation
import UIKit

enum CAPresalesProStatus {
  case Stopped
  case Started
  case Starting
  case LocationDisabled
  case Error
  case TimedOut
  case NotAvailable
}

class CAPresalesPro {
  static let sharedInstance = CAPresalesPro()
  
  // Themeing
  static let backgroundColor: UIColor = UIColor(netHex: 0x152B3A)
  static let foregroundColor: UIColor = UIColor(netHex: 0x204259)
  static let textColor: UIColor = UIColor(netHex: 0xF0F0F0)
  static let fontName: String = "CA Sans"
  
  // Notifications
  static let CAPresalesProPushNotificactionReceived: String = "CAPresalesProPushNotificactionReceived"
  static var deviceID: String = ""
  
  // Retries for Connectivity
  static let timedOutRetry = 2
  static let notAvailableRetry = 5
  
  // MARK -- Initial Settings.swift vars are set here
  
  // TouchID for Authentication
  static var fingerprintAuthenticationEnabled: Bool = false
  static var fingerprintAuthenticationLabel: String = "Fingerprint Authentication: "
  
  // TouchID for Strong Authentication
  static var fingerprintStrongAuthenticationEnabled: Bool = false
  static var fingerprintStrongAuthenticationLabel: String = "Fingerprint Strong Authentication: "
  
  // OTP for Strong Authentication
  static var oneTimePasswordStrongAuthenticationEnabled: Bool = false
  static var oneTimePasswordStrongAuthenticationLabel: String = "One-time Password Strong Authentication: "
  static var oneTimePasswordChannelEnabled: Bool = false
  static var oneTimePasswordChannelLabel: String = "One-time Password Channel: "
  static var oneTimePasswordChannel: String = "SMS"

  
  private var userImages: [String: UIImage] = [:]
  private var isSimulator: Bool = false
  
  private var status: CAPresalesProStatus = CAPresalesProStatus.Stopped
  
  var backgroundNotification: Bool = false
  
  enum DemoType: String {
    case DeviceOnly = "DemoTypeDeviceOnly"
    case DeviceAndSimulator = "DemoTypeDeviceAndSimulator"
  }
  
  // Demo setup
  // Name, Description, Image, Storyboard, DemoType
  private let _demos:[(String, String, String, String, DemoType)] = [
    ("Secure API Access", "Secure APIs with MAG", "sso", "SSO", .DeviceAndSimulator),
    ("Disarm/Arm with TouchID", "Secure APIs with TouchID", "qr", "TouchIDSecureAPI", .DeviceAndSimulator),
    ("Secure API with OTP", "Secure APIs with OTP", "push up", "OTPSecureAPI", .DeviceAndSimulator),
    ("Geolocation", "Geolocation with MAG", "geolocation", "Geolocation", .DeviceAndSimulator),
    //("Advanced Auth", "CA Advanced Auth with MAG", "risk", "Risk", .DeviceOnly), // DeviceDNA fails in Simulator
    ("Push Notifications", "Push Notifications with MAG", "push", "PushNotifications", .DeviceOnly), // Can't push notify on simulator
    ("Settings", "Configure user settings", "architecture", "Settings", .DeviceAndSimulator)
    //        ("Ad-Hoc Groups", "Ad-Hoc Groups with MAS", "groups", "Groups", .DeviceAndSimulator),
    //        ("Messaging", "Messaging with MAS", "messages", "Messages", .DeviceAndSimulator),
    //        ("Storage", "Secure Storage with MAS", "storage", "Storage", .DeviceAndSimulator),
    // Coming soon... When I have an IoT Device to play with.
    //("Pub-Sub", "IoT and Notifications with MAS", "pubsub", "PubSub", .DeviceAndSimulator),
  ]
  // Active list based on device or simulator
  private var activeDemos: [(String, String, String, String, DemoType)] = []
  
  init(){
    // Check for simulator.  If it is, we're going to filter the available demos.
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      isSimulator = true
    #endif
    
    // Build Demo List for Demos that can be run in current environment
    for demo in self._demos {
      let (_,_,_,_,type) = demo
      if (isSimulated() && type == .DeviceAndSimulator) || !isSimulated() {
        self.activeDemos.append(demo)
      }
    }
  }
  
  // Check for simulator
  func isSimulated() -> Bool
  {
    return isSimulator
  }
  
  func demos() -> [(String, String, String, String, DemoType)]
  {
    return self.activeDemos
  }
  
  // User image "cache" get/set
  func getUserImage(username: String) -> UIImage?
  {
    if self.userImages[username] != nil {
      return self.userImages[username]
    }
    return nil
  }
  
  func setUserImage(username: String, image: UIImage)
  {
    self.userImages[username] = image
  }
  
}

// Presales Pro Status Extensions
extension CAPresalesPro {
  func setStatus(newStatus: CAPresalesProStatus)
  {
    self.status = newStatus
  }
  
  func getStatus() -> CAPresalesProStatus
  {
    return self.status
  }
  
  func isConnected() -> Bool
  {
    return (self.status == .Started)
  }
}

// UIColor Extensions
extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
}

// MASMessage Extension
extension MASMessage {
  
  
}
