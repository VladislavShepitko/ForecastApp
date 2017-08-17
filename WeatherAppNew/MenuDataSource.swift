//
//  MenuDataSource.swift
//  NewMenu
//
//  Created by Vladyslav Shepitko on 8/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc protocol MenuAnimator : class {
    //prepare item befor it will be added to he container
    func prepareForShowItem(menu:Menu,at indexPath:NSIndexPath, item:Item)
    func prepareForHideItem(menu:Menu,at indexPath:NSIndexPath, item:Item)
    
    
}

@objc protocol MenuDataSource : class {
    //func useSettintgsMenu() -> Bool
    //func numberOfItemsForSettingSection() -> Int
    
    
    func dataForItem(menu:Menu, at indexPath:NSIndexPath, item:Item)
    func numberOfItems() -> Int
    optional func indexesForEnumeration(menu:Menu) -> [NSIndexPath]
    func show(menu:Menu, at indexPath:NSIndexPath, item:Item)
    func hide(menu:Menu, at indexPath:NSIndexPath, item:Item)
    func onItemTap(menu:Menu, at indexPath:NSIndexPath, item:Item)
    
    optional func sizeForItem() -> CGSize
    optional func sizeForMenu() -> CGSize
    
}

extension MenuDataSource {
    
    func indexesForEnumeration(menu:Menu) -> [NSIndexPath] {
        var indexes:[NSIndexPath] = []
        for item in 0..<numberOfItems(){
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            indexes.append(indexPath)
        }
        return indexes
    }
    
}
