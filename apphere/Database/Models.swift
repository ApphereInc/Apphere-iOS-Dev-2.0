//
//  Models.swift
//  apphere
//
//  Created by Tony Mann on 4/13/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

typealias ColorHex = String

protocol FirestoreCodable: Codable {
    mutating func setDocumentId(_ documentId: String)
}

struct Business: FirestoreCodable {
    var id: String!
    let name: String
    let description: String
    let imageUrl: URL?
    let webPageUrl: URL?
    let address: String?
    let city: String
    let state: String
    let zip: String
    let phoneNumber: String?
    let webcamId: String?
    var promotion: Promotion?
    var customerStats = CustomerStats()
    var ratingStats = RatingStats()
    
    enum CodingKeys: String, CodingKey {
        case name                = "name"
        case description         = "description"
        case imageUrl            = "image_url"
        case address             = "address"
        case city                = "city"
        case state               = "state"
        case zip                 = "zip"
        case phoneNumber         = "phone_number"
        case webPageUrl          = "web_page_url"
        case webcamId            = "webcam_id"
        case promotion           = "promotion"
        case customerStats       = "customer_stats"
        case ratingStats         = "rating_stats"
    }
    
    mutating func setDocumentId(_ documentId: String) {
        id = documentId
    }
    
    var cityStateZip: String {
        return "\(city), \(state) \(zip)"
    }
}

struct Promotion: FirestoreCodable {
    var name: String
    var description: String
    var footer: String
    var descriptionColor: ColorHex?
    var footerColor: ColorHex?
    var backgroundColor: ColorHex?
    var imageUrl: URL
    var logoUrl: URL?
    var webPageUrl: URL?
    var isImageFullSize: Bool
}

struct CustomerStats: FirestoreCodable {
    var active: Int = 0
    var total: Int = 0
}

struct RatingStats: FirestoreCodable {
    var count: Int = 0
    var total: Int = 0
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


