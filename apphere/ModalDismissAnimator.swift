//
//  ModalDismissAnimator.swift
//  apphere
//
//  Created by Tony Mann on 3/16/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

// http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/

protocol StatusBarHideable: class {
    var isStatusBarHidden: Bool { get set }
}

protocol Pannable: class {
    var panGestureRecognizer: UIPanGestureRecognizer? { get }
}

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
            if let vc = toVC as? StatusBarHideable {
                vc.isStatusBarHidden = false
                toVC.setNeedsStatusBarAppearanceUpdate()
            }
            
            fromVC.view.frame = finalFrame
        },
        completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static var shared = ModalTransitioningDelegate()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let pannable = presented as? Pannable {
            ModalInteractor.shared.panGestureRecognizer = pannable.panGestureRecognizer
        }
        
        ModalInteractor.shared.viewController = presented
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return ModalInteractor.shared.hasStarted ? ModalInteractor.shared : nil
    }
}

class ModalInteractor: UIPercentDrivenInteractiveTransition {
    static var shared = ModalInteractor()
    
    weak var panGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            if let oldPanGestureRecognizer = oldValue {
                oldPanGestureRecognizer.removeTarget(self, action: #selector(panGestureRecognized(_:)))
            }
            
            if let panGestureRecognizer = panGestureRecognizer {
                panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognized(_:)))
            }
        }
    }
    
    weak var viewController: UIViewController?
    var hasStarted = false
    var shouldFinish = false
    
    @objc func panGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        
        guard let viewController = viewController else {
            return
        }
        
        let translation = gesture.translation(in: viewController.view).y
        let progress = min(max(translation / viewController.view.bounds.height, 0.0), 1.0)
        
        switch gesture.state {
        case .began:
            hasStarted = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = (translation > 100.0)
            update(progress)
        case .ended:
            hasStarted = false
            
            if shouldFinish {
                finish()
            } else {
                cancel()
            }
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            break
        }
    }
}
