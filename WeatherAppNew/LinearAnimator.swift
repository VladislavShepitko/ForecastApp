//
//  LinearAnimator.swift
//  NewMenu
//
//  Created by Vladyslav Shepitko on 8/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class LinearAnimator: NSObject, MenuAnimator {
    let offset:CGFloat = 0.5
    var currentOffset:CGPoint = CGPointZero
    
    func prepareForShowItem(menu:Menu,at indexPath:NSIndexPath, item:Item)
    {
        let delta = indexPath.item == 0 ? 0 : currentOffset.y + (menu.itemSize.height + offset)
        currentOffset = CGPoint(x: 0, y: delta)
        let origin =  menu.origin + currentOffset
        item.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        let newRect = CGRect(origin: origin, size: menu.itemSize)
        item.frame = newRect
    }
    
    func prepareForHideItem(menu:Menu,at indexPath:NSIndexPath, item:Item)
    {
        
    }
    
}
