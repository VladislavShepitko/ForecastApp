//
//  MenuNavigationViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/5/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class MenuNavigationViewController: UINavigationController {
    var animator = LinearAnimator()
    
    lazy var menu:Menu = {
        let m = Menu()
        m.animator = self.animator
        m.dataSource = self
        return m
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
@available(iOS 9.0, *)
extension MenuNavigationViewController: MenuDataSource {
    
    func numberOfItems() -> Int
    {
        return 6
    }
    func onItemTap(menu:Menu, at indexPath:NSIndexPath, item:Item){
        /*
        UIView.animateWithDuration(0.5, delay: 0.1 , usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
        
        let curFrame = item.title.frame
        let newFrame = CGRect(x: curFrame.origin.x - curFrame.size.width, y: curFrame.origin.y, width: curFrame.size.width, height: curFrame.size.height)
        item.title.frame = newFrame
        
        }, completion: {(_)in
        menu.hide()
        })*/
        menu.hide()
        
    }
    func show(menu:Menu, at indexPath:NSIndexPath, item:Item){
        item.layer.transform = CATransform3DMakeRotation(CGFloat(90.radians), 0, 1, 0)
        ///print("show item with frame: \(item.button.frame)")
        //animate item
        item.title.alpha = 0
        UIView.animateWithDuration(1.0, delay: 0.1 * Double(indexPath.item), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            item.transform = CGAffineTransformIdentity
            //animate label appear
            }, completion: nil)
        UIView.animateWithDuration(0.1) { () -> Void in
            item.title.alpha = 1
        }
    }
    func hide(menu:Menu, at indexPath:NSIndexPath, item:Item){
        UIView.animateWithDuration(1.0, delay: 0.1 * Double(indexPath.item), usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            item.layer.transform = CATransform3DMakeRotation(CGFloat(90.radians), 0, 1, 0)
            }, completion: {(_)in
                item.removeFromSuperview()
        })
        UIView.animateWithDuration(0.1) { () -> Void in
            item.title.alpha = 0
        }
    }
    func sizeForItem() -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func dataForItem(menu:Menu, at indexPath:NSIndexPath, item:Item){
        item.button.setImage(UIImage(named: "004-shuffle")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        item.button.imageView?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
    }
}