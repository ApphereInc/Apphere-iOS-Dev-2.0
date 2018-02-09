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
            photoView.image             = business.photo
            nameLabel.text              = business.name.uppercased()
            promotionLabel.text         = business.promotion.uppercased()
            footerLargeTextLabel.text   = String(business.activeCustomerCount)
            footerSmallTextLabel.text   = "HERE NOW"
        }
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var footerLargeTextLabel: UILabel!
    @IBOutlet weak var footerSmallTextLabel: UILabel!
}
