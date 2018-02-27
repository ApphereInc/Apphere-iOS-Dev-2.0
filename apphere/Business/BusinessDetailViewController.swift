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
        promotionLabel.text             = business.promotionName.uppercased()
        activeCustomerCountLabel.text   = String(business.activeCustomerCount)
        dailyCustomerCountLabel.text    = String(business.dailyCustomerCount)
        totalCustomerCountLabel.text    = String(business.totalCustomerCount)
        
        nameLabel.textColor = business.textColor
        promotionLabel.textColor = business.textColor
        
        update(label: address1Label,    withText: business.address1)
        update(label: address2Label,    withText: business.address2)
        update(label: cityStateZipLabel,withText: business.cityStateZip)
        update(label: phoneNumberLabel, withText: business.phoneNumber)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
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
    
    private var swipeAnimator: UIViewPropertyAnimator?
    
    private func update(label: UILabel, withText text: String?) {
        if let text = text {
            label.text = text
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var closeButton: UIButton!
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
    @IBOutlet weak var nameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
}
