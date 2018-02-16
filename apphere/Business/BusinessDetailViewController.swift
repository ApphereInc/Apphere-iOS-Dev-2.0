//
//  BusinessDetailViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/7/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController {
    var business: Business!
    
    override func viewDidLoad() {
        photoView.image                 = UIImage(named: business.photo)
        nameLabel.text                  = business.name.uppercased()
        promotionLabel.text             = business.promotion.uppercased()
        activeCustomerCountLabel.text   = String(business.activeCustomerCount)
        dailyCustomerCountLabel.text    = String(business.dailyCustomerCount)
        totalCustomerCountLabel.text    = String(business.totalCustomerCount)
        
        update(label: address1Label,    withText: business.address1)
        update(label: address2Label,    withText: business.address2)
        update(label: cityStateZipLabel,withText: business.cityStateZip)
        update(label: phoneNumberLabel, withText: business.phoneNumber)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func update(label: UILabel, withText text: String?) {
        if let text = text {
            label.text = text
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
    @IBOutlet weak var dailyCustomerCountLabel: UILabel!
    @IBOutlet weak var totalCustomerCountLabel: UILabel!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!

}
