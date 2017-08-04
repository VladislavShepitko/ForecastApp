//
//  AppDelegate.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    let weatherVC = WeatherViewController()
    
    lazy var navigationVC:UINavigationController = {
        let nvc = UINavigationController(rootViewController: self.weatherVC)
        return nvc
        }()
    
    lazy var menu:UIView = {
        let v = UIView()
        //v.backgroundColor = UIColor.whiteColor()
        let b = UIButton(type: .System)
        b.backgroundColor = UIColor.redColor()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: "pat", forControlEvents: .TouchUpInside)
        b.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        v.addSubview(b)
        return v
        }()
    
    func pat(){
        self.navigationVC.pushViewController(SettingsViewController(), animated: true)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //self.window?.backgroundColor = UIColor.yellowColor()
        
        navigationVC.setNavigationBarHidden(true, animated: false)
        navigationVC.title = "weather app "
        
        self.window?.rootViewController = navigationVC
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: UIScreen.mainScreen().bounds.height)
        menu.frame = frame
        
        window?.rootViewController?.view.addSubview(menu)
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


