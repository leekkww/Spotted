//
//  NotificationViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

enum NotificationType : String {
    case FriendRequest
    case FriendRequestResponse
    case SpotRequest
    case SpotRequestResponse
}

struct SpottedNotification {
    var friend : String
    var type : NotificationType
    var image : String // only for spot requests
    
    init(_ dictionary: [String:Any]) {
        self.friend = dictionary["friend"] as? String ?? "No Value"
        self.type = NotificationType(rawValue: (dictionary["type"] as? String)!)!
        self.image = dictionary["image"] as? String ?? "No Value"
    }
}

class NotificationViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.notifications.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationViewCell
        
//        let friendo: Friend
//        friendo = UserInfo.friendos[indexPath.row]
//        cell.friend = friendo
        
        return cell
    }
}
