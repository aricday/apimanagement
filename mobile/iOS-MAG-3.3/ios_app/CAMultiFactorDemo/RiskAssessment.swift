//
//  RiskAssessment.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/7/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class  RiskAssessment: BaseDemo, RMDeviceInventoryDelegate {
    
    var rmdeviceDNAWithLocation: RMDeviceInventory?
    private var deviceIdKey: String = ""
    
    override var demoTitle: String {
        return "Risk Assessment"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startRiskAssessment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set unique key for DeviceId storage
        self.deviceIdKey = "DeviceId_"+MASUser.currentUser().objectId
    }
    
    func startRiskAssessment()
    {
        // Call AA DeviceDNA SDK
        rmdeviceDNAWithLocation = RMDeviceInventory.sharedInstance()
        rmdeviceDNAWithLocation?.collectDeviceDNA(self)
    }
    
    func didCompletedCollectingDeviceDNA(deviceDNA: String!) {
        print("Device DNA: \n"+deviceDNA)
        var json: AnyObject? = nil
        do {
            json = try NSJSONSerialization.JSONObjectWithData(deviceDNA.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers)
            if let data = json as? [String: AnyObject] {
                let dDNA = data["deviceSignature"]! as AnyObject
                let dDNAObj = try NSJSONSerialization.dataWithJSONObject(dDNA, options: [])
                let deviceDNAString = NSString(data: dDNAObj, encoding: NSUTF8StringEncoding)
                
                // Call risk assessment url here...
                let params: NSMutableDictionary = NSMutableDictionary()
                params.setObject(deviceDNAString!, forKey: "devicedna")
//                MASSecureStorage.saveToLocalStorageObject(0x012091480, withKey: self.deviceIdKey, andType: "String", completion: { (complete: Bool, error: NSError!) in
//                    if(error != nil)
//                    {
//                        print(error.description)
//                    }
//                })
            } else {
                // Bad data from Risk SDK?
            }
        } catch _ {
            json = nil
        }
    }

}
