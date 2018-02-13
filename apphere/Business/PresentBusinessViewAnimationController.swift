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
    var selectedBusinessCellFrame: CGRect = .zero
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let businessDetailViewController = transitionContext.viewController(forKey: .to) as? BusinessDetailViewController,
              let businessDetailView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        transitionContext.containerView.addSubview(businessDetailView)
//        businessDetailViewController.positionContainer(left: 20.0,
//                                           right: 20.0,
//                                           top: selectedBusinessCellFrame.origin.y + 20.0,
//                                           bottom: 0.0)
//        businessDetailViewController.setHeaderHeight(selectedBusinessCellFrame.size.height - 40.0)
//        businessDetailViewController.configureRoundedCorners(shouldRound: true)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            businessDetailViewController.positionContainer(left: 0.0,
//                                               right: 0.0,
//                                               top: 0.0,
//                                               bottom: 0.0)
//            businessDetailViewController.setHeaderHeight(500)
//            businessDetailViewController.view.backgroundColor = .white
//            businessDetailViewController.configureRoundedCorners(shouldRound: false)
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
}
