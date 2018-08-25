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
    var accepted : Bool
    
    var dictionary:[String:Any] {
        return [
            "friend": friend,
            "notificationType": type,
            "image": image,
            "accepted" : accepted
        ]
    }
    
    init(_ dictionary: [String:Any]) {
        self.friend = dictionary["friend"] as? String ?? "No Value"
        self.type = NotificationType(rawValue: (dictionary["notificationType"] as? String)!)!
        self.image = dictionary["image"] as? String ?? "No Value"
        self.accepted = dictionary["accepted"] as? Bool ?? false
    }
}

class NotificationViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var TableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationViewCell

        let notification : SpottedNotification
        notification = UserInfo.notifications[indexPath.row]
        cell.notification = notification
        
        return cell
    }
}
