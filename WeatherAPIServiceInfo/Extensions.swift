//
//  Extensions.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/6/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import SwiftyJSON

extension NSDate {
    func isToday() -> Bool {
        return NSCalendar.currentCalendar().isDateInToday(self)
    }
    func isTomorrow() -> Bool {
        return NSCalendar.currentCalendar().isDateInTomorrow(self)
    }
}

extension Forecast {
    static func forecastJSON(json:JSON) -> Forecast?{
        let mainJSON = json["main"]
        /*
        let time = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
        
        let descriptionJSON = (json["weather"][0])
        let description = (descriptionJSON["description"]).stringValue
        let icon = (descriptionJSON["icon"]).stringValue
        
        let temp = (mainJSON["temp"]).doubleValue
        let tempMin = (mainJSON["temp_min"]).doubleValue
        let tempMax = (mainJSON["temp_max"]).doubleValue
        
        
        let pressure = (mainJSON["pressure"]).doubleValue
        let humidity = (mainJSON["humidity"]).doubleValue
        //wind parameters
        let windJSON = json["wind"]
        let wSpeed = (windJSON["speed"]).doubleValue
        let wDeg = (windJSON["speed"]).doubleValue*/
        /*
        return Forecast(icon:icon, description: description, temp: temp, time: time,  tempMin: tempMin, tempMax: tempMax, pressure: pressure, humidity: humidity, speed: wSpeed, direction: wDeg)
        */
        
        return nil
    }
}
/*
extension Weather {
     class func weatherFromJSON(json:JSON) -> Weather? {
        var weather:Weather? = nil
        let forecast = forecastJSON(json)
        let mainJSON = json["main"]
        let descriptionJSON = json["weather"]
        
        let condition = (descriptionJSON["id"]).intValue
        let pressure = (mainJSON["pressure"]).doubleValue
        let humidity = (mainJSON["humidity"]).doubleValue
            //wind parameters
        let windJSON = json["wind"]
        let wSpeed = (windJSON["speed"]).doubleValue
        let wDeg = (windJSON["speed"]).doubleValue
            
        weather = Weather(icon:forecast.icon, description: forecast.weatherDescription, time: forecast.time, temp: forecast.temp, tempMin: forecast.tempMin, tempMax: forecast.tempMax, pressure: pressure, humidity: humidity, speed: wSpeed, direction: wDeg, condition:condition)
        weather?.cityId = -1
        
        
        return weather
    }
}*/