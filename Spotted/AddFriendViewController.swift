//
//  AddFriendViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddFriendViewController : UIViewController {

    @IBOutlet weak var PendingFriendName: UITextField!
    @IBOutlet weak var AddFriendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func AddFriendButtonAction(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(UserInfo.userName)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var pendingFriends = (document.data()!["pending-friends"] as! [String])
                pendingFriends.append(self.PendingFriendName.text!)
                docRef.setData(["pending-friends": pendingFriends], merge: true)
            } else {
                print("Document does not exist")
            }
        }
    }
}
