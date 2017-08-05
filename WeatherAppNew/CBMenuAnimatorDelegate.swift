//
//  CBMenuAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@objc protocol CBMenuAnimatorDelegate {
    
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint
        
    optional func willShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func willHideSegment(menu:CBMenu,at indexPath:NSIndexPath, segment: CBMenuItem)
    
    optional func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem, params:NSDictionary?)
    optional func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem, params:NSDictionary?)
    
    
    optional func didShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func didHideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    
    optional func allAnimationsDidFinishWhenHide(menu:CBMenu)
    optional func allAnimationsDidFinishWhenShow(menu:CBMenu)
    
    optional func wilHideBackground(menu:CBMenu, background:UIView)
    
    optional func hideBackground(menu:CBMenu, background:UIView, params:NSDictionary?)
    
    optional func didHideBackground(menu:CBMenu, background:UIView)
    
    optional func wilShowBackground(menu:CBMenu, background:UIView)
    
    optional func showBackground(menu:CBMenu, background:UIView, params:NSDictionary?)
    
    optional func didShowBackground(menu:CBMenu, background:UIView)    
    
}
@available(iOS 9.0, *)
extension CBMenuAnimatorDelegate {
    
    func willShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem){

        segment.alpha = 0
        let point = menu.convertPoint(menu.buttonOrigin, toView: menu.container)
        
        segment.frame = CGRect(origin: point, size:menu.segmentSize)
        menu.container.addSubview(segment)
        print("will show \(indexPath.item) and frame \(segment.frame)")
    }
    
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem, params:NSDictionary?)
    {
        UIView.animateWithDuration(0.3, delay: 0.0 * Double(indexPath.item), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
            let destenation = segment.destenationPosition
            
            segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
            segment.alpha = 1
            }, completion: nil)
    }
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem, params:NSDictionary?)
    {
        
        var delay:Double = 0
        if let _dict = params {
            delay = _dict.objectForKey("delay") as! Double
        }
        UIView.animateWithDuration(0.3, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            let convertedPos = menu.buttonOrigin
            segment.transform = CGAffineTransformMakeTranslation(convertedPos.x, convertedPos.y)
            segment.alpha = 0
            }, completion: {(_)in
                print("hide element \(indexPath.item)")
                segment.removeFromSuperview()
        })

    }
}
