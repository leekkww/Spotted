//
//  WelcomeViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseUI

class WelcomeViewController : UIViewController {
    
    @IBAction internal func signOut(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        try! authUI?.signOut()
        print("trying to sign out")
        
        let authViewController = authUI?.authViewController()
        
        UIApplication.topViewController()?.present(authViewController!, animated: true, completion: nil)
    }
}
