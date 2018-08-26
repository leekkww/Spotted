//
//  SettingsViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/25/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    
    @IBAction func saveSettingsAction(_ sender: Any) {
        logInUser(username: usernameField.text!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func logInUser(username : String) {
        UserInfo.userName = username
        //UIApplication.topViewController()?.present(navStart, animated: true, completion: nil)
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(username)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                UserInfo.friendos = (document.data()!["friends"] as! [String]).map({
                    Friend(id:0,name:$0)
                })
                UserInfo.notifications = (document.data()!["notifications"] as! [[String:Any?]]).map({
                    SpottedNotification($0)
                })
                print(UserInfo.notifications)
            } else {
                docRef.setData([
                    "friends" : [],
                    "notifications" : [],
                ])
            }
        }
    }
}
