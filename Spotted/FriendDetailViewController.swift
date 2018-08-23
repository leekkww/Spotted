//
//  FriendDetailViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

class FriendDetailViewController: UIViewController {
    
//    @IBOutlet weak var detailDescriptionLabel: UILabel!
//    @IBOutlet weak var candyImageView: UIImageView!
    
    var detailFriend: Friend? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailFriend = detailFriend {
            title = detailFriend.name
//            if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
//                detailDescriptionLabel.text = detailFriend.name
//                candyImageView.image = UIImage(named: detailCandy.name)
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
