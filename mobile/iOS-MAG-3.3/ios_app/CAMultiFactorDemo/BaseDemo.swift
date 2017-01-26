//
//  BaseDemo.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Foundation
import UIKit

class BaseDemo: UIViewController {
    // Demo Title
    var demoTitle: String {
        return "Base Demo"
    }
    
    // Back Button
    var backButton: String? {
        return nil
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Theme it
        self.recursiveReplace(self.view.subviews)
        let nav = self.navigationController?.navigationBar
        // Style for our Brand
        self.view.backgroundColor = CAPresalesPro.foregroundColor
        nav?.barStyle = UIBarStyle.BlackOpaque
        nav?.backgroundColor = CAPresalesPro.backgroundColor
        nav?.tintColor = CAPresalesPro.textColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: CAPresalesPro.textColor,
                                    NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 21)!]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: CAPresalesPro.textColor,
            NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: CAPresalesPro.textColor,
            NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: CAPresalesPro.textColor,
            NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 15)!], forState: UIControlState.Normal)
        
        
        if self.backButton != nil {
            nav?.backItem?.title = self.backButton
            nav?.backItem?.backBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: CAPresalesPro.textColor,
                NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 15)!], forState: UIControlState.Normal)
            nav?.backItem?.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: CAPresalesPro.textColor,
                NSFontAttributeName: UIFont(name: CAPresalesPro.fontName, size: 15)!], forState: UIControlState.Normal)
        }
        
        MAS.setGatewayMonitor { (status: MASGatewayMonitoringStatus) in
            if(status == MASGatewayMonitoringStatus.GatewayMonitoringStatusNotReachable)
            {
                // Do something like... block... or bail.
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set Nav Text
        self.navigationItem.title = self.demoTitle
    }
    
    // Go back to Main Menu
    @IBAction func backToMain(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("MainMenuController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //
    private func recursiveReplace(subviews: [UIView])
    {
        for view in subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if let label = view as? UILabel {
                    let font = label.font
                    //let fontDescriptor: UIFontDescriptor = font.fontDescriptor();
                    // FIXME: Make Font the same, except for the font-name
                    //label.font = UIFont(name: CAPresalesPro.fontName, size: label.font.pointSize)
                    label.textColor = CAPresalesPro.textColor
                }
            } else if view.isKindOfClass(UITextField)
            {
                if let textField = view as? UILabel {
                    textField.font = UIFont(name: CAPresalesPro.fontName, size: textField.font.pointSize)
                }
            } else {
                recursiveReplace(view.subviews)
            }
        }
    }

    
}
