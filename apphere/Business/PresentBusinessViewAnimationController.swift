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
        let cellFrame = businessDetailViewController.view.convert(selectedBusinessCellFrameInWindow, from: nil)
        businessDetailViewController.containerTopConstraint.constant = cellFrame.minY
        businessDetailViewController.containerWidthConstraint.constant = cellFrame.width
        businessDetailViewController.containerHeightConstraint.constant = cellFrame.height
        businessDetailViewController.photoHeightConstraint.constant = cellFrame.height
        businessDetailViewController.container.isScrollEnabled = false
        businessDetailViewController.closeButton.alpha = 0.0
        businessDetailViewController.isStatusBarHidden = false
        businessDetailViewController.view.layoutIfNeeded()
        businessDetailViewController.container.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        businessDetailViewController.view.backgroundColor = .clear
        businessDetailViewController.container.layer.cornerRadius = 14.0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            let businessDetailViewFrame = businessDetailViewController.view.superview!.frame
            PresentBusinessViewAnimationController.configure(businessDetailViewController: businessDetailViewController, frame: businessDetailViewFrame, top: -10.0)
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
    
    static func configure(businessDetailViewController: BusinessDetailViewController, frame: CGRect, top: CGFloat) {
        let cellSize = BusinessCell.size(frame: frame)
        businessDetailViewController.containerTopConstraint.constant = top
        businessDetailViewController.containerWidthConstraint.constant = frame.width
        businessDetailViewController.containerHeightConstraint.constant = frame.height
        businessDetailViewController.photoHeightConstraint.constant = frame.width * (cellSize.height / cellSize.width)
        businessDetailViewController.nameLeadingConstraint.constant = 10.0 + (frame.width - cellSize.width) / 2
        businessDetailViewController.container.isScrollEnabled = true
        businessDetailViewController.closeButton.alpha = 0.7
        businessDetailViewController.container.layer.cornerRadius = 0.0
        businessDetailViewController.view.layoutIfNeeded()
        businessDetailViewController.container.layer.setAffineTransform(.identity)
        businessDetailViewController.view.backgroundColor = .white
        businessDetailViewController.isStatusBarHidden = true
        businessDetailViewController.setNeedsStatusBarAppearanceUpdate()
    }
}
