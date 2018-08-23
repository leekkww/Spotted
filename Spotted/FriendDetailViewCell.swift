//
//  FriendDetailViewCell.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

class FriendDetailViewCell : UITableViewCell {
    @IBOutlet weak var SpotImageView: UIImageView!

    var friendImage: FriendImage? {
        didSet {
            guard let friendImage = friendImage else { return }
            
            downloadImage(UserInfo.userName, friendImage.name, friendImage.id, {
                (data) -> Void in
                self.SpotImageView.image = UIImage(data: data)
            })
        }
    }
}
