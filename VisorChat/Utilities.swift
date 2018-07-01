//
//  Utilities.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/27/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit

typealias VoidHandler = ()->()
typealias BoolHandler = (Bool)->()

/*  Loads and returns a view controller in the given storyboard and storyboard identifier.
 */


extension UIViewController {
    static var instance: UIViewController! { //we want to crash hard if we cannot create the view controller
        let sb = UIStoryboard(name: "\(self)", bundle: Bundle.main)
        let vc = sb.instantiateInitialViewController()
        let _ = vc?.view //force the loading of the views
        return vc
    }
}

/*  Extension so an image can be tapped like a button to invoke a selector
 */
extension UIView {
    func onTap(target: AnyObject, selector: Selector) {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: target, action: selector)
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
}
