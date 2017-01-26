//
//  GroupMemberTableCell.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class GroupMemberTableCell : CustomTableCellComponent {
    @IBOutlet var memberNameLabel: UILabel?
    @IBOutlet var memberUsernameLabel: UILabel?
    @IBOutlet var memberImage: UIImageView?
    
    static var memberImages: [String: UIImage] = [:]
    
    func loadItem(name: String, username: String)
    {
        self.backgroundColor = CAPresalesPro.foregroundColor
        
        memberNameLabel?.text = name
        memberUsernameLabel?.text = username
        self.memberImage?.layer.masksToBounds = true
        self.memberImage?.layer.cornerRadius = (self.memberImage?.bounds.width)! / 2
        self.memberImage?.layer.borderWidth = 2
        self.memberImage?.layer.borderColor = CAPresalesPro.textColor.CGColor
        
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
