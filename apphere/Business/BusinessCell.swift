//
//  BusinessCell.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit
import Cosmos

class BusinessCell: UICollectionViewCell {
    var business: Business! {
        didSet {
            photoView.image                 = UIImage(named: business.photo)
            nameLabel.text                  = business.name.uppercased()
            promotionLabel.text             = business.promotion.name.uppercased()
            activeCustomerCountLabel.text   = "-"
           
            nameLabel.textColor = business.textColor
            promotionLabel.textColor = business.textColor
            
            Database.shared.getCustomerCounts(businessId: String(business.id)) { customerCounts, error in
                DispatchQueue.main.async {
                    self.customerCounts = customerCounts
                    
                    if let error = error {
                        self.showError(error)
                    }
                    
                    self.activeCustomerCountLabel.text  = String(customerCounts!.active)
                }
            }
            
            Database.shared.getRating(businessId: String(business.id)) { rating, error in
                DispatchQueue.main.async {
                    self.rating = rating
                    
                    if let error = error {
                        self.showError(error)
                    }
                    
                    self.starRatingView.rating = Double(rating!)
                }
            }
        }
    }
    
    var customerCounts: Database.CustomerCounts?
    var rating: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = 14.0
        contentView.layer.masksToBounds = true
        BusinessCell.applyShadow(layer: layer)
    }
    
    static func applyShadow(layer: CALayer) {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    private func showError(_ error: Error) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showError(error as NSError)
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
}
