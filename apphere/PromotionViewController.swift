//
//  PromotionViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/26/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController {
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text      = business.name.uppercased()
        promotionLabel.text = business.promotion.uppercased()
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
}
