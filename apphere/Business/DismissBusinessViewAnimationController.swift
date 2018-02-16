//
//  DismissBusinessViewAnimationController.swift
//  apphere
//
//  Created by Tony Mann on 2/9/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

// Adapted from https://github.com/phillfarrugia/appstore-clone

class DismissBusinessViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var selectedBusinessCellFrameInWindow: CGRect = .zero
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let businessDetailViewController = transitionContext.viewController(forKey: .from) as? BusinessDetailViewController,
              let businessDetailView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        transitionContext.containerView.insertSubview(toView, at: 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
            businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
            businessDetailView.layoutIfNeeded()
            
            businessDetailView.backgroundColor = .clear
            businessDetailViewController.photoView.layer.cornerRadius = 14.0
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
}
