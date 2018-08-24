//
//  LoginViewController.swift
//  Spotted
//
//  Created by Stef Ren on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

import FirebaseFirestore
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        let authViewController = authUI?.authViewController()

        UIApplication.topViewController()?.present(authViewController!, animated: false, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserInfo.userName = user!.displayName!
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "StartNav") as? UINavigationController {
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
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
}
