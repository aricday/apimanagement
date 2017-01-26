//
//  QRScanner.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 3/2/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanner: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    static let QRCodeMASGroupIDFound = "QRCodeMASGroupIDFound"
    static let QRCodeMASUserIDFound = "QRCodeMASUserIDFound"
    
    override func didAddSubview(subview: UIView) {
        super.didAddSubview(subview)
        if(videoPreviewLayer != nil) {
            videoPreviewLayer?.frame = self.layer.bounds
        }
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        if(videoPreviewLayer != nil) {
            videoPreviewLayer?.frame = self.layer.bounds
        }
    }
    
    func initScanner() {
        self.clipsToBounds = true
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("Cannot start camera: \(error!.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = self.layer.bounds
        self.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.whiteColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        self.addSubview(qrCodeFrameView!)
        self.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func startScanner()
    {
        captureSession?.startRunning()
    }
    
    func stopScanner()
    {
        captureSession?.stopRunning()
        qrCodeFrameView?.frame = CGRectZero
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
                var error: NSError? = nil;
                var jsonObject: AnyObject?
                do {
                    jsonObject = try NSJSONSerialization.JSONObjectWithData(
                        metadataObj.stringValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!,
                        options: NSJSONReadingOptions())
                } catch let error1 as NSError {
                    error = error1
                    jsonObject = nil
                }
                if error == nil {
                    // Custom for MAS
                    if ((jsonObject as! NSDictionary)["mas_group_id"] as? String) != nil {
                        NSNotificationCenter.defaultCenter().postNotificationName(QRScanner.QRCodeMASGroupIDFound, object: nil, userInfo: jsonObject as! NSDictionary as? [NSObject : AnyObject])
                    }
                    if ((jsonObject as! NSDictionary)["mas_user_id"] as? String) != nil {
                        NSNotificationCenter.defaultCenter().postNotificationName(QRScanner.QRCodeMASUserIDFound, object: nil, userInfo: jsonObject as! NSDictionary as? [NSObject : AnyObject])
                    }
                    
                }
            }
        }
    }
}
