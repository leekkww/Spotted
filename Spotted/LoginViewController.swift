//
//  LoginViewController.swift
//  Spotted
//
//  Created by Stef Ren on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }

    

}
