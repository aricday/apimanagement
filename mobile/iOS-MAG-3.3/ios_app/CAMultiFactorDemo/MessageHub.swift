//
//  MessageHub.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 4/27/16.
//  Copyright © 2016 CA. All rights reserved.
//

import Foundation

let MessageHubReceivedMessage = "MessageHubReceivedMessage"
let MessageHubSentMessage = "MessageHubSentMessage"
let MessageHubFailedSendMessage = "MessageHubFailedSendMessage"

class MessageHub {
    
    static var sharedInstance: MessageHub? = MessageHub()
    
    // All Messages in format ["username", [MASMessage]]
    private var messages = [String:[MASMessage]]()
    private var background = false
    
    enum MessageSort {
        case Ascending
        case Descending
    }
    
    init()
    {
        messages = [String:[MASMessage]]()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didReceiveMessageNotification),
            name: MASConnectaMessageReceivedNotification,
            object: nil)
        
        // Background Modes= Listening
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(setAppBackground),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(setAppActive),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        
        listen()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: MASConnectaMessageReceivedNotification,
            object: nil)
        stopListen()
    }
    
    func reload()
    {
        MessageHub.sharedInstance = MessageHub()
    }
    
    @objc func setAppActive(notification: NSNotification)
    {
        self.background = false
    }
    
    @objc func setAppBackground(notification: NSNotification)
    {
        self.background = true
        let application = UIApplication.sharedApplication()
        application.applicationIconBadgeNumber = 0
    }
    
    func sendMessage(user: MASUser, message: MASMessage)
    {
            print("Sending message...")
            // Send message
            let myUser = MASUser.currentUser()
            myUser.sendMessage(message, toUser: user, completion: { (complete: Bool, error: NSError?) in
                if(error != nil)
                {
                    // Failure, notify app.
                    print(error?.description)
                    NSNotificationCenter.defaultCenter().postNotificationName(MessageHubFailedSendMessage, object: nil)
                    return
                }
                // Success, add message to list, notify app.
                self.addMessage(user.objectId, message: message)
                NSNotificationCenter.defaultCenter().postNotificationName(MessageHubSentMessage, object: nil)
            })
    }
    
    private func addMessage(objectId: String, message: MASMessage)
    {
        if self.messages[objectId] == nil {
            self.messages[objectId] = []
        }
        self.messages[objectId]?.append(message)
    }
    
    private func sortMessages(objectId: String, direction: MessageSort) {
        switch direction {
            case .Ascending:
                // Do something
                break
            case .Descending:
                break
        }
    }
    
    // Get user messages
    func getMessages(objectId:String) -> [MASMessage]
    {
        if let userMessages = self.messages[objectId] {
            return userMessages
        }
        return []
    }
    
    // Start listening
    private func listen()
    {
        print("Attempting to listen to my messages...")
        let user = MASUser.currentUser()
        user.startListeningToMyMessages { (complete: Bool, error: NSError?) in
            print("Started listening to my messages...")
        }
    }
    
    // Stop listening
    func stopListen()
    {
        let user = MASUser.currentUser()
        user.stopListeningToMyMessages { (complete: Bool, error: NSError?) in
            print("Stopped listening to my messages...")
        }
    }
    
    // Get Incoming Message
    @objc private func didReceiveMessageNotification(notification: NSNotification)
    {
        if let msgDict = notification.userInfo as? [String: MASMessage] {
            
            let message = msgDict[MASConnectaMessageKey]
            if message?.senderType == MASSenderType.User {
                
                
                if background {
                    let application = UIApplication.sharedApplication()
                    application.applicationIconBadgeNumber += 1
                    
                    // create a corresponding local notification
                    let notification = UILocalNotification()
                    notification.alertBody =  message!.senderDisplayName+": "+message!.payloadTypeAsString()// text that will be displayed in the notification
                    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                    notification.userInfo = ["action":"userchat","userid": message!.senderObjectId] // assign a unique identifier to the notification so that we can retrieve it later
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                }
                
                self.addMessage((message?.senderObjectId)!, message: message!)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(MessageHubReceivedMessage, object: nil)
        }
    }
    
}