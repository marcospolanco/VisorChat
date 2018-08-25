//
//  CameraViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/30/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController {
    @IBOutlet weak var shotBtn: SwiftyCamButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shotBtn.delegate = self
    }
}
