//
//  BusinessListHeaderView.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessListHeaderView: UICollectionReusableView {
    var title: String! {
        didSet {
            label.text = title
        }
    }
    
    @IBOutlet weak var label: UILabel!
}
