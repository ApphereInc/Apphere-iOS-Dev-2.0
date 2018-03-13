//
//  InfoViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class InfoViewController: PagedViewController {
    override func pageIdentifiers() -> [String] {
        return ["info1", "info2", "info3", "info4"]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


