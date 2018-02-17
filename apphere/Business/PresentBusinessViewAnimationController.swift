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
        guard let businessDetailViewController = transitionContext.viewController(forKey: .to) as? BusinessDetailViewController,
              let businessDetailView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        transitionContext.containerView.addSubview(businessDetailView)

        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
        businessDetailViewController.containerBottomConstraint.constant = businessDetailView.frame.height - (cellFrame.origin.y + cellFrame.height)
        businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
        businessDetailViewController.closeButton.alpha = 0.0
        businessDetailViewController.isStatusBarHidden = false
        businessDetailView.layoutIfNeeded()
        
        businessDetailView.backgroundColor = .clear
        businessDetailViewController.photoView.layer.cornerRadius = 14.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            businessDetailViewController.containerTopConstraint.constant = 0.0
            businessDetailViewController.containerBottomConstraint.constant = 0.0
            businessDetailViewController.containerWidthConstraint.constant = businessDetailViewController.view.superview!.frame.width
            businessDetailViewController.closeButton.alpha = 0.7
            businessDetailView.backgroundColor = .white
            businessDetailViewController.photoView.layer.cornerRadius = 0.0
            businessDetailView.layoutIfNeeded()
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
