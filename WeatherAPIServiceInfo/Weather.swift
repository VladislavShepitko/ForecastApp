//
//  Weather.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

public class Forecast: NSCopying {
    public let temp:Double
    public let tempMin:Double
    public let tempMax:Double
    public let icon:String
    public var weatherDescription:String
    public let time:NSDate
    init(icon:String,
        description:String,
        time:NSDate,
        temp:Double,
        tempMin:Double,
        tempMax:Double){
        self.temp = temp
            self.tempMax = tempMax
            self.tempMin = tempMin
            self.icon = icon
            self.weatherDescription = description
            self.time = time
    }
    
    @objc public func copyWithZone(zone: NSZone) -> AnyObject {
        return Forecast(icon: self.icon, description: self.weatherDescription, time: self.time, temp: self.temp, tempMin: self.tempMin, tempMax: self.tempMax)
    }
}

public class Weather: Forecast {
    
    public var cityId:Int = 0
    public let condition:Int
    public let pressure:Double
    public let humidity:Double
    public let speed:Double
    public let direction:Double
    
    public var forecast:[Forecast] = []
    
    init(icon:String,
        description:String,
        time:NSDate,
        temp:Double,
        tempMin:Double,
        tempMax:Double,
        pressure:Double,
        humidity:Double,
        speed:Double,
        direction:Double,
        condition:Int
        ){
            self.pressure = pressure
            self.humidity = humidity
            self.speed = speed
            self.direction = direction
            self.condition = condition
            super.init(icon: icon, description: description, time: time, temp: temp, tempMin: tempMin, tempMax: tempMax)
    }
    override public func copyWithZone(zone: NSZone) -> AnyObject {
        return Weather(icon: icon, description: weatherDescription, time: time, temp: temp, tempMin: tempMin, tempMax: tempMax, pressure: pressure, humidity: humidity, speed: speed, direction: direction, condition:condition)
    }
}
