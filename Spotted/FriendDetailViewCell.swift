//
//  FriendDetailViewCell.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

class FriendDetailViewCell : UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var SpotImageView: UIImageView!
    @IBOutlet weak var metadataLabel: UIStackView!
    @IBOutlet weak var circle: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(false) {
            self.addConstraint(NSLayoutConstraint(item: SpotImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.5, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: metadataLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.5, constant: 0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: SpotImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.5, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: metadataLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.5, constant: 0))
        }

        self.circle.setRounded()
    }
    
    var friendImage: FriendImage? {
        didSet {
            guard let friendImage = friendImage else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            dateLabel.text = formatter.string(from: friendImage.timestamp)
            locationLabel.text = friendImage.location
            
            downloadImage(UserInfo.userName, friendImage.name, friendImage.id, {
                (data) -> Void in
                self.SpotImageView.image = UIImage(data: data)
            })
            
            setNeedsLayout()
        }
    }
}
