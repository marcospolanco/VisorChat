//
//  SignupViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/25/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import SwiftValidator
import SwiftSpinner

class SignupViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var fields = [UITextField]()
    let validator = Validator()
    
    override func viewDidLoad(){
        super.viewDidLoad()
    
        self.fields = [emailField, passwordField]
        emailField.becomeFirstResponder()
        
    }
    
    @IBAction func submit(_ sender: Any){
        self.validationSuccessful() //        validator.validate(self)
    }
}


extension SignupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard var index = self.fields.index(of: textField) else {return print("\(textField) is not handled")}
        
        //choose whether to increment or go back to the beginning
        if index >= self.fields.count {
            index = 0
        } else {
            index += 1
        }
        
        //choose that field to receive input
        self.fields[index].becomeFirstResponder()
    }
}

extension SignupViewController: ValidationDelegate {
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    }
    
    private func create(email: String, password: String, completion: BoolHandler? = nil){
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user.signUpInBackground {success, error in
            if let error = error {print(error.localizedDescription)}
            completion?(success)
        }
    }
    
    @objc func validationSuccessful() {
        SwiftSpinner.show("Creating")
        //check whether there are an
        
        guard let email = emailField.text, let password = passwordField.text else {
            SwiftSpinner.hide()
            return print("nil field valies")
        }
        self.create(email: email, password:password){[weak self] success in
            SwiftSpinner.hide()
            
            guard let _self = self else {return print("SignupViewController.deallocated")}
            AppDelegate.rootViewController?.verifyAuthentication()
        }
    }
}
