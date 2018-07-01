//
//  VisorMessageInputView.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/30/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import MessengerKit

class VisorMessageInputView: MSGImessageInputView {
    
    @IBOutlet weak var mediaTapper: UIImageView! //https://www.freeiconspng.com/img/23492
    
    override open class var nib: UINib? {
        return UINib(nibName: "VisorMessageInputView",
                     bundle: Bundle.main)
    }
}
