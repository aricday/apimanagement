//
//  UserTableCell.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class UserTableCell : CustomTableCellComponent {
    @IBOutlet var userNameLabel: UILabel?
    @IBOutlet var userUsernameLabel: UILabel?
    @IBOutlet var userImage: UIImageView?
    @IBOutlet var actionImage: UIImageView?
    
    
    func loadItem(name: String, username: String)
    {
        self.backgroundColor = CAPresalesPro.foregroundColor
        userNameLabel?.text = name
        userUsernameLabel?.text = username
        self.userImage?.layer.masksToBounds = true
        self.userImage?.layer.cornerRadius = (self.userImage?.bounds.width)! / 2
        self.userImage?.layer.borderWidth = 2
        self.userImage?.layer.borderColor = CAPresalesPro.textColor.CGColor
        
        if let image  = CAPresalesPro.sharedInstance.getUserImage(username)
        {
            self.userImage?.image = image
//  // TODO - update for 1.3.00-MAS
//        } else {
//            MASUser.getUsersWithUsername(username, range: NSMakeRange(0, 100)) { (users:[AnyObject]!, error: NSError!, pages: UInt) in
//                for user in users {
//                    let photos = user.photos as NSDictionary
//                    self.userImage?.image = photos["thumbnail"] as? UIImage
//                    CAPresalesPro.sharedInstance.setUserImage(username, image: (photos["thumbnail"] as? UIImage)!)
//                }
//            }
        }
    }
}
