//
//  AppSaver.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import ObjectMapper
import WeatherAPIServiceInfo

enum Notification : Mappable {
    case On(from:NSDate?, to:NSDate?)
    case Off
    
    init?(_ map: Map) {
        self = .Off
        buildWith(map: map)
    }
    mutating func mapping(map: Map) {
        buildWith(map: map)
    }
    private func buildWith(map map:Map) -> Notification {
        var _isOn = false
        _isOn <- map["isOn"]
        if _isOn == true {
            var from:NSDate = NSDate(), to:NSDate = NSDate();
            
            from <- (map["from"],DateTransform())
            to <- (map["to"],DateTransform())
            return .On(from: from, to: to)
        }else {
            return .Off
        }
    }
}

enum WindSpeedUnits:String {
    case MilePerHour
    case KilomertPerHour
    case MetersPerSeconds
    case Nodes
}


class Settings : Mappable {
    class var byDefault:Settings {
        return Settings()
    }
    var notification:Notification
    var language:Language
    var tempUnits:Units
    var windSpeedUnits:WindSpeedUnits
    var cities:[City] = []
    var lastUpdate:NSDate
    
    init(){
        notification =  .Off
        language = .English
        tempUnits = .Celsius
        windSpeedUnits = .MetersPerSeconds
        lastUpdate = NSDate()
    }
    
    // MARK: Mappable
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //from: https://stackoverflow.com/questions/34612790/how-to-assign-rawvalue-of-enum-to-variable-with-objectmapper
        notification <- (map["notification"])
        language <- (map["lang"],EnumTransform<Language>())
        tempUnits <- (map["temp"],EnumTransform<Units>())
        windSpeedUnits <- (map["wind"],EnumTransform<WindSpeedUnits>())
        lastUpdate <- (map["lastUpdate"], DateTransform())
        cities <- map["cities"]
        
    }
    
}
 