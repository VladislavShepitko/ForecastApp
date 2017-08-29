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

class Menu : UIScrollView {
    
    weak var dataSource:MenuDataSource? {
        didSet{
            self.prepareMenu()
        }
    }
    weak var animator: MenuAnimator?
    
    private(set) var footerView:UIView = {
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
                let item = self.builNewItem(index)!
                //customize item
                _items.append(item)
            }
        }
        return _items
        }()
    
    lazy private(set) var itemSize:CGSize = {
        var size = CGSize(width: 50, height: 50)
        if let _dataSource = self.dataSource,
            let sizeForItem = _dataSource.sizeForItem {
                size = sizeForItem()
        }
        return size
        }()
    
    var customAnchor:CGPoint = CGPoint(x: 0, y: 0)
    lazy private(set) var settingeView:SettingSectionView  = {
        let settings = SettingSectionView(withItemSize: self.itemSize)
        return settings
        }()
    
    lazy var menuSize:CGSize = {
        let prec = (UIScreen.mainScreen().bounds.height * 0.45) / 1
        print("percent: \(prec)")
        let menuHeight = UIScreen.mainScreen().bounds.height - prec
        let size = CGSize(width: 200, height: menuHeight)
        
        return size
        }()
    
    lazy var origin:CGPoint = {
        let pos = CGPoint(x: self.bounds.size.width * self.customAnchor.x, y: self.bounds.size.height * self.customAnchor.y)
        print("new pos: \(pos)")
        return pos
        }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
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
    private var widthConstraintMenu:NSLayoutConstraint!
    
    private func prepareMenu(){
        //show background
        if let window = UIApplication.sharedApplication().keyWindow {
            backgroundView.frame = window.frame
            
            window.addSubview(backgroundView)
            window.addConstraintsWithFormat("V:|[v0]|", views: backgroundView)
            window.addConstraintsWithFormat("H:|[v0]|", views: backgroundView)
            
            window.addSubview(self)
            
            let left = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: window, attribute: .Left, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: window, attribute: .Top, multiplier: 1, constant: 50)
            
            let height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: menuSize.height)
            widthConstraintMenu = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: menuSize.width)
            
            window.addConstraints([left,top,height,widthConstraintMenu])
            
            //adding footer view
            backgroundView.addSubview(footerView)
            backgroundView.addConstraintsWithFormat("V:[v0]-5-[v1]|", views: self,footerView)
            backgroundView.addConstraintsWithFormat("H:|[v0]|", views: footerView)
            
            footerView.addSubview(settingeView)
            footerView.addConstraintsWithFormat("V:|[v0]|", views: settingeView)
            footerView.addConstraintsWithFormat("H:|[v0]|", views: settingeView)
            
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dissmissViewWrapper"))
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dissmissViewWrapper"))
        }
    }
    
    private func builNewItem(index:Int) -> Item? {
        guard let _dataSource = self.dataSource else {
            return nil
        }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        let item = Item()
        item.button.tag = index
        item.button.addTarget(self, action: "tapToHide:", forControlEvents: .TouchUpInside)
        _dataSource.dataForItem(self, at:indexPath, item:item)
        item.button.tintColor = UIColor(white: 1, alpha: 0.9)
        return item
    }
    
    private func showMenu() throws {
        guard let _dataSource = self.dataSource else {
            throw MenuError.DataSourceNullPointer
        }
        guard let _animator = self.animator else {
            throw MenuError.AnimatorNullPointer
        }
        widthConstraintMenu.constant = self.menuSize.width
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundView.alpha = 1
            self.layoutIfNeeded()
            
            }, completion: nil)
        let newCount = _dataSource.numberOfItems()
        if newCount != self.items.count {
            var diff = newCount - self.items.count
            if diff > 0 {
                //add new items
                var startIndex = self.items.count - 1
                for _ in 0...diff {
                    let item = self.builNewItem(startIndex++)
                    self.items.append(item!)
                }
            }else if diff < 0 {
                diff = diff * -1
                var totalCnt = diff
                for _ in 0...diff {
                    if totalCnt > 0{
                        self.items.removeLast()
                        totalCnt--
                    }
                }
            }
        }
        self.contentSize = CGSize(width: self.menuSize.width, height: CGFloat(_dataSource.numberOfItems()) * self.itemSize.height)
        
        for index in  _dataSource.indexesForEnumeration (self) {
            let item = self.items[index.item]
            //set position and frame
            _animator.prepareForShowItem(self,at:index, item:item)
            
            self.addSubview(item)
            _dataSource.show(self, at: index, item: item)
        }
        
    }
    
    private func hideMenu() throws {
        guard let _dataSource = self.dataSource else {
            throw MenuError.DataSourceNullPointer
        }
        guard let _animator = self.animator else {
            throw MenuError.AnimatorNullPointer
        }
        
        widthConstraintMenu.constant = 0
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundView.alpha = 0
            self.layoutIfNeeded()
            }, completion: nil)
        
        for index in  _dataSource.indexesForEnumeration(self) {
            let item = self.items[index.item]
            //set position and frame
            _animator.prepareForHideItem(self,at:index, item:item)
            _dataSource.hide(self, at: index, item: item)
        }
        
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
    let separtionLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
        }()
    
    override var frame:CGRect {
        willSet{
            self.button.frame = CGRect(origin: CGPointZero, size: newValue.size)
            self.title.frame = CGRect(origin: CGPoint(x: 50, y: newValue.size.height / 2 - 15), size: CGSize(width: 150, height: 30))
            
            self.separtionLineView.frame = CGRect(x: 10, y: newValue.height, width: 150, height: 1)
        }
    }
    convenience init(){
        self.init(frame:CGRectZero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = UIColor.whiteColor()
        self.userInteractionEnabled = true
        addSubview(title)
        addSubview(button)
        addSubview(separtionLineView)
        self.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
