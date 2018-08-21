//
//  ShowImageViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseStorage

class ShowImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var GoUploadImage: UIButton!
    @IBOutlet weak var ReceiveImage: UIButton!
    @IBOutlet weak var AWSImageView: UIImageView!
    @IBOutlet weak var ImageProgress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ImageProgress.progress = 0.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadData() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let starsRef = storageRef.child("images/rivers.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        let downloadTask = starsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/rivers.jpg" is returned
                self.AWSImageView.image = UIImage(data: data!)
            }
        }
        
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
            // Download resumed, also fires when the download starts
        }
        
        downloadTask.observe(.pause) { snapshot in
            // Download paused
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.ImageProgress.progress = Float(percentComplete)
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
        }
    }
    
    @IBAction internal func ReceiveImageAction(_ sender: UIButton) {
        downloadData()
    }
    
    
    @IBAction internal func signOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(vc, animated: true) {}
        }
    }
}

