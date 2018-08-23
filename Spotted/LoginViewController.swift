//
//  LoginViewController.swift
//  Spotted
//
//  Created by Stef Ren on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        let authViewController = authUI?.authViewController()

        self.present(authViewController!, animated: true, completion: nil)
    }
}
