//
//  BusinessViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/7/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController {
    var business: Business!
    
    override func viewDidLoad() {
        navigationItem.title = business.name.capitalized
        nameLabel.text = business.promotion.capitalized
    }
    
    @IBOutlet weak var nameLabel: UILabel!
}
