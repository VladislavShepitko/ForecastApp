//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@objc class CBMenuLinearAnimator: NSObject {
    //MARK:- parameters for linear placement of segments
    let yOffset:CGFloat = 40.0
    var curOffset:CGPoint = CGPointZero
    
    
}
//MARK:- delegate implementation

@available(iOS 9.0, *)
extension CBMenuLinearAnimator : CBMenuAnimatorDelegate {
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        //let direction:CGFloat = indexPath.item % 2 == 0 ? 1 : -1
        //curOffset = direction > 0 ? CGPointMake(curOffset.x + xOffset, 0) : curOffset
        curOffset = CGPoint(x: curOffset.x, y: curOffset.x + yOffset)
        return menu.origin + curOffset
    }
    func showBackground(menu: CBMenu, background: UIView, params:NSDictionary?) {
        var delay = 0.0
        if let data = params?.objectForKey("delay"){
            delay = data as! Double
        }
        UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            background.frame = menu.bounds
        }, completion: nil)
    }
    func hideBackground(menu: CBMenu, background: UIView, params:NSDictionary?) {
        var delay = 0.0
        if let data = params?.objectForKey("delay"){
            delay = data as! Double
        }
        UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            background.frame = CGRectMake(menu.halfSize.width, 0, 0, menu.bounds.height)
            }, completion: nil)        
    }
    
    

}
