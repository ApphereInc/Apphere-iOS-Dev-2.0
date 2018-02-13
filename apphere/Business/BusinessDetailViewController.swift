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
        photoView.image                 = business.photo
        nameLabel.text                  = business.name.uppercased()
        promotionLabel.text             = business.promotion.uppercased()
        activeCustomerCountLabel.text   = String(business.activeCustomerCount)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!

}
