//
//  Weather.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

@objc public class Forecast : NSObject, NSCoding {
    
    public let temp:Double
    public let tempMin:Double
    public let tempMax:Double
    public let icon:String
    public let descr:String
    
    
    public let pressure:Double
    public let humidity:Double
    public let speed:Double
    public let direction:Double
    public let clouds:Double
    public let snow: Double
    public let time:NSDate
 
    init(temp:Double,
        tempMin:Double,
        tempMax:Double,
        icon:String,
        description:String,
        pressure:Double,
        humidity:Double,
        speed:Double,
        direction:Double,
        clouds:Double,
        snow:Double,
        time:NSDate){
            self.temp = temp
            self.tempMin = tempMin
            self.tempMax = tempMax
            self.icon = icon
            self.descr = description
            self.pressure = pressure
            self.speed = speed
            self.humidity = humidity
            self.direction = direction
            self.time = time
            self.clouds = clouds
            self.snow = snow
    }
    
    convenience init(json:JSON){
        
         //main
        let time = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
        let descr = (json["weather"][0]["description"]).stringValue
        let icon = (json["weather"][0]["icon"]).stringValue
        
        let temp = (json["main"]["temp"]).doubleValue
        let tempMin = (json["main"]["temp_min"]).doubleValue
        let tempMax = (json["main"]["temp_max"]).doubleValue
        
        
        //in the box
        let pressure = (json["main"]["pressure"]).doubleValue
        let humidity = (json["main"]["humidity"]).doubleValue
 
        let wSpeed = (json["wind"]["speed"]).doubleValue
        let wDeg = (json["wind"]["deg"]).doubleValue
        
        let clouds = (json["clouds"]["all"]).doubleValue
        
        let snow = (json["snow"]["3h"]).doubleValue
        
        
        self.init(temp: temp, tempMin: tempMin, tempMax: tempMax, icon: icon, description: descr, pressure: pressure, humidity: humidity, speed: wSpeed, direction: wDeg, clouds:clouds, snow: snow, time: time)
    }
    required public convenience init(coder aDecoder: NSCoder) {
        //cities = aDecoder.decodeObjectForKey("cities_array") as? [City]
        
        //main
        let time = aDecoder.decodeObjectForKey("time") as! NSDate
        let descr = aDecoder.decodeObjectForKey("descr") as? String ?? ""
        let icon = aDecoder.decodeObjectForKey("icon") as? String ?? ""
        
        let temp = aDecoder.decodeDoubleForKey("temp")
        let tempMin = aDecoder.decodeDoubleForKey("tempMin")
        let tempMax = aDecoder.decodeDoubleForKey("tempMax")
        
        
        //in the box
        let pressure = aDecoder.decodeDoubleForKey("pressure")
        let humidity = aDecoder.decodeDoubleForKey("humidity")
        
        let wSpeed = aDecoder.decodeDoubleForKey("wSpeed")
        let wDeg = aDecoder.decodeDoubleForKey("wDir")
        
        let clouds = aDecoder.decodeDoubleForKey("clouds")
        
        let snow = aDecoder.decodeDoubleForKey("snow")
        
        
        self.init(temp: temp, tempMin: tempMin, tempMax: tempMax, icon: icon, description: descr, pressure: pressure, humidity: humidity, speed: wSpeed, direction: wDeg, clouds:clouds, snow: snow, time: time)
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(time, forKey: "time")
        
        aCoder.encodeObject(descr, forKey: "descr")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(temp, forKey: "temp")
        aCoder.encodeObject(tempMin, forKey: "tempMin")
        aCoder.encodeObject(tempMax, forKey: "tempMax")
        aCoder.encodeObject(pressure, forKey: "pressure")
        aCoder.encodeObject(humidity, forKey: "humidity")
        aCoder.encodeObject(speed, forKey: "wSpeed")
        aCoder.encodeObject(direction, forKey: "wDir")
        aCoder.encodeObject(clouds, forKey: "clouds")
        aCoder.encodeObject(snow, forKey: "snow")
    }
}
/*
@objc public class Weather : NSObject {
    
    //public let cityID:Int
    //public let cityName:String
    //public let cityCoords:CLLocationCoordinate2D
    
    public var forecast:[Forecast]?
    /*init(forCity id:Int, withName name: String, coords:CLLocationCoordinate2D){
        self.cityID = id
        self.cityName = name
        self.cityCoords = coords
    }*/
    override init()
    {
        super.init()
    }
    required public convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.forecast = aDecoder.decodeObjectForKey("forecast") as? [Forecast]
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(forecast, forKey: "forecast")
    }
}
*/