//
//  BusinessDetailViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/7/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController, StatusBarHideable {
    var business: Business!
    var customerCounts: Database.CustomerCounts?
    
    override func viewDidLoad() {
        photoView.image                 = UIImage(named: business.photo)
        nameLabel.text                  = business.name.uppercased()
        promotionLabel.text             = business.promotion.name.uppercased()

        nameLabel.textColor = business.textColor
        promotionLabel.textColor = business.textColor
        urlButton.setTitle(business.url.host, for: .normal)
        
        update(label: activeCustomerCountLabel, withCount: customerCounts?.active)
        update(label: dailyCustomerCountLabel,  withCount: customerCounts?.daily)
        update(label: totalCustomerCountLabel,  withCount: customerCounts?.total)
        update(label: phoneNumberLabel,         withText: business.phoneNumber)
        update(label: descriptionLabel,         withText: business.description)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        Database.shared.getCustomerCounts(businessId: String(business.id)) { customerCounts, error in
            DispatchQueue.main.async {
                if let error = error {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showError(error as NSError)
                }
                
                self.activeCustomerCountLabel.text   = String(customerCounts!.active)
                self.dailyCustomerCountLabel.text    = String(customerCounts!.daily)
                self.totalCustomerCountLabel.text    = String(customerCounts!.total)
            }
        }
    }
    
    var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    @objc func panGestureRecognized(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress: CGFloat = (translation.y / 200.0)
        progress = CGFloat(min(max(progress, 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            swipeAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
                self.view.layer.setAffineTransform(CGAffineTransform(scaleX: 0.8, y: 0.8))
                self.view.layer.cornerRadius = 14.0
                self.view.layer.masksToBounds = true
                self.closeButton.alpha = 0.0
            }
        case .changed:
            swipeAnimator?.fractionComplete = progress
            
            if progress == 1.0 {
                swipeAnimator?.stopAnimation(true)
                swipeAnimator = nil
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            swipeAnimator?.isReversed = true
            swipeAnimator?.startAnimation()
            swipeAnimator = nil
        case .ended:
            swipeAnimator?.isReversed = true
            swipeAnimator?.startAnimation()
            swipeAnimator = nil
        default:
            break
        }
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func urlButtonTapped() {
        UIApplication.shared.open(business.url, options: [:], completionHandler: nil)
    }
    
    private var swipeAnimator: UIViewPropertyAnimator?
    
    private func update(label: UILabel, withText text: String?) {
        if let text = text {
            label.text = text
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    private func update(label: UILabel, withCount count: Int?) {
        label.text = count.map(String.init) ?? "-"
    }
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
    @IBOutlet weak var dailyCustomerCountLabel: UILabel!
    @IBOutlet weak var totalCustomerCountLabel: UILabel!
    @IBOutlet weak var nameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
}
