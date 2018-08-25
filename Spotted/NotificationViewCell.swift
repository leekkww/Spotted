//
//  NotificationViewCell.swift
//  Spotted
//
//  Created by Joanne Lee on 8/24/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

class NotificationViewCell : UITableViewCell {
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NotificationText: UILabel!
    
    var notification: SpottedNotification? {
        didSet {
            guard let notification = notification else { return }
            
            var notifText = ""
            let confirmedVerb = notification.accepted ? "confirmed" : "denied"
            switch notification.type {
            case .FriendRequest:
                    notifText = "\(notification.friend) has sent you a friend request."
            case .FriendRequestResponse:
                    notifText = "\(notification.friend) has \(confirmedVerb) your friend request."
            case .SpotRequest:
                    notifText = "\(notification.friend) has spotted you."
            case .SpotRequestResponse:
                    notifText = "\(notification.friend) has \(confirmedVerb) your spot."
            }
            NotificationText.text = notifText
            
            downloadImage(UserInfo.userName, notification.friend, 0, {
                (data) -> Void in
                self.ProfileImageView.image = UIImage(data: data)
            })
        }
    }
}
