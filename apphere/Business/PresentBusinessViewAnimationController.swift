//
//  PresentBusinessViewAnimationController.swift
//  apphere
//
//  Created by Tony Mann on 2/9/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

// Adapted from https://github.com/phillfarrugia/appstore-clone

class PresentBusinessViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var selectedBusinessCellFrameInWindow: CGRect = .zero
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let businessDetailViewController = transitionContext.viewController(forKey: .to) as? BusinessDetailViewController
        else {
            return
        }
        
        transitionContext.containerView.addSubview(businessDetailViewController.view)
        let businessDetailViewFrame = businessDetailViewController.view.superview!.frame
        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
        businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
        businessDetailViewController.containerHeightConstraint.constant = cellFrame.height
        businessDetailViewController.closeButton.alpha = 0.0
        businessDetailViewController.isStatusBarHidden = false
        businessDetailViewController.view.layoutIfNeeded()
        businessDetailViewController.container.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        businessDetailViewController.view.backgroundColor = .clear
        businessDetailViewController.container.layer.cornerRadius = 14.0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            businessDetailViewController.containerTopConstraint.constant = -10.0
            businessDetailViewController.containerWidthConstraint.constant = businessDetailViewFrame.width
            businessDetailViewController.containerHeightConstraint.constant = businessDetailViewFrame.height
            businessDetailViewController.nameLeadingConstraint.constant = 10.0 + (businessDetailViewFrame.width - cellFrame.width) / 2
            businessDetailViewController.closeButton.alpha = 0.7
            businessDetailViewController.container.layer.cornerRadius = 0.0
            businessDetailViewController.view.layoutIfNeeded()
            businessDetailViewController.container.layer.transform = CATransform3DIdentity
            businessDetailViewController.isStatusBarHidden = true
            businessDetailViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: [.beginFromCurrentState], animations: {
                businessDetailViewController.containerTopConstraint.constant = 0.0
                businessDetailViewController.view.layoutIfNeeded()
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
}
