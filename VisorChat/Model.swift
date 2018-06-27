//
//  Model.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/27/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import Parse

extension PFUser {
    
    enum Fields: String {
        case fullname = "fullname"
    }
    
    var fullname: String? {
        return self.value(forKey: Fields.fullname.rawValue) as? String
    }
}

class Post: PFObject {
    @NSManaged var source:      PFUser?
    @NSManaged var target:      PFUser?
    @NSManaged var content:     String?
    
    enum Fields: String {
        case source = "source"
        case target = "target"
        case content = "content"
    }
}

class Database {
    
    static var shared = Database()
    
    //cache of user information
    var users = [String: PFUser]()
    var posts = [String: Post]()
    var lastLoad: Date?
}

extension PFObject: PFSubclassing {
    public static func parseClassName() -> String {
        return "\(self)"
    }
}
