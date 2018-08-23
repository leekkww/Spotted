//
//  FriendDetailViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
            
//            if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
//                detailDescriptionLabel.text = detailFriend.name
//                candyImageView.image = UIImage(named: detailCandy.name)
//            }
            let myName = UserInfo.userName
            let friendName: String = detailFriend.name
            
            let db = Firestore.firestore()
            let docRef = db.collection("photo-data").document("\(myName)-\(friendName)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let count = (document.data()!["count"] as? Int)!
                    for i in 0..<count {
                        downloadImage(myName, friendName, i, {
                            (data) -> Void in
                            
                        })
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
            title = friendName
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
