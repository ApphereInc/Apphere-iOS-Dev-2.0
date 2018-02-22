//
//  Business.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

struct Business {
    enum TextStyle {
        case light, dark
    }
    
    let name: String
    let photo: String
    let promotion: String
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
    let textStyle: TextStyle
    
    var cityStateZip: String {
        return "\(city), \(state) \(zip)"
    }
    
    var textColor: UIColor {
        switch textStyle {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
}
