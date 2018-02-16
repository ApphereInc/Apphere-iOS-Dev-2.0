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
    var selectedBusinessCellFrame: CGRect = .zero
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let businessDetailViewController = transitionContext.viewController(forKey: .from) as? BusinessDetailViewController,
              let businessDetailView = transitionContext.view(forKey: .from),
              let tabBarView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        //tabBarView.isHidden = true
        transitionContext.containerView.insertSubview(tabBarView, at: 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            businessDetailViewController.view.backgroundColor = .clear
            businessDetailViewController.containerTopConstraint.constant =  self.selectedBusinessCellFrame.minY
            businessDetailViewController.containerWidthConstraint.constant = self.selectedBusinessCellFrame.width
            businessDetailView.layoutIfNeeded()
            
            businessDetailViewController.photoView.layer.cornerRadius = 14.0
        }, completion: { (_) in
            //tabBarView.isHidden = false
            //businessDetailView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
}
