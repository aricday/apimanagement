//
//  MessagesUserToUser.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 4/27/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class MessagesUserToUser: BaseDemo, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let msgHub: MessageHub = MessageHub.sharedInstance!
    var user: MASUser? = nil
    private var messages: [MASMessage] = []
    private var myUser: MASUser? = nil
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var messageField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView?
    
    override var demoTitle: String {
        if self.user != nil {
            return user!.formattedName
        }
        return "Chat with User"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ChatCell", bundle: nil)
        self.tableView!.registerNib(nib, forCellReuseIdentifier: "ChatCell")
        self.tableView!.rowHeight = 60
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        if self.user == nil {
            self.user = MASUser.currentUser()
        }
        
    }
    
    // Start listener and notification handler
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.messages = []
        
        self.messageField?.delegate = self
        self.myUser = MASUser.currentUser()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didReceiveMessage),
            name: MessageHubReceivedMessage,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didSendMesssage),
            name: MessageHubSentMessage,
            object: nil)

        // Get messages
        dispatch_async(dispatch_get_main_queue()) {
            self.messages = self.msgHub.getMessages(self.user!.objectId)
            self.tableView?.reloadData()
            self.scrollToLastRow()
        }
        
        registerForKeyboardNotifications()

        
    }
    
    // Unlisten
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MessageHubSentMessage, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MessageHubReceivedMessage, object: nil)
        
        deregisterFromKeyboardNotifications()
        
    }
    
    func didSendMesssage(notification: NSNotification)
    {
        dispatch_async(dispatch_get_main_queue()) {
            print("Main Sent Message")
            self.messages = self.msgHub.getMessages(self.user!.objectId)
            self.tableView?.reloadData()
            self.scrollToLastRow()
        }
    }
    
    func didReceiveMessage(notification: NSNotification)
    {
        dispatch_async(dispatch_get_main_queue()) {
            print("Main Received Message")
            self.messages = self.msgHub.getMessages(self.user!.objectId)
            self.tableView?.reloadData()
            self.scrollToLastRow()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.typingAttributes = nil
        textField.resignFirstResponder()
        sendMessage()
        return true
    }
    
    @IBAction func sendMessage()
    {
        self.messageField!.resignFirstResponder()
        if(messageField!.text != nil && messageField!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "") {
            self.msgHub.sendMessage(self.user!, message: MASMessage(payloadString: self.messageField!.text, contentType: "String"))
            self.messageField!.text = nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChatCell = self.tableView!.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        
        let message = self.messages[indexPath.row]
        if(message.payloadTypeAsString() == "") {
            
        }
        if(message.senderType == .Application) {
            cell.loadItem((myUser?.formattedName)!, username: (myUser?.objectId)!, message: message.payloadTypeAsString())
        } else {
            cell.loadItem(user!.formattedName, username: message.senderObjectId, message: message.payloadTypeAsString())
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        // Perform segue to group controller
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "chatWithUser")
        {
            let vc = segue.destinationViewController as! MessagesUserToUser
            vc.user = self.user
            print(vc.user)
            
        }
    }
    
    func scrollToLastRow() {
        let indexPath = NSIndexPath(forRow: messages.count - 1, inSection: 0)
        if(messages.count > 0) {
            self.tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }

    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessagesUserToUser.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessagesUserToUser.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        print("Showing Keyboard")
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView!.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 15, 0.0)
        
        self.scrollView!.contentInset = contentInsets
        self.scrollView!.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= (keyboardSize!.height + 15)
        if messageField != nil
        {
            if (!CGRectContainsPoint(aRect, messageField!.frame.origin))
            {
                self.scrollView!.scrollRectToVisible(messageField!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -(keyboardSize!.height + 15), 0.0)
        self.scrollView!.contentInset = contentInsets
        self.scrollView!.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView!.scrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        messageField = textField
    }
    
    
}
