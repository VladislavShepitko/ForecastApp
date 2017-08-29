//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
typealias MenuItem = (title:String, image:UIImage)

@available(iOS 9.0, *)
class WeatherViewController: UIViewController {
    //MARK:- ui elements newded for view
    var backgroundView:UIView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        view.contentMode = .ScaleAspectFill
        return view
        }()
    var titleView:TitleView = {
        let view = TitleView()
        view.frame = CGRect(x: 0, y: 0, width: 110, height: 30)
        view.layer.anchorPoint = CGPoint(x: 0.8, y: 0.5)
        return view
        }()
    
    var weatherContainerView:WeatherContainerView = {
        let view = WeatherContainerView()
        return view
        }()
    var containerHeight:NSLayoutConstraint!
    
    
    var searchView:UIRefreshControl = UIRefreshControl()
    //MARK:-datasource for viewconrtroller

    
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //create ui elements
        createSubViews()
        createBarItems()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        print("view will apper")
        let items = Array(self.menuItems[0..<2])
        self.menuItems = items
        
        let newItems = AppDelegate.sharedApplication.weatherService.cities.map({ return MenuItem(title:$0.name,image:UIImage(named: "004-shuffle")!) })
        //print(newItems)
        self.menuItems.appendContentsOf(newItems)
        //print(self.menuItems)

    }*/
    
    
    func createSubViews(){
        self.view.addSubview(backgroundView)
        self.view.addSubview(weatherContainerView)
       
        self.view.addConstraintsWithFormat("H:|[v0]|", views: backgroundView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: backgroundView)
        
        self.view.addConstraintsWithFormat("H:|[v0]|", views: weatherContainerView)
        self.view.addConstraintsWithFormat("V:[v0]|", views: weatherContainerView)
        self.containerHeight = NSLayoutConstraint(item: weatherContainerView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 70)
        self.view.addConstraint(containerHeight)
    }
    
    func createBarItems(){
        let showMenuBut = UIBarButtonItem(image: UIImage(named: "002-mark-1")!.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: "showMenuAction")
        showMenuBut.tintColor = .whiteColor()
        
        let addCityBut = UIBarButtonItem(title: "add", style: .Plain, target: self, action: "addCityAction")
        
        self.navigationItem.leftBarButtonItem = showMenuBut
        self.navigationItem.rightBarButtonItem = addCityBut
        
        self.navigationItem.titleView = self.titleView
        
    }
    
    func orientationDidChange(data: NSNotification){
        let device = UIDevice.currentDevice()
        self.containerHeight.constant = device.orientation.isLandscape ? 40 : 70
        self.view.layoutIfNeeded()
    }
    
    //MARK:- outlet actions
    func showMenuAction(){
        
    }
    
    func addCityAction(){
        
        //let addCityVC = AddCityViewController()
        //navigationController?.pushViewController(addCityVC, animated: true)
    }
    
}

/*
extension WeatherViewController: MenuDataSource {
    
    func numberOfItems() -> Int
    {
        return menuItems.count
    }
    
    func onItemTap(menu:Menu, at indexPath:NSIndexPath, item:Item){

        menu.hide()
        print("tap on the button \(item.button.tag)")
    }
    func show(menu:Menu, at indexPath:NSIndexPath, item:Item){
        item.layer.transform = CATransform3DMakeRotation(CGFloat(90.radians), 0, 1, 0)
        ///print("show item with frame: \(item.button.frame)")
        //animate item
        item.title.alpha = 0
        UIView.animateWithDuration(1.0, delay: 0.1 * Double(indexPath.item), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            item.transform = CGAffineTransformIdentity
            //animate label appear
            }, completion: nil)
        UIView.animateWithDuration(0.1) { () -> Void in
            item.title.alpha = 1
        }
    }
    func hide(menu:Menu, at indexPath:NSIndexPath, item:Item){
        UIView.animateWithDuration(1.0, delay: 0.1 * Double(indexPath.item), usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0, options: [], animations: { () -> Void in
            item.layer.transform = CATransform3DMakeRotation(CGFloat(90.radians), 0, 1, 0)
            }, completion: {(_)in
                item.removeFromSuperview()
        })
        UIView.animateWithDuration(0.1) { () -> Void in
            item.title.alpha = 0
        }
    }
    func sizeForItem() -> CGSize {
        return CGSize(width: 50, height: 40)
    }
    
    func dataForItem(menu:Menu, at indexPath:NSIndexPath, item:Item){
        let newItem = self.menuItems[indexPath.item]
        print(newItem)
        item.button.setImage(newItem.image, forState: .Normal)
        item.title.text = newItem.title
    }
}
*/
