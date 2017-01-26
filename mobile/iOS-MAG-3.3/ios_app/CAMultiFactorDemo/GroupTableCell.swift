//
//  GroupTableCell.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class GroupTableCell : CustomTableCellComponent {
    @IBOutlet var groupNameLabel: UILabel?
    @IBOutlet var ownerLabel: UILabel?
    
    func loadItem(name: String, owner: String)
    {
        self.backgroundColor = CAPresalesPro.foregroundColor
        groupNameLabel?.text = name
        ownerLabel?.text = owner
        
    }
    
}