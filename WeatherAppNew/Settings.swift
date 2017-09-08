//
//  AppSaver.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import ObjectMapper

enum Notification {
    case On(from:NSDate, to:NSDate)
    case Off
}

//wrapper need becouse mapper doesn't work with enums with diffrent args
class NotificationWrapper: Mappable {
    private var isOn:Bool = false
    private var from:NSDate = NSDate()
    private var to:NSDate = NSDate()
    
    var notification:Notification? {
        didSet{
            if let notification = notification {
                switch notification {
                case .On(let _from, let _to):
                    isOn = true
                    from = _from
                    to = _to
                    break
                case .Off:
                    isOn = false
                    break
                }
            }
        }
    }
    
    init(notification:Notification){
        self.notification = notification
    }
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        var _isOn = false
        _isOn <- map["isOn"]
        if _isOn == true {
            var _from = NSDate()
            var _to = NSDate()
            _from <- (map["from"],DateTransform())
            _to <- (map["to"],DateTransform())
            self.notification = .On(from: _from, to: _to)
        }else {
            self.notification = .Off
        }
    }
}

enum Language : String {
    case RU
    case ENG
    case UA
}
enum TempUnits : String {
    case Celsius
    case Fahreinheit
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
    var notification:NotificationWrapper!
    var language:Language!
    var tempUnits:TempUnits!
    var windSpeedUnits:WindSpeedUnits!
    var citis:[City] = []
    var lastUpdate:NSDate!
    
    init(){
        notification = NotificationWrapper(notification: .Off)
        language = .ENG
        tempUnits = .Celsius
        windSpeedUnits = .MetersPerSeconds
        lastUpdate = NSDate()
    }
    
    // MARK: Mappable
    required init?(_ map: Map) {
        // subClasses must call the constructor of the base class
        // super.init(map)
        
        /* EXAMPLE
        name      = try map.value("name") // throws an error when it fails
        createdAt = try map.value("createdAt", using: DateTransform()) // throws an error when it fails
        updatedAt = try? map.value("updatedAt", using: DateTransform()) // optional
        posts     = (try? map.value("posts")) ?? [] // optional + default value
        
        */
        //language = try map.value("lang")
    }
    
    func mapping(map: Map) {
        //from: https://stackoverflow.com/questions/34612790/how-to-assign-rawvalue-of-enum-to-variable-with-objectmapper
        //typeEnum <- (map["type"],EnumTransform<LevelType>())
        
        notification <- (map["notification"])
        language <- (map["lang"],EnumTransform<Language>())
        tempUnits <- (map["temp"],EnumTransform<TempUnits>())
        windSpeedUnits <- (map["wind"],EnumTransform<WindSpeedUnits>())
        lastUpdate <- (map["lastUpdate"], DateTransform())
        citis <- map["cities"]
        
    }
    
}
/*
let notificationtransform = TransformOf(fromJSON: { (value: Any?) -> Notification? in
    guard let dict = value as? NSDictionary else {
        return nil
    }
    var notification:Notification?
    if let isOn = dict.objectForKey("isOn") {
        if (isOn as! Bool) == true {
            guard let fromValue = dict.objectForKey("from"),
                let from = fromValue as? NSDate,
                let toValue = dict.objectForKey("to"),
                let to = toValue as? NSDate else {
                    return nil
            }
            notification = Notification.On(from: from, to: to)
        }else {
            notification = Notification.Off
        }
    }
    
    return notification
    }) { (value:Notification?) -> Any? in
        var dict = [String:Any]()
        if let value = value {
            switch value {
            case .On(let from, let to):
                dict["isOn"] = true
                dict["from"] = from
                dict["to"] = to
                break
            case .Off:
                dict["isOn"] = false
                break
            }
        }
        return dict
}
*/