//
//  ExitViewController.swift
//  apphere
//
//  Created by Tony Mann on 3/19/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit
import Cosmos

class ExitViewController: UIViewController, StatusBarHideable, Pannable {
    var business: Business!
    var isStatusBarHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingView.didTouchCosmos = { [weak self] rating in
            self?.starRatingChanged(rating)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    func starRatingChanged(_ ratingValue: Double) {
        let rating = Database.Rating(
            value: Int(ratingValue),
            date: Date(),
            businessId: String(business.id),
            userId: User.current.id
        )
        
        Database.shared.add(rating: rating) { _, error in
            if let error = error {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.showError(error as NSError)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer?
    @IBOutlet weak var starRatingView: CosmosView!
}
