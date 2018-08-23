//
//  FUICustomEmailEntryViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseUI

@objc(FUICustomEmailEntryViewController)

class FUICustomEmailEntryViewController: FUIEmailEntryViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //override action of default 'Next' button to use custom layout elements'
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(onNextButton(_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update state of all UI elements (e g disable 'Next' buttons)
        self.updateEmailValue(emailTextField)
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        self.onBack()
    }
    @IBAction func onNextButton(_ sender: AnyObject) {
        if let email = emailTextField.text {
            self.onNext(email)
        }
    }
    @IBAction func onCancel(_ sender: AnyObject) {
        self.cancelAuthorization()
    }
    
    @IBAction func onViewSelected(_ sender: AnyObject) {
        emailTextField.resignFirstResponder()
    }
    
    @IBAction func updateEmailValue(_ sender: UITextField) {
        if emailTextField == sender, let email = emailTextField.text {
            nextButton.isEnabled = !email.isEmpty
            self.didChangeEmail(email)
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField, let email = textField.text {
            self.onNext(email)
        }
        
        return false
    }
    
}
