//
//  BusinessCell.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessCell: UICollectionViewCell {
    var business: Business! {
        didSet {
            photoView.image                 = business.photo
            nameLabel.text                  = business.name.uppercased()
            promotionLabel.text             = business.promotion.uppercased()
            activeCustomerCountLabel.text   = String(business.activeCustomerCount)
        }
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
}
