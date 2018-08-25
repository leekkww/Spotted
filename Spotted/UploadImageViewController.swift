//
//  UploadImageViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var UploadImage: UIButton!
    @IBOutlet weak var SpottedFriendText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ProgressView.progress = 0.0;
        SpottedFriendText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PhotoLibraryAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    @IBAction func CameraAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    func uploadData(with data: Data, storagePath: String) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child(storagePath)
        
        let metadata = StorageMetadata()
        let uploadTask = riversRef.putData(data, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.ProgressView.progress = Float(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
        }
    }
    
    @IBAction internal func UploadImageAction(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        let myName = UserInfo.userName
        let friendName: String = SpottedFriendText.text!
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
                    "id": count + 1,
                    "timestamp": timeTaken,
                    "location": "hack lodge!",
                    "me": true
                ]]),
                "count": count+1
            ], merge: true)
            let storagePath = imageStoragePath(myName, friendName, count)
            let smallerImage = self.ImageView.image!.jpeg(.lowest)
            self.uploadData(with: smallerImage!, storagePath: storagePath)
        }
        
        let docRefFriend = db.collection("photo-data").document("\(friendName)-\(myName)")
        
        docRefFriend.getDocument { (document, error) in
            var count = 0
            if let document = document, document.exists {
                count = (document.data()!["count"] as? Int)!
            }
            docRefFriend.setData([
                "metadata": FieldValue.arrayUnion([[
                    "id": count + 1,
                    "timestamp": timeTaken,
                    "location": "hack lodge!",
                    "me": false
                ]]),
                "count": count+1
            ], merge: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        SpottedFriendText.resignFirstResponder()
        return true;
    }
}

