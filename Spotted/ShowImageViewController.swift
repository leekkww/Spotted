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
    
    @IBAction internal func ReceiveImageAction(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        let myName = UserInfo.userName
        let friendName: String = SpottedFriendText.text!
        let docRef = db.collection("photo-data").document("\(myName)-\(friendName)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let count = (document.data()!["count"] as? Int)!
                downloadImage(myName, friendName, count - 1, {
                    (data) -> Void in
                    self.AWSImageView.image = UIImage(data: data)
                })
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

