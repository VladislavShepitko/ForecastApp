//
//  AppDelegate.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var sharedApplication:AppDelegate = {
            return UIApplication.sharedApplication().delegate as? AppDelegate
        }()!
    
    var window: UIWindow?
    
    let weatherVC = WeatherViewController()
    
    lazy var navigationVC:UINavigationController = {
        let nvc = UINavigationController(rootViewController: self.weatherVC)
        return nvc
        }()
    
    let imageSet:[(ToggleImages,TapAction)] = {
        var arr:[(ToggleImages,TapAction)] = []
        arr.append((ToggleImages(UIImage(named: "004-shuffle-1")!,UIImage(named: "005-shuffle")!), {(sender)in print("shuffle")}))
        arr.append((ToggleImages(UIImage(named: "001-repeat-1")!,UIImage(named: "006-repeat")!), {(sender)in print("repeat")}))
        arr.append((ToggleImages(UIImage(named: "003-like-1")!,UIImage(named: "007-like")!), {(sender)in print("like")}))
        return arr
        }()
    
    lazy var menu:CBMenu = {
        let cbMenu = CBMenu(withDataSource: self, delegate: self, animator: CBMenuLinearAnimator(), frame: CGRect(x: 0, y: 0, width: 100, height: UIScreen.mainScreen().bounds.height))
        return cbMenu
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
        
        
        addMenu()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    func addMenu(){
        if let rootView = window?.rootViewController?.view {
            rootView.addSubview(menu)
            menu.backgroundColor = UIColor.redColor()
            rootView.addConstraintsWithFormat("V:|[V0(300)]", views: menu)
            rootView.addConstraintsWithFormat("H:|[V0(70)]", views: menu)
        }
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
@available(iOS 9.0, *)
extension AppDelegate : CBMenuDataSource,CBMenuDelegate {
    func actionForSegment(at indexPath: NSIndexPath) -> TapAction {
        return imageSet[indexPath.item].1
    }
    func sizeForSegments() -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    func sizeForMenuButton()->CGSize
    {
        return CGSize(width: 40, height: 40)
    }
    func imagesForMenuButtonStates() -> ToggleImages
    {
        return (UIImage(named: "008-mark-1")!,UIImage(named: "002-mark")!)
    }
    
    func numberOfSegments() -> Int
    {
        return imageSet.count
    }
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
    {
        return imageSet[indexPath.item].0
    }
}


