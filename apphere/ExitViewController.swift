//
//  ExitViewController.swift
//  apphere
//
//  Created by Tony Mann on 3/19/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController, StatusBarHideable {
    var business: Business!
    
    var isStatusBarHidden = true
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
