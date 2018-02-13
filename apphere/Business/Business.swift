//
//  Business.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

struct Business {
    let photo: UIImage
    let name: String
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
    
    var cityStateZip: String {
        return "\(city), \(state) \(zip)"
    }
}
