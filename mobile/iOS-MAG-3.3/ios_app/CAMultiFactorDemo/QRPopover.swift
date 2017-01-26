//
//  QRPopover.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/2/16.
//  Copyright © 2016 CA. All rights reserved.
//

//
//  QRScanner.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/2/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class QRPopover: UIViewController {
    
    func initQR(masGroupId:String)
    {
        let QRImage: UIImageView = UIImageView()
        let QR: QRCode = QRCode("{\"mas_group_id\":\"\(masGroupId)\"}")!
        var bounds:CGRect = CGRect();
        
        let size = CGSizeApplyAffineTransform(QR.image.size, CGAffineTransformMakeScale(0.5, 0.5))
        let hasAlpha = false
        let scale: CGFloat = 2.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        QR.image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        
        bounds.origin = CGPointZero
        bounds.size = CGSizeMake(QR.image.size.width/1.5, QR.image.size.height/1.5)
        QRImage.contentMode = UIViewContentMode.ScaleAspectFit;
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        QRImage.bounds = bounds;
        QRImage.image = scaledImage
        QRImage.autoresizesSubviews = true
        
        QRImage.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
        
        self.view.addSubview(QRImage)
    }
}

