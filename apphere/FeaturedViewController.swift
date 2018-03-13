//
//  FeaturedViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class FeaturedViewController: PagedViewController {
    override func pageIdentifiers() -> [String] {
        return ["featured1", "featured2"]
    }
}

