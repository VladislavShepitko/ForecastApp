//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

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
        view.backgroundColor = UIColor.redColor()
        return view
        }()
    var containerHeight:NSLayoutConstraint!
    
    
    //MARK:-datasource for viewconrtroller

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create ui elements
        createSubViews()
        createBarItems()
        
        //load data
        
        
    }
    
    
    func createSubViews(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
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
        
        let showMenuBut = UIBarButtonItem(title: "menu", style: .Plain, target: self, action: "showMenuAction")
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
    
    func showMenuAction(){
        
    }
    
    func addCityAction(){
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

