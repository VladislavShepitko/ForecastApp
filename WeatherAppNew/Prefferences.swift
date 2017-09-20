//
//  WeatherSevar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import WeatherAPIServiceInfo

extension DefaultsKeys {
    static let notification = DefaultsKey<Bool>("notification")
    static let from = DefaultsKey<NSDate?>("from")
    static let to = DefaultsKey<NSDate?>("to")
    //static let units = DefaultsKey<Units>("units")
    //static let cities = DefaultsKey<[]>("units")
}


class Preffrences {
    enum Notification{
        case On(from:NSDate?, to:NSDate?)
        case Off
    }
    
    enum WindSpeedUnits:String {
        case MilePerHour
        case KilomertPerHour
        case MetersPerSeconds
        case Nodes
    }
    var notification:Observable<Notification>
    var tempUnits:Units
    var windSpeedUnits:WindSpeedUnits
    var cities:[City] = []
    var lastUpdate:NSDate
    
    init(){
        notification =  .Off
        tempUnits = .Celsius
        windSpeedUnits = .MetersPerSeconds
        lastUpdate = NSDate()
        
    }

}

extension NSUserDefaults {
    subscript(key: DefaultsKey<Units?>) -> Units? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

