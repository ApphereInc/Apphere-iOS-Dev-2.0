//
//  User.swift
//  
//
//  Created by Tony Mann on 3/27/18.
//

import UIKit

struct User {
    static var current = User(uid: UIDevice.current.identifierForVendor)
    
    var uid: UUID?
    
    var id: String {
        return uid?.uuidString ?? "anonymous"
    }
}
