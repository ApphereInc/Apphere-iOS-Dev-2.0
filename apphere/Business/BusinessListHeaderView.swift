//
//  BusinessListHeaderView.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessListHeaderView: UICollectionReusableView {
    var date: Date! {
        didSet {
            label.text = BusinessListHeaderView.dateFormatter.string(from: date).uppercased()
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter
    }()
}
