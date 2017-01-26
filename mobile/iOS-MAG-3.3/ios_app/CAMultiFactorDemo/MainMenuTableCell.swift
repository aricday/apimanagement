//
//  MainMenuTableCell.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Foundation

// Custom class for main menu cell
class MainMenuTableViewCell : CustomTableCellComponent {
    @IBOutlet var demoImage: UIImageView?
    @IBOutlet var demoTitleLabel: UILabel?
    @IBOutlet var demoDescriptionLabel: UILabel?
    
    func loadItem(image:String, title: String, description: String)
    {
        self.backgroundColor = CAPresalesPro.foregroundColor
        demoImage?.image = UIImage(named: image)
        demoTitleLabel?.text = title
        demoDescriptionLabel?.text = description
    }
    
}