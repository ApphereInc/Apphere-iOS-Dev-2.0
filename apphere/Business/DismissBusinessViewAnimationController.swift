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
              let tabBarController = transitionContext.viewController(forKey: .to) as? UITabBarController,
              let businessListViewController = tabBarController.viewControllers?.first as? BusinessListViewController
        else {
            return
        }
        
        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        transitionContext.containerView.insertSubview(tabBarController.view, at: 0)
        businessDetailViewController.view.backgroundColor = UIColor.clear
        businessListViewController.isStatusBarHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
            businessDetailViewController.containerBottomConstraint.constant = businessDetailViewController.view.frame.height - (cellFrame.minY + cellFrame.height)
            businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
            businessDetailViewController.closeButton.alpha = 0
            businessDetailViewController.photoView.layer.cornerRadius = 14.0
            businessDetailViewController.view.layoutIfNeeded()
            businessListViewController.isStatusBarHidden = false
            businessListViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
}
