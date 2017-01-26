//
//  CustomComponent.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/5/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class CustomTableCellComponent: UITableViewCell {
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        self.recursiveReplace(self.subviews)
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
                    let fontDescriptor: UIFontDescriptor = font.fontDescriptor();
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
