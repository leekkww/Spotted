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

    @IBOutlet weak var spottedTitle: UILabel!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var settingsIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        spottedTitle.font = UIFont.customFontLarge
        cameraIcon.image = UIImage(named: "spotted.png")
        settingsIcon.image = UIImage(named: "gear.png")

//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().backgroundColor = .clear
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.imageTapped(gesture:)))
        
        // add it to the image view;
        settingsIcon.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        settingsIcon.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        print("settings tapped")
        if (gesture.view as? UIImageView) != nil {
            if let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Settings") as? SettingsViewController {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(settingsVC, animated: true)
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction internal func signOut(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        try! authUI?.signOut()
        print("trying to sign out")
        
        let authViewController = authUI?.authViewController()
        
        UIApplication.topViewController()?.present(authViewController!, animated: true, completion: nil)
    }
}
