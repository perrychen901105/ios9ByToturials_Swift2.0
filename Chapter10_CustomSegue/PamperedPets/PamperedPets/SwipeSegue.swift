//
//  SwipeSegue.swift
//  PamperedPets
//
//  Created by PerryChen on 12/10/15.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

protocol ViewSwipeable {
    var swipeDirection: UISwipeGestureRecognizerDirection { get }
}

class SwipeSegue: UIStoryboardSegue {
    override func perform() {
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
}

extension SwipeSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeDismissAnimator()
    }
}

class SwipeDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        if let fromNC = fromViewController as? UINavigationController {
            if let controller = fromNC.topViewController {
                fromViewController = controller
            }
        }
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    
        if let fromView = fromView, toView = toView {
            transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        
        var startFrame = transitionContext.initialFrameForViewController(fromViewController)
        var endFrame = transitionContext.finalFrameForViewController(toViewController)
        startFrame.origin.x = endFrame.width/2 - startFrame.width/2
        if let transitionVC = fromViewController as? ViewSwipeable {
            let direction = transitionVC.swipeDirection
            switch direction {
                case UISwipeGestureRecognizerDirection.Up:
                    endFrame.origin.y = -startFrame.height
                case UISwipeGestureRecognizerDirection.Down:
                    endFrame.origin.y = startFrame.size.height
                default:()
            }
        }
        
        fromView?.frame = startFrame
        fromView?.layoutIfNeeded()
        
        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            fromView?.frame = endFrame
            fromView?.layoutIfNeeded()
            }) { (finished) -> Void in
                
                transitionContext.completeTransition(true)
        }
        
    }
}
