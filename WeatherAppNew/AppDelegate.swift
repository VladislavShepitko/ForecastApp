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
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //weatherService.settings.load()
        /*
        let city3 = City(id: 1283378, name: "Gorkhā", country: "NP", coords: (84.633331, 28))
        let city2 = City(id: 1270260, name: "State of Haryāna", country: "IN", coords: (76, 29))
        let city1 = City(id: 708546, name: "Holubynka", country: "UA", coords: (44.599998, 33.900002))
        
        let city = City(id: 519188, name: "Novinki", country: "RU", coords: (55.683334, 37.666668))
        
        Preffrences.shared.cities = [city, city1,city2,city3]*/
        print(Preffrences.shared.cities)
        print("")
        /*
        let units = preffrences.tempUnits
        print("units: \(units)")
        print(preffrences.cities)
        */
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        //self.weatherService.settings.save()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    
}


