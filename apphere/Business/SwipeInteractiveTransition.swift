//
//  SwipeInteractiveTransition.swift
//  apphere
//
//  Created by Tony Mann on 2/17/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

// Adapted from https://www.raywenderlich.com/170144/custom-uiviewcontroller-transitions-getting-started

import UIKit

class SwipeInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        viewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureRecognized(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress: CGFloat = (translation.y / 200.0)
        progress = CGFloat(min(max(progress, 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

}
