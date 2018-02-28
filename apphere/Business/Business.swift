//
//  Business.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

typealias ColorHex = String

struct StyledText {
    var text: String
    var isBold: Bool
    var color: ColorHex
}

struct Promotion {
    var title: String
    var backgroundColor: ColorHex?
    var backgroundImage: String?
    var logoImage: String?
    var upperHeadline: StyledText?
    var lowerHeadline: StyledText?
    var featuredImage: String?
    var featuredNotes: StyledText?
}

struct Business {
    enum ContentStyle {
        case light, dark
    }
    
    let id: Int
    let name: String
    let photo: String
    let activeCustomerCount: Int
    let dailyCustomerCount: Int
    let totalCustomerCount: Int
    let address1: String?
    let address2: String?
    let city: String
    let state: String
    let zip: String
    let phoneNumber: String?
    let url: String?
    let contentStyle: ContentStyle
    let hasBeacon: Bool
    let promotion: Promotion
    
    var cityStateZip: String {
        return "\(city), \(state) \(zip)"
    }
    
    var textColor: UIColor {
        switch contentStyle {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
}
