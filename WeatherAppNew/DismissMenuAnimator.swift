//
//  DismissMenuAnimator.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/28/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class DismissMenuAnimator: NSObject {
    let duration = 0.6
}
extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                return
        }
        let snapShot = fromVC.view.viewWithTag(MenuHelper.snapshotNumber)
        
        
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            snapShot?.frame = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
            }) { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled()
                if didTransitionComplete {
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    snapShot?.removeFromSuperview()
                }
                transitionContext.completeTransition(didTransitionComplete)
        }
        
    }
}
