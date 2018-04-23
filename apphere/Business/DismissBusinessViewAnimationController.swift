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
              let businessListNavigationController = tabBarController.viewControllers?.first as? UINavigationController,
              let businessListViewController = businessListNavigationController.topViewController as? BusinessListViewController
        else {
            return
        }

        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        businessDetailViewController.view.backgroundColor = .clear
        BusinessCell.applyShadow(layer: businessDetailViewController.view.layer)
        transitionContext.containerView.insertSubview(tabBarController.view, at: 0)
        businessListViewController.isStatusBarHidden = true
        
        let cell: UICollectionViewCell?
        
        if let indexPath = businessListViewController.activeIndexPath {
            cell = businessListViewController.collectionView!.cellForItem(at: indexPath)
        } else {
            cell = nil
        }
        
        cell?.isHidden = true
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            businessDetailViewController.containerTopConstraint.constant = cellFrame.minY + 10.0
            businessDetailViewController.containerHeightConstraint.constant = cellFrame.height
            businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
            businessDetailViewController.photoHeightConstraint.constant = cellFrame.height
            businessDetailViewController.nameLeadingConstraint.constant = 10.0
            businessDetailViewController.container.isScrollEnabled = false
            businessDetailViewController.view.layoutIfNeeded()
            businessDetailViewController.container.layer.setAffineTransform(.identity)
            businessDetailViewController.closeButton.alpha = 0
            businessDetailViewController.container.layer.cornerRadius = 14.0
            businessListViewController.isStatusBarHidden = false
            businessListViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: [.beginFromCurrentState], animations: {
                businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
                businessDetailViewController.view.layoutIfNeeded()
            },
            completion: { _ in
                cell?.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
}
