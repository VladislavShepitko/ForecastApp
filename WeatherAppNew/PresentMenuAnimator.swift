//
//  PresentMenuAnimator.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/28/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class PresentMenuAnimator: NSObject {
    let duration = 0.6
}
extension PresentMenuAnimator : UIViewControllerAnimatedTransitioning {
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
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let snapShot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapShot.tag = MenuHelper.snapshotNumber
        snapShot.userInteractionEnabled = false
        snapShot.layer.shadowOpacity = 0.7
        snapShot.backgroundColor = UIColor.redColor()
        containerView.insertSubview(snapShot, aboveSubview: toVC.view)
        fromVC.view.hidden = true
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            snapShot.center.x += UIScreen.mainScreen().bounds.width * MenuHelper.menuWidth
            }) { _ in
            fromVC.view.hidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
}
