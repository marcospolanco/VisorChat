//
//  MainNavigationController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/25/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MainNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.verifyAuthentication()
    }
    
    func verifyAuthentication() {
        if let user = PFUser.current(), user.isAuthenticated {
            //we have an authenticated user, so go straight to the feed
            self.viewControllers = [MainAppViewController.instance]
        } else {
            //we do not, so show them signup screen
            self.viewControllers = [AuthenticationViewController.instance]
        }
    }
}
