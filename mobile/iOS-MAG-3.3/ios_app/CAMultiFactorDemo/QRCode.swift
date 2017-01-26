//
//  QRCode.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/2/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Foundation
import UIKit

/// QRCode generator
public struct QRCode {
    
    /// CIQRCodeGenerator generates 27x27px images per default
    private let DefaultQRCodeSize = CGSize(width: 27, height: 27)
    
    /// Data contained in the generated QRCode
    public let data: NSData
    
    /// Foreground color of the output
    /// Defaults to black
    public var color = CIColor(red: 1, green: 1, blue: 1)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 0.08235294117647, green: 0.16862745098039, blue: 0.22745098039216)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    // MARK: Init
    
    public init(_ data: NSData) {
        self.data = data
    }
    
    public init?(_ string: String) {
        if let data = string.dataUsingEncoding(NSISOLatin1StringEncoding) {
            self.data = data
        } else {
            return nil
        }
    }
    
    public init?(_ url: NSURL) {
        if let data = url.absoluteString!.dataUsingEncoding(NSISOLatin1StringEncoding) {
            self.data = data
        } else {
            return nil
        }
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage {
        return UIImage(CIImage: ciImage)
    }
    
    /// The QRCode's CIImage representation
    public var ciImage: CIImage {
        // Generate QRCode
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter!.setDefaults()
        qrFilter!.setValue(data, forKey: "inputMessage")
        
        // Color code and background
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter!.setDefaults()
        colorFilter!.setValue(qrFilter!.outputImage, forKey: "inputImage")
        colorFilter!.setValue(color, forKey: "inputColor0")
        colorFilter!.setValue(backgroundColor, forKey: "inputColor1")
        
        // Size
        let sizeRatioX = size.width / DefaultQRCodeSize.width
        let sizeRatioY = size.height / DefaultQRCodeSize.height
        let transform = CGAffineTransformMakeScale(sizeRatioX, sizeRatioY)
        let transformedImage = colorFilter!.outputImage!.imageByApplyingTransform(transform)
        
        return transformedImage
    }
    
}
