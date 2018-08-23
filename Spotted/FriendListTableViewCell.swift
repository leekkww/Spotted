//
//  FriendListTableViewCell.swift
//  Spotted
//
//  Created by Joanne Lee on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

class FriendListTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var friend: Friend? {
        didSet {
            guard let friend = friend else { return }

            nameLabel.text = friend.name
            downloadImage(UserInfo.userName, friend.name, 0, {
                (data) -> Void in
                self.profileImageView.image = UIImage(data: data)
            })
        }
    }
    
    func image(forRating rating: Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
}
