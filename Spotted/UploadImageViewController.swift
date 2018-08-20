//
//  UploadImageViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var SendImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ProgressView.progress = 0.0;
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
    
    func uploadData(with data: Data) {
        var progressBlock: AWSS3TransferUtilityProgressBlock?
        progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.ProgressView.progress = Float(progress.fractionCompleted)
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                }
                else if(self.ProgressView.progress != 1.0) {
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else{
                }
            })
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(
            data,
            bucket: "spotted-images",
            key: "testImage.jpg",
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                    }
                }
                
                if let _ = task.result {
                    
                    DispatchQueue.main.async {
                        print("Upload Starting!")
                    }
                    
                    // Do something with uploadTask.
                }
                
                return nil;
        }
    }
    
    @IBAction internal func SendImageAction(_ sender: UIButton) {
        uploadData(with: UIImagePNGRepresentation(ImageView.image!)!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
}

