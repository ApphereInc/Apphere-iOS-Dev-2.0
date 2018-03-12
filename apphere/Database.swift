//
//  Database.swift
//  apphere
//
//  Created by Tony Mann on 3/12/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation
import Firebase

class Database {
    static var shared = Database()
    lazy var db = Firestore.firestore()
    
    struct Event: Codable {
        enum EventType: Int, Codable {
            case enter = 0
            case exit  = 1
        }
        
        let type: EventType
        let date: Date
    }
    
    struct Business: Codable {
        let id: Int
        var activeCustomerCount: Int
        
        enum Fields: String, CodingKey {
            case id = "id"
            case activeCustomerCount = "active_customer_count"
        }
    }
}



