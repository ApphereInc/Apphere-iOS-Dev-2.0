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
            photoView.image                 = UIImage(named: business.photo)
            nameLabel.text                  = business.name.uppercased()
            promotionLabel.text             = business.promotion.uppercased()
            activeCustomerCountLabel.text   = String(business.activeCustomerCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
}
