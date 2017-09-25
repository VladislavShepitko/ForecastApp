//
//  WeatherSevar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import WeatherAPIServiceInfo



class CityWrapper: NSObject, NSCoding {
    var cities: [City]? = []
    
    override var description: String {
        return "Superman's real powers are \(cities)"
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        cities = aDecoder.decodeObjectForKey("cities_array") as? [City]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(cities, forKey: "cities_array")
    }
}


extension NSUserDefaults {
    subscript(key: DefaultsKey<CityWrapper?>) -> CityWrapper? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

extension DefaultsKeys {
    static let notification = DefaultsKey<Bool>("notification")
    static let from = DefaultsKey<NSDate?>("from")
    static let to = DefaultsKey<NSDate?>("to")
    static let lastUpdate = DefaultsKey<NSDate?>("lastUpdate")
    static let currentCityIndex = DefaultsKey<Int?>("currentCityIndex")
    static let tempUnits = DefaultsKey<String>("tempUnits")
    static let windUnits = DefaultsKey<Int>("windSpeed")
    static let forecastFor = DefaultsKey<Int>("forecastFor")
    static let citiesKey = DefaultsKey<CityWrapper?>("cities")
}

let weatherAppIdentifier = "com.svapp.weather.app"

final class Preffrences : NSObject {
    
    class var shared:Preffrences {
        struct PreffencesWrapper{
            static let singleton = Preffrences()
        }
        return PreffencesWrapper.singleton
    }
    
    static var Defaults = NSUserDefaults(suiteName: weatherAppIdentifier)!
    
    enum Notification{
        case On(from:NSDate?, to:NSDate?)
        case Off
    }
    enum WindSpeedUnits:Int {
        case MilePerHour
        case KilomertPerHour
        case MetersPerSeconds
        case Nodes
    }
    
    enum ForecastFor:Int{
        case Hours
        case Days
    }
    
    var notification:Notification = .Off {
        didSet{
            switch notification {
            case .On(let from, let to):
                Preffrences.Defaults[.notification] = true
                Preffrences.Defaults[.to] = to
                Preffrences.Defaults[.from] = from
            case .Off:
                Preffrences.Defaults[.notification] = false
                Preffrences.Defaults[.to] = nil
                Preffrences.Defaults[.from] = nil
            }
        }
    }
    var lastUpdate:NSDate? = nil {
        didSet{
            let value = Preffrences.Defaults[.lastUpdate]
            if lastUpdate != value {
                Preffrences.Defaults[.lastUpdate] = lastUpdate
            }
        }
    }
    
    var currentCityIndex:Int = 0 {
        didSet{
            let value = Preffrences.Defaults[.currentCityIndex]
            if currentCityIndex != value {
                clamp(&currentCityIndex,minValue: 0, maxValue: cities.count)
                Preffrences.Defaults[.currentCityIndex] = currentCityIndex
            }
        }
    }
    var cities:[City] = [City]() {
        didSet{
            print("set array data")
            let current = Preffrences.Defaults[.citiesKey]?.cities!
            let wrapper =  CityWrapper()
            wrapper.cities = cities
            Preffrences.Defaults[.citiesKey] = wrapper
            if current! != cities {
                self.needUpdate = true
            }else {
                self.needUpdate = false
            }
        }
    }
    
    var tempUnits:Units = .Celsius {
        didSet{
            let value = Preffrences.Defaults[.tempUnits]
            if tempUnits.rawValue != value  {
                Preffrences.Defaults[.tempUnits] = tempUnits.rawValue
            }
        }
    }
    var windSpeedUnits:WindSpeedUnits = .KilomertPerHour {
        didSet{
            let value = Preffrences.Defaults[.windUnits]
            if windSpeedUnits.rawValue != value  {
                Preffrences.Defaults[.windUnits] = windSpeedUnits.rawValue
            }
        }
    }
    
    var forecastType:ForecastFor = .Hours {
        didSet{
            let value = Preffrences.Defaults[.forecastFor]
            if value != forecastType.rawValue {
                Preffrences.Defaults[.forecastFor] = forecastType.rawValue
            }
        }
    }
    var needUpdate:Bool = true
    
    private override init(){
        super.init()
        
        if !Preffrences.Defaults.hasKey(.notification) || !Preffrences.Defaults.hasKey(.from) || !Preffrences.Defaults.hasKey(.to) {
            Preffrences.Defaults[.notification] = false
            Preffrences.Defaults[.from] = nil
            Preffrences.Defaults[.to] = nil
        }else {
            if Preffrences.Defaults[.notification] {
                let from = Preffrences.Defaults[.from]
                let to = Preffrences.Defaults[.to]
                self.notification =  .On(from: from, to: to)
            }else {
                notification = .Off
            }
        }
        //update last update time
        if !Preffrences.Defaults.hasKey(.lastUpdate){
            Preffrences.Defaults[.lastUpdate] = nil
        }else {
            lastUpdate = Preffrences.Defaults[.lastUpdate]
        }
        //update cur city id
        if !Preffrences.Defaults.hasKey(.currentCityIndex){
            Preffrences.Defaults[.currentCityIndex] = nil
        }else {
            self.currentCityIndex = Preffrences.Defaults[.currentCityIndex] ?? 0
        }
        //update cities
        if !Preffrences.Defaults.hasKey(.citiesKey){
            print("hero is nil, try to create box for it")
            Preffrences.Defaults[.citiesKey] = CityWrapper()
        }else {
            print("it exist")
            //clear cache
            //Preffrences.Defaults.remove(.citiesKey)
            if let wrapper = Preffrences.Defaults[.citiesKey]{
                if let cities = wrapper.cities{
                    self.cities = cities
                }else {
                    self.cities = [City]()
                }
                print("superman: \(wrapper.description)")
            }else {
                print("store is empty")
                let wrapper = CityWrapper()
                Preffrences.Defaults[.citiesKey] = wrapper
                self.cities = wrapper.cities!
            }
            
        }
        
        //update temperature units
        if !Preffrences.Defaults.hasKey(.tempUnits){
            Preffrences.Defaults[.tempUnits] = Units.Celsius.rawValue
        }else {
            self.tempUnits =  Units(rawValue:Preffrences.Defaults[.tempUnits])!
        }
        
        //update wind speed units
        if !Preffrences.Defaults.hasKey(.windUnits){
            Preffrences.Defaults[.windUnits] = WindSpeedUnits.KilomertPerHour.rawValue
        }else {
            self.windSpeedUnits =  WindSpeedUnits(rawValue:Preffrences.Defaults[.windUnits])!
        }
    }
    func cleanCache(){
        Preffrences.Defaults.remove(.citiesKey)
        let wrapper = CityWrapper()
        Preffrences.Defaults[.citiesKey] = wrapper
        self.cities = wrapper.cities!
    }
    
}

