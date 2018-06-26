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

        if let _ = PFUser.current() {
            self.viewControllers = [FeedViewController.instance]
        } else {
            self.viewControllers = [SignupViewController.instance]
        }
    }
}
