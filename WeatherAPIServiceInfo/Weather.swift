//
//  Weather.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Forecast {
    
    public let temp:Double
    public let tempMin:Double
    public let tempMax:Double
    public let icon:String
    public let description:String
    
    
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
            self.description = description
            self.pressure = pressure
            self.speed = speed
            self.humidity = humidity
            self.direction = direction
            self.time = time
            self.clouds = clouds
            self.snow = snow
    }
    
    init(json:JSON){
        
         //main
        let time = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
        let description = (json["weather"][0]["description"]).stringValue
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
        
        
        self.init(temp: temp, tempMin: tempMin, tempMax: tempMax, icon: icon, description: description, pressure: pressure, humidity: humidity, speed: wSpeed, direction: wDeg, clouds:clouds, snow: snow, time: time)
    }
 
}
public struct Weather{
    public let cityID:Int
    public var forecast:[Forecast]? = []
    init(withCityID id:Int){
        self.cityID = id
    }
}
 