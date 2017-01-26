//
//  SettingsViewController.swift
//  CAMultiFactorDemo
//
//  Created by Christopher Page on 10/26/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class SettingsView: BaseDemo {
  
  @IBOutlet var fingerprintAuthenticationButton: UIButton!
  
  @IBOutlet var fingerprintStrongAuthenticationButton: UIButton!
  
  @IBOutlet var oneTimePasswordStrongAuthenticationButton: UIButton!
  
  @IBOutlet var oneTimePasswordChannelButton: UIButton!
  
  @IBAction func fingerprintAuthenticationButtonClicked(sender: UIButton) {
    print("fingerprintAuthenticationButtonClicked")
    sender.selected = !sender.selected
    CAPresalesPro.fingerprintAuthenticationEnabled = sender.selected
    self.setButtonState(sender, label: CAPresalesPro.fingerprintAuthenticationLabel)
  }
  
  @IBAction func fingerprintStrongAuthenticationButtonClicked(sender: UIButton) {
    print("fingerprintStrongAuthenticationButtonClicked")
    sender.selected = !sender.selected
    CAPresalesPro.fingerprintStrongAuthenticationEnabled = sender.selected
    self.setButtonState(sender, label: CAPresalesPro.fingerprintStrongAuthenticationLabel)
  }
  
  @IBAction func oneTimePasswordStrongAuthenticationButtonClicked(sender: UIButton) {
    print("oneTimePasswordStrongAuthenticationButtonClicked")
    sender.selected = !sender.selected
    CAPresalesPro.oneTimePasswordStrongAuthenticationEnabled = sender.selected
    self.setButtonState(sender, label: CAPresalesPro.oneTimePasswordStrongAuthenticationLabel)
    // Enabled/Disable the self.oneTimePasswordChannelButton too
    CAPresalesPro.oneTimePasswordChannelEnabled = sender.selected
    self.oneTimePasswordChannelButton.selected = sender.selected
    self.setButtonState(self.oneTimePasswordChannelButton, label: CAPresalesPro.oneTimePasswordChannelLabel)
  }
  
  @IBAction func oneTimePasswordChannelButtonClicked(sender: UIButton) {
    print("oneTimePasswordChannelButtonClicked")
    // CAPresalesPro.oneTimePasswordChannel can only be changed if it is enabled
    if CAPresalesPro.oneTimePasswordChannelEnabled {
      if CAPresalesPro.oneTimePasswordChannel == "SMS" {
        CAPresalesPro.oneTimePasswordChannel = "EMAIL"
      } else {
        CAPresalesPro.oneTimePasswordChannel = "SMS"
      }
      self.setButtonState(self.oneTimePasswordChannelButton, label: CAPresalesPro.oneTimePasswordChannelLabel)
    }
  }
  
  override var demoTitle: String {
    return "Settings"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    
    // fingerprintAuthenticationButton
    self.setButtonDefaultState(self.fingerprintAuthenticationButton, isEnabled: CAPresalesPro.fingerprintAuthenticationEnabled,
                               label: CAPresalesPro.fingerprintAuthenticationLabel)
    self.setButtonDefaultState(self.fingerprintStrongAuthenticationButton, isEnabled: CAPresalesPro.fingerprintStrongAuthenticationEnabled,
                               label: CAPresalesPro.fingerprintStrongAuthenticationLabel)
    // oneTimePasswordStrongAuthenticationButton
    self.setButtonDefaultState(self.oneTimePasswordStrongAuthenticationButton, isEnabled: CAPresalesPro.oneTimePasswordStrongAuthenticationEnabled,
                               label: CAPresalesPro.oneTimePasswordStrongAuthenticationLabel)
    self.setButtonDefaultState(self.oneTimePasswordChannelButton, isEnabled: CAPresalesPro.oneTimePasswordChannelEnabled,
                               label: CAPresalesPro.oneTimePasswordChannelLabel)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //getData()
    print("Settings.viewDidAppear")
  }
  
  // MARK -- local methods
  
  // configure all the boolean buttons the same by default
  func setButtonDefaultState(button: UIButton!, isEnabled: Bool!, label: String!) {
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    // Remove the background that is set in storyboard
    button.backgroundColor = UIColor.clearColor()
    button.layer.borderColor = UIColor.whiteColor().CGColor
    // UIControlState will always be Normal everytime the view loads.
    if isEnabled == true {
      button.selected = true
      button.tintColor = UIColor.clearColor()
      button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Selected)
      button.setTitle(label + "Enabled", forState: UIControlState.Selected)
    } else {
      button.selected = false
      button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      button.setTitle(label + "Disabled", forState: UIControlState.Normal)
    }
  }
  
  // configure the button for each each time it is selected
  func setButtonState(sender: UIButton!, label: String!) {
    if sender.selected == true {
      sender.tintColor = UIColor.clearColor()
      sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Selected)
      if label == CAPresalesPro.oneTimePasswordChannelLabel {
        sender.setTitle(label + CAPresalesPro.oneTimePasswordChannel, forState: UIControlState.Selected)
      } else {
        sender.setTitle(label + "Enabled", forState: UIControlState.Selected)
      }
    } else {
      sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      sender.setTitle(label + "Disabled", forState: UIControlState.Normal)
    }
  }
  
  
}
