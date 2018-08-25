//
//  LoginViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/27/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import SwiftSpinner

class LoginViewController: SignupViewController {
    
    @IBAction func forgot(_ sender: Any){}

    override func validationSuccessful() {
        SwiftSpinner.show("Entering")
        //check whether there are an
        
        guard let email = emailField.text, let password = passwordField.text else {
            SwiftSpinner.hide()
            return print("nil field valies")
        }
        
        PFUser.logInWithUsername(inBackground: email, password: password) {user, error in
            SwiftSpinner.hide()
            guard let _ = user else {return print("error: \(error?.localizedDescription ?? "<nil error>")")}
            
            //save the authentication information
            Defaults.email.save(email)
            Defaults.password.save(password)
            
            AppDelegate.rootViewController?.verifyAuthentication()
        }
    }
}
