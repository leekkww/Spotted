//
//  UploadImageViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/19/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

import AVFoundation
import FirebaseFirestore
import FirebaseStorage

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var uploadTitle: UILabel!
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var takePictureButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadTitle.font = UIFont.customFontLarge
        
        takePictureButton.image = UIImage(named: "circle.png")
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UploadImageViewController.imageTapped(gesture:)))
        
        // add it to the image view;
        takePictureButton.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        takePictureButton.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            //Here you can initiate your new ViewController
            takePhoto = true
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("loading image")
        loadDetailImageView(info[UIImagePickerControllerOriginalImage] as! UIImage)
    }
    
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        captureDevice = availableDevices.first
        beginSession()
    }
    
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
            
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "hls18-Spotted.captureQueue")
        dataOutput.setSampleBufferDelegate(self as AVCaptureVideoDataOutputSampleBufferDelegate, queue: queue)
    }

    func loadDetailImageView(_ detailImage: UIImage) {
        if let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoResult") as? ImageResultController {
            photoVC.takenPhoto = detailImage
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(photoVC, animated: true)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                self.stopCaptureSession()
                loadDetailImageView(image)
            }
        }
    }
    
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
}

