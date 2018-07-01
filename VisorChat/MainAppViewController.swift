//
//  MainAppViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/28/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import SwipeableTabBarController

class MainAppViewController: SwipeableTabBarController {
    
    @IBOutlet weak var feedViewController: FeedViewController!
    @IBOutlet weak var peopleFinderViewController: PeopleFinderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        
        //load direct references to the tabs
        if let feed = childController as? FeedViewController {
            self.feedViewController = feed
        } else if let people = childController as? PeopleFinderViewController {
            self.peopleFinderViewController = people
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
