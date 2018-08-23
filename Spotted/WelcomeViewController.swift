//
//  WelcomeViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class WelcomeViewController : UIViewController {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserInfo.userName = user!.displayName!
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "StartNav") as? UINavigationController {
                self.present(vc, animated: true, completion: nil)
            }
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document("joleek")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    UserInfo.friendos = (document.data()!["friends"] as! [String]).map({
                        Friend(id:0,name:$0)
                    })
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    @IBAction internal func signOut(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        try! authUI?.signOut()
        print("trying to sign out")
        
        let authViewController = authUI?.authViewController()
        
        self.present(authViewController!, animated: true, completion: nil)
    }
}
