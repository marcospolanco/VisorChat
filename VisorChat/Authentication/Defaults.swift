//
//  Defaults.swift
//  VisorChat
//
//  Created by Marcos Polanco on 7/3/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation

enum Defaults: String {
    
    case email = "email"
    case password = "password"
    
    func save(_ value: String){
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    var int: Int? {
        return UserDefaults.standard.object(forKey: self.rawValue) as? Int
    }
    var string: String? {
        return UserDefaults.standard.object(forKey: self.rawValue) as? String
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
}
