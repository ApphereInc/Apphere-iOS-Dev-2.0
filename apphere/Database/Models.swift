//
//  Models.swift
//  apphere
//
//  Created by Tony Mann on 4/13/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

protocol FirestoreCodable: Codable {
    mutating func setDocumentId(_ documentId: String)
}

struct Business: FirestoreCodable {
    var id: String!
    var activeCustomerCount: Int = 0
    var totalCustomerCount: Int = 0
    var ratingCount: Int = 0
    var ratingTotal: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case activeCustomerCount = "active_customer_count"
        case totalCustomerCount  = "total_customer_count"
        case ratingCount         = "rating_count"
        case ratingTotal         = "rating_total"
    }
    
    mutating func setDocumentId(_ documentId: String) {
        id = documentId
    }
}

struct Customer: FirestoreCodable {
    let userId: String
    let businessId: String
    let enterDate: Date
    var exitDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case userId     = "user_id"
        case businessId = "business_id"
        case enterDate  = "enter_date"
        case exitDate   = "exit_date"
    }
}

struct Rating: FirestoreCodable {
    let value: Int
    let date: Date
    let businessId: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case value      = "value"
        case date       = "date"
        case businessId = "business_id"
        case userId     = "user_id"
    }
}

struct Day: FirestoreCodable {
    var customerCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case customerCount = "customer_count"
    }
}

extension FirestoreCodable {
    func setDocumentId(_ documentId: String) {}
}


