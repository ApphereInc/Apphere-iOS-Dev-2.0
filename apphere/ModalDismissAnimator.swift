//
//  ModalDismissAnimator.swift
//  apphere
//
//  Created by Tony Mann on 3/16/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

// http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/

class ModalDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
        animations: {
            fromVC.view.frame = finalFrame
        },
        completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static var shared = ModalTransitioningDelegate()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("ModalInteractor.shared.hasStarted=", ModalInteractor.shared.hasStarted)
        return ModalInteractor.shared.hasStarted ? ModalInteractor.shared : nil
    }
}

class ModalInteractor: UIPercentDrivenInteractiveTransition {
    static var shared = ModalInteractor()
    
    var hasStarted = false
    var shouldFinish = false
}
