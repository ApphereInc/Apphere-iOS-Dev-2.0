//
//  Business.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

typealias ColorHex = String
typealias ImageName = String

struct StyledText {
    var text: String
    var color: ColorHex
}

struct Promotion {
    var name: String
    var headline: StyledText
    var footer: StyledText
    var backgroundColor: ColorHex?
    var logo: ImageName?
    var image: ImageName
    var isImageFullSize: Bool
    var url: String?
}

struct Business {
    enum ContentStyle {
        case light, dark
    }
    
    let id: Int
    let name: String
    let photo: ImageName
    let address1: String?
    let address2: String?
    let city: String
    let state: String
    let zip: String
    let phoneNumber: String?
    let url: URL
    let contentStyle: ContentStyle
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
