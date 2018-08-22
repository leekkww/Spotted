//
//  AppDelegate.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseFirestore

struct UserInfo {
    static var userName = ""
    static var friendos = [Friend]()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = "528615439077-5k0m74h9788tdm69g044msh40c4qi51p.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
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


        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let _ = user.userID                  // For client-side use only!
            let _ = user.authentication.idToken // Safe to send to the server
            UserInfo.userName = String(user.profile.name)
            let _ = user.profile.givenName
            let _ = user.profile.familyName
            let _ = user.profile.email
            // ...
            print(user.profile.name)
            print(user.authentication.idToken)
            print(user.userID)
            print(GIDSignIn.sharedInstance().currentUser)
            
            // redirect to the right controller
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "StartNav") as? UINavigationController {
                    window?.rootViewController = vc
                }
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    window?.rootViewController = vc
                }
            }
            
            // Load friend data
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

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

