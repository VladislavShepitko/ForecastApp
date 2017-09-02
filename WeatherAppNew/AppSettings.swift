//
//  AppSettings.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/31/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo

struct Settings {
    var currentCity:Int
    var cities:[City]
    var location:(Double, Double)
    var units:Units
    var notification:Bool = false
    var notificationInterval:(since:Double, until:Double)
    
}

final class AppSettings: NSObject {
    class var sharedSettings: AppSettings {
        struct SettingsWrapper {
            static let singleton = AppSettings()
        }
        return SettingsWrapper.singleton
    }
    var current:Settings!
    
    var cities:[City]{
        return current.cities
    }
    
    private let filePath = "~/appSettings.json"
    
    private override init(){
        super.init()
        print(filePath)
    }
    
    func addCity(newCity:City){
        self.current.cities.append(newCity)
    }
    
    func save(){
        
        if NSFileManager().fileExistsAtPath(self.filePath){
            //NSFileManager().createFileAtPath(filePath, contents: <#T##NSData?#>, attributes: nil)
        }
    }
    
    func load() -> Settings? {
        
        return nil
    }
    
    
}
