//
//  AppDelegate.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    class var sharedApplicaton:AppDelegate{
        struct SingletonWrapper{
            static let singleton = UIApplication.sharedApplication().delegate as! AppDelegate
        }
        return SingletonWrapper.singleton
    }
    let weatherService = WeatherServiceWrapper.shared
    //let settings = AppSettings.sharedSettings
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        weatherService.updateWeather()
        
        customizeNavBar()
        return true
    }
    
    func customizeNavBar(){
        //customize navigation bar
        //get rid of black bar underneath navbar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().translucent = true
        //change background color of tint top bar
        UINavigationBar.appearance().barTintColor = UIColor.clearColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    
}


