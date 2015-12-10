//
//  ScaleSegue.swift
//  PamperedPets
//
//  Created by PerryChen on 12/10/15.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

protocol ViewScaleable {
    var scaleView: UIView { get }
}

class ScaleSegue: UIStoryboardSegue {
    override func perform() {
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
}

extension ScaleSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScalePresentAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleDismissAnimator()
    }
}

// present the modal view controller.
class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1. Get the transition context to- controller and view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        if let fromNC = fromViewController as? UINavigationController {
            if let controller = fromNC.topViewController {
                fromViewController = controller
            }
        }
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 2. Add the to- view to the transition context
        if let toView = toView {
            transitionContext.containerView()?.addSubview(toView)
        }
        
        // 3. Set up the initial state for the animation
//        toView?.frame = .zero
        var startFrame = CGRect.zero

        if let fromViewController = fromViewController as? ViewScaleable {
            startFrame = fromViewController.scaleView.frame
        } else {
            print("Warning: Controller \(fromViewController) does not " + "conform to viewscaleable")
        }
        toView?.frame = startFrame
        toView?.layoutIfNeeded()
        
        // 4. Perform the animation 
        let duration = transitionDuration(transitionContext)
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            toView?.frame = finalFrame
//            toView?.layoutIfNeeded()
//            fromView?.alpha = 0.0
//            }) { (finished) -> Void in
//                // 5. Clean up the trasition context
//                fromView?.alpha = 1.0
//                transitionContext.completeTransition(true)
//        }
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            toView?.frame = finalFrame
            toView?.layoutIfNeeded()
            fromView?.alpha = 0.0
            }) { (finished) -> Void in
                // 5. Clean up the trasition context
                fromView?.alpha = 1.0
                transitionContext.completeTransition(true)
        }
        
    }
}

// dismiss the present vc
class ScaleDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        if let toVC = toViewController as? UINavigationController {
            if let controller = toVC.topViewController {
                toViewController = controller
            }
        }
        
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        if let fromView = fromView, toView = toView {
            transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        
        var toFrame = CGRectZero
        if let transitionVC = toViewController as? ViewScaleable {
            toFrame = transitionVC.scaleView.frame
        }
        
        let startFrame = transitionContext.initialFrameForViewController(fromViewController)
        fromView?.frame = startFrame
        fromView?.layoutIfNeeded()
        toView?.alpha = 0.0
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            fromView?.frame = toFrame
            fromView?.layoutIfNeeded()
            toView?.alpha = 1.0
            }) { (finished) -> Void in
                
            transitionContext.completeTransition(true)
        }
        
    }
}
