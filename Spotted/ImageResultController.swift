//
//  ImageResultController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/25/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

import FirebaseFirestore

class ImageResultController : UIViewController, UITextFieldDelegate {
    
    var takenPhoto: UIImage?
    
    @IBOutlet weak var goBack: UIImageView!
    @IBOutlet weak var imageResult: UIImageView!
    @IBOutlet weak var friendName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addConstraint(NSLayoutConstraint(item: imageResult, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: imageResult, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.75, constant: 0))
        
        if let availableImage = takenPhoto {
            imageResult.image = availableImage
        }
        
        goBack.image = UIImage(named: "ex.jpg")
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageResultController.imageTapped(gesture:)))
        
        // add it to the image view;
        goBack.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        goBack.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.isHidden = true
        
        friendName.delegate = self
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            //Here you can initiate your new ViewController
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        friendName.resignFirstResponder()
        return true
    }

    @IBAction internal func UploadImageAction(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        let myName = UserInfo.userName
        let friendName: String = self.friendName.text!
        let docRef = db.collection("photo-data").document("\(myName)-\(friendName)")
        
        // two friends sending each other images at the same time could get a race condition oops
        
        let timeTaken = Date()
        
        docRef.getDocument { (document, error) in
            var count = 0
            if let document = document, document.exists {
                count = (document.data()!["count"] as? Int)!
            }
            docRef.setData([
                "metadata": FieldValue.arrayUnion([[
                    "id": count,
                    "timestamp": timeTaken,
                    "location": "hack lodge!",
                    "me": true
                    ]]),
                "count": count+1
                ], merge: true)
            let storagePath = imageStoragePath(myName, friendName, count)
            let smallerImage = self.imageResult.image!.jpeg(.lowest)
            uploadData(with: smallerImage!, storagePath: storagePath)

            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let docRefFriend = db.collection("photo-data").document("\(friendName)-\(myName)")
        
        docRefFriend.getDocument { (document, error) in
            var count = 0
            if let document = document, document.exists {
                count = (document.data()!["count"] as? Int)!
            }
            docRefFriend.setData([
                "metadata": FieldValue.arrayUnion([[
                    "id": count,
                    "timestamp": timeTaken,
                    "location": "hack lodge!",
                    "me": false
                    ]]),
                "count": count+1
                ], merge: true)
        }
    }
}
