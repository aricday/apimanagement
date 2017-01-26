//
//  MessagesMain.swift
//  CA Presales Pro
//
//  Created by Mike Moore on 2/28/16.
//  Copyright © 2016 CA. All rights reserved.
//

import UIKit

class MessagesMain: BaseDemo, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    var users: [MASUser] = []
    var user: MASUser? = nil

    // Unwind Function
    @IBAction func unwindToUserList(segue:UIStoryboardSegue)
    {
        // ** nothing to do now
    }
    
    override var backButton: String? {
        return "Groups"
    }
    
    override var demoTitle: String {
        return "Messsaging"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "GroupMemberTableCell", bundle: nil)
        self.tableView!.registerNib(nib, forCellReuseIdentifier: "GroupMemberTableCell")
        self.tableView!.rowHeight = 60
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
//        MASUser.getAllUsersSortedByAttribute("", sortOrder: MASFilteredRequestSortOrder.Ascending, pageRange: NSMakeRange(0, 100), includedAttributes: [], excludedAttributes: []) { (users:[AnyObject]!, error: NSError!, count: UInt) in
//            self.users = users as! [MASUser]
//            self.tableView?.reloadData()
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:GroupMemberTableCell = self.tableView!.dequeueReusableCellWithIdentifier("GroupMemberTableCell") as! GroupMemberTableCell
        
        let user = self.users[indexPath.row]
        cell.loadItem(user.formattedName, username: user.userName)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        // Perform segue to group controller
        self.user = self.users[indexPath.row]
        self.performSegueWithIdentifier("chatWithUser", sender: tableView.cellForRowAtIndexPath(indexPath))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "chatWithUser")
        {
            let vc = segue.destinationViewController as! MessagesUserToUser
            vc.user = self.user
            print(vc.user)
            
        }
    }
}
