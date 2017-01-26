//
//  ChatCell.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 4/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class ChatCell : CustomTableCellComponent {
    @IBOutlet var memberNameLabel: UILabel?
    @IBOutlet var memberMessageLabel: UILabel?
    @IBOutlet var memberImage: UIImageView?
    
    static var memberImages: [String: UIImage] = [:]
    
    func loadItem(name: String, username: String, message: String)
    {
        self.backgroundColor = CAPresalesPro.foregroundColor
        
        memberNameLabel?.text = name
        self.memberImage?.layer.masksToBounds = true
        self.memberImage?.layer.cornerRadius = (self.memberImage?.bounds.width)! / 2
        self.memberImage?.layer.borderWidth = 2
        self.memberImage?.layer.borderColor = CAPresalesPro.textColor.CGColor
        
        self.memberMessageLabel?.text = message
        
        if let image = CAPresalesPro.sharedInstance.getUserImage(username)
        {
            self.memberImage?.image = image
//        } else {
//            MASUser.getUsersWithUsername(username, range: NSMakeRange(0, 100)) { (users:[AnyObject]!, error: NSError!, pages: UInt) in
//                for user in users {
//                    let photos = user.photos as NSDictionary
//                    self.memberImage?.image = photos["thumbnail"] as? UIImage
//                    CAPresalesPro.sharedInstance.setUserImage(username, image: (photos["thumbnail"] as? UIImage)!)
//                }
//            }
        }
    }
    
}
