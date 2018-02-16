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
        print(cellFrame.height)
        businessDetailViewController.containerTopConstraint.constant = cellFrame.origin.y
        businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
        businessDetailViewController.containerBottomConstraint.constant =  businessDetailView.frame.height - (cellFrame.origin.y + cellFrame.height)
        businessDetailViewController.closeButton.alpha = 0
        businessDetailView.layoutIfNeeded()
        
        businessDetailView.backgroundColor = .clear
        businessDetailViewController.photoView.layer.cornerRadius = 14.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            businessDetailViewController.containerTopConstraint.constant = 0.0
            businessDetailViewController.containerWidthConstraint.constant = businessDetailViewController.view.superview!.frame.width
            businessDetailViewController.containerBottomConstraint.constant = 0.0
            businessDetailViewController.closeButton.alpha = 0.5
            businessDetailView.layoutIfNeeded()
            
            businessDetailView.backgroundColor = .white
            businessDetailViewController.photoView.layer.cornerRadius = 0.0
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
}
