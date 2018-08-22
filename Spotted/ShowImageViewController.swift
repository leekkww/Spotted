//
//  ShowImageViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ShowImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ReceiveImage: UIButton!
    @IBOutlet weak var AWSImageView: UIImageView!
    @IBOutlet weak var ImageProgress: UIProgressView!
    @IBOutlet weak var SpottedFriendText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ImageProgress.progress = 0.0
        SpottedFriendText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadImage(_ name1 : String, _ name2 : String, _ count : Int) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let starsRef = storageRef.child("\(name1)/\(name2)/\(count).jpg")
        
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
        let db = Firestore.firestore()
        
        let myName = UserInfo.userName
        let friendName: String = SpottedFriendText.text!
        let docRef = db.collection("photo-data").document("\(myName)-\(friendName)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let count = (document.data()!["count"] as? Int)!
                print("Document data: \(dataDescription)")
                self.downloadImage(myName, friendName, count - 1)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        SpottedFriendText.resignFirstResponder()
        return true;
    }
}

