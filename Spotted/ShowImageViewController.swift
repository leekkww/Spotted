//
//  ViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class ShowImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var SendImage: UIButton!
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
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
            self.ImageProgress.progress = Float(progress.fractionCompleted)
        })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
                if let error = error {
                    NSLog("Failed with error: \(error)")
//                } else if(self.progressView.progress != 1.0) {
//                    NSLog("Error: Failed - Likely due to invalid region / filename")
                } else{
                    self.AWSImageView.image = UIImage(data: data!)
                }
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "spotted-images",
            key: "_DSC8664.jpg",
            expression: expression,
            completionHandler: completionHandler
            ).continueWith {
                (task) -> AnyObject! in if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with downloadTask.
                    //ImageView.image = UIImage(contentsOfFile: downloadingFileURL.path)
                }
                return nil;
        }
    }
    
    @IBAction internal func ReceiveImageAction(_ sender: UIButton) {
        downloadData()
    }
}

