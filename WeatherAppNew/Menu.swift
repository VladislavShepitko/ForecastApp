//
//  NewMenu.swift
//  NewMenu
//
//  Created by Vladyslav Shepitko on 8/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
enum MenuError:ErrorType {
    case DataSourceNullPointer
    case AnimatorNullPointer
}

class Menu : UIView {
    weak var dataSource:MenuDataSource?
    weak var animator: MenuAnimator?
    
    private(set) var containerView:UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    private(set) var backgroundView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    
    lazy private(set) var items:[Item]! = {
        var _items:[Item] = []
        if let _dataSource = self.dataSource {
            for index in 0..<_dataSource.numberOfItems() {
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                let item = Item()
                item.button.tag = index
                item.button.addTarget(self, action: "tapToHide:", forControlEvents: .TouchUpInside)
                _dataSource.dataForItem(self, at:indexPath, item:item)
                //item.backgroundColor = UIColor.yellowColor()
                item.button.tintColor = UIColor(white: 1, alpha: 0.9)
                //customize item
                _items.append(item)
            }
        }
        return _items
        }()
    
    override var frame:CGRect {
        willSet{
            self.containerView.frame = CGRect(origin: .zero, size: newValue.size)
        }
    }
    
    lazy private(set) var itemSize:CGSize = {
        var size = CGSize(width: 32, height: 32)
        if let _dataSource = self.dataSource,
            let sizeForItem = _dataSource.sizeForItem {
                size = sizeForItem()
        }
        return size
        }()
    
    var customAnchor:CGPoint = CGPoint(x: 0, y: 0)
    
    lazy var origin:CGPoint = {
        let pos = CGPoint(x: self.bounds.size.width * self.customAnchor.x, y: self.bounds.size.height * self.customAnchor.y)
        print("new pos: \(pos)")
        return pos
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        self.clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.backgroundColor = UIColor.redColor()
        prepareMenu()
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapToHide(sender:UIButton){
        guard let _dataSource = self.dataSource else {
            return
        }
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let item = self.items[sender.tag]
        _dataSource.onItemTap(self, at:indexPath, item:item)
    }
    
    func show()
    {
        do {
            try showMenu()
        }catch{
            
        }
    }
    func hide()
    {
        do {
            try hideMenu()
        }catch{
            
        }
    }
    var widthConstraint:NSLayoutConstraint!
    var widthConstraintMenu:NSLayoutConstraint!
    
    private func prepareMenu(){
        //show background
        if let window = UIApplication.sharedApplication().keyWindow {
            backgroundView.frame = window.frame
            
            window.addSubview(backgroundView)
            window.addConstraintsWithFormat("V:|[v0]|", views: backgroundView)
            window.addConstraintsWithFormat("H:|[v0]|", views: backgroundView)
            
            window.addSubview(self)
            
            let left1 = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: window, attribute: .Left, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: window, attribute: .Top, multiplier: 1, constant: 50)
            let height1 = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: window, attribute: .Height, multiplier: 1, constant: 0)
            widthConstraintMenu = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 70)
            window.addConstraints([left1,top,height1,widthConstraintMenu])
            
            let left = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0)
            widthConstraint = NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0)
            self.addConstraints([left,centerY,height,widthConstraint])
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dissmissViewWrapper"))
        }
    }
    private func showMenu() throws {
        guard let _dataSource = self.dataSource else {
            throw MenuError.DataSourceNullPointer
        }
        guard let _animator = self.animator else {
            throw MenuError.AnimatorNullPointer
        }
        
        widthConstraint.active = true
        widthConstraintMenu.constant = 70
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundView.alpha = 1
            self.layoutIfNeeded()
            for index in  _dataSource.indexesForEnumeration (self) {
                let item = self.items[index.item]
                //set position and frame
                _animator.prepareForShowItem(self,at:index, item:item)
                
                self.containerView.addSubview(item)
                _dataSource.show(self, at: index, item: item)
            }
            }, completion: {(_)in
            print("finish show animation")
        })        
    }
    
    private func hideMenu() throws {
        guard let _dataSource = self.dataSource else {
            throw MenuError.DataSourceNullPointer
        }
        guard let _animator = self.animator else {
            throw MenuError.AnimatorNullPointer
        }
        widthConstraint.active = false
        widthConstraintMenu.constant = 0
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundView.alpha = 0
            
            for index in  _dataSource.indexesForEnumeration(self) {
                let item = self.items[index.item]
                //set position and frame
                _animator.prepareForHideItem(self,at:index, item:item)
                _dataSource.hide(self, at: index, item: item)
            }
            
            }, completion: {(_)in
                self.layoutIfNeeded()
                print("sinidh hide animation")
        })
    }
    
    func dissmissViewWrapper(){
        self.hide()
    }
}

class Item:UIView {
    
    var button:UIButton = {
        let btn = UIButton(type: .System)
        return btn
        }()
    var title:UILabel = {
        let lbl = UILabel()
        lbl.text = "Add location"
        lbl.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        lbl.textColor = UIColor(white: 1, alpha: 0.9)
        return lbl
        }()
    
    override var frame:CGRect {
        willSet{
            //print("frame to set: \(newValue)")
            self.button.frame = CGRect(origin: CGPointZero, size: newValue.size)
            //print("frame: \(self.button.frame)")
            self.title.frame = CGRect(origin: CGPoint(x: 50, y: newValue.size.height / 2 - 15), size: CGSize(width: 100, height: 30))
        }
    }
    convenience init(){
        self.init(frame:CGRectZero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        addSubview(title)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
