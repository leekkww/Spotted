//
//  WelcomeViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeViewController : UIViewController {
    
    @IBAction internal func signOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(vc, animated: true) {}
        }
    }
}
