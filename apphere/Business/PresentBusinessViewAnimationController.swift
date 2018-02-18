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
        let businessViewWidth = businessDetailViewController.view.superview!.frame.width
        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
        businessDetailViewController.containerBottomConstraint.constant = businessDetailViewController.view.frame.height - (cellFrame.minY + cellFrame.height)
        businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
        businessDetailViewController.closeButton.alpha = 0.0
        businessDetailViewController.isStatusBarHidden = false
        businessDetailViewController.view.layoutIfNeeded()
        
        businessDetailViewController.view.backgroundColor = .clear
        businessDetailViewController.photoView.layer.cornerRadius = 14.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            businessDetailViewController.containerTopConstraint.constant = 0.0
            businessDetailViewController.containerBottomConstraint.constant = 0.0
            businessDetailViewController.containerWidthConstraint.constant = businessViewWidth
            businessDetailViewController.nameLeadingConstraint.constant = 10.0 + (businessViewWidth - cellFrame.width) / 2
            businessDetailViewController.closeButton.alpha = 0.7
            businessDetailViewController.photoView.layer.cornerRadius = 0.0
            businessDetailViewController.view.layoutIfNeeded()
            businessDetailViewController.isStatusBarHidden = true
            businessDetailViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
