//
//  Models.swift
//  apphere
//
//  Created by Tony Mann on 4/13/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

struct Business: Codable {
    //var id: String!
    //var createDate = Date()
    var activeCustomerCount: Int = 0
    var totalCustomerCount: Int = 0
    var ratingCount: Int = 0
    var ratingTotal: Int = 0
    
    enum CodingKeys: String, CodingKey {
        //case createDate          = "create_date"
        case activeCustomerCount = "active_customer_count"
        case totalCustomerCount  = "total_customer_count"
        case ratingCount         = "rating_count"
        case ratingTotal         = "rating_total"
    }
}

struct Customer: Codable {
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

struct Rating: Codable {
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

struct Day: Codable {
    var customerCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case customerCount = "customer_count"
    }
}

