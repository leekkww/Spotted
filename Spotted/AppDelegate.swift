//
//  AppDelegate.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseUI

struct UserInfo {
    static var userName = ""
    static var friendos = [Friend]()
    static var notifications = [SpottedNotification]()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {
    
    var navStart = UINavigationController()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UISearchBar.appearance().tintColor = .spottedOrange
        UINavigationBar.appearance().tintColor = .spottedOrange
        UIButton.appearance().tintColor = .spottedOrange
        
        // font setting
//        label.font = UIFontMetrics.default.scaledFont(for: customFont)
//        label.adjustsFontForContentSizeCategory = true
        
        UILabel.appearance().font = UIFont.customFont
        UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).font = UIFont.customFont
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = false
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // With this change, timestamps stored in Cloud Firestore will be read back as Firebase Timestamp objects instead of as system Date objects. So you will also need to update code expecting a Date to instead expect a Timestamp. For example:
        
        // old:
//        let date: Date = documentSnapshot.get("created_at") as! Date
//        // new:
//        let timestamp: Timestamp = documentSnapshot.get("created_at") as! Timestamp
//        let date: Date = timestamp.dateValue()
//
//        Please audit all existing usages of Date when you enable the new behavior. In a future release, the behavior will be changed to the new behavior, so if you do not follow these steps, YOUR APP MAY BREAK.
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "StartNav") as? UINavigationController {
            navStart = vc
        }
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        let authViewController = authUI?.authViewController()
        
        window?.rootViewController = authViewController
        
        logInUser(username: "joleek")
        return true
    }
    
    func logInUser(username : String) {
        window?.rootViewController = navStart
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
                print("Document does not exist")
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        print("TEST: trying to log in?")
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            logInUser(username: user!.displayName!)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

