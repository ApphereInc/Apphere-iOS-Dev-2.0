//
//  CategoryCell.swift
//  apphere
//
//  Created by Tony Mann on 4/19/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CategoryCell: UICollectionViewCell {
    var category: Category! {
        didSet {
            titleLabel.text = category.title
            contentView.backgroundColor = UIColor(category.color)
        }
    }
    
    static let size = CGSize(width: 100.0, height: 90.0)
    
    @IBOutlet weak var titleLabel: UILabel!
}
