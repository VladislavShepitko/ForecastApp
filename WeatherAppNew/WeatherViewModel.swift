//
//  WeatherViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo


class WeatherViewModel {
    private (set) var cityName:String
    var updateTime:String{
        get {
            return Preffrences.shared.lastUpdate!.toSinceTime()
        }
    }
    private (set) var isCurrentLocation:Bool
    private (set) var forecastForToday:[ForecastViewModel]
    private (set) var errorMessgage:String?
    
    init() {
        self.cityName = ""
        self.isCurrentLocation = false
        self.forecastForToday = [ForecastViewModel]()
    }
    
    convenience init?(weatherForCity city:City, withForecastType type:Preffrences.ForecastFor){
        self.init()
        if let forecastList = city.forecast {
            //need some preparations
            //isCurrentLocation = true
            forecastForToday.removeAll()
            if type == .Hours{
                for model in forecastList {
                    var forecast = ForecastViewModel()
                    forecast.update(model)
                    self.forecastForToday.append(forecast)
                }
            }else {
                for model in forecastList {
                    var forecast = ForecastViewModel()
                    forecast.update(model)
                    self.forecastForToday.append(forecast)
                }
            }
            self.cityName = city.name
        }else{
            return nil
        }
    }
    
    convenience init(errorMessage:String){
        self.init()
        self.errorMessgage = errorMessage
    }
    
}

struct ForecastViewModel {
    
    private (set) var temp:String
    private (set) var tempMin:String
    private (set) var tempMax:String
    private (set) var icon:String
    private (set) var weatherDescription:String
    private (set) var pressure:String
    private (set) var humidity:String
    private (set) var wSpeed:String
    private (set) var wDirection:String
    private (set) var clouds:String
    private (set) var snow:String
    
    private (set) var today:String
    private (set) var date:String
    
    init() {
        self.temp = ""; self.icon = "";self.today = ""
        self.date = ""; self.weatherDescription = ""; self.pressure = ""
        self.humidity = ""; self.wSpeed = ""; self.wDirection = ""
        self.clouds = ""; self.snow = ""; self.tempMin = ""; self.tempMax = ""
    }
    
    mutating func update(forecast:Forecast){
        self.temp = "\(Int(floor(forecast.temp)))º"
        self.tempMin = "\(Int(floor(forecast.tempMin)))"
        self.tempMax = "\(Int(floor(forecast.tempMax)))"
        var desc = forecast.descr
        self.icon = self.iconFromDescription(desc)
        self.weatherDescription = desc.capitalizedString
        self.pressure = "\(Int(round(forecast.pressure)))"
        self.humidity = "\(round(forecast.humidity))"
        self.wSpeed = "\(round(forecast.speed))"
        self.wDirection = "\(forecast.direction.toEarthDirection())"
        self.clouds = "\(Int(floor(forecast.clouds)))"
        self.snow = "\(Int(floor(forecast.snow)))"
        
        let forecastDate = getDate(forecast.time)
        self.date = forecastDate.date
        self.today =  forecastDate.today
    }
    
    func iconFromDescription(description:String) -> String{
        var iconName = "Sun"
        let lowCaseDescription = description.lowercaseString
        if lowCaseDescription.containsString("clear"){
            iconName = Climacons.Sun.rawValue
        }else if lowCaseDescription.containsString("clouds"){
            iconName = Climacons.Cloud.rawValue
        }else if lowCaseDescription.containsString("drizzle") ||
            lowCaseDescription.containsString("rain") ||
            lowCaseDescription.containsString("thunderstorm"){
                iconName = Climacons.Rain.rawValue
        }else if lowCaseDescription.containsString("snow") ||
            lowCaseDescription.containsString("ice") ||
            lowCaseDescription.containsString("hail") {
                iconName = Climacons.Snow.rawValue
        }else if lowCaseDescription.containsString("fog") ||
            lowCaseDescription.containsString("overcast") ||
            lowCaseDescription.containsString("dust") ||
            lowCaseDescription.containsString("ash") ||
            lowCaseDescription.containsString("mist") ||
            lowCaseDescription.containsString("haze") ||
            lowCaseDescription.containsString("spray") ||
            lowCaseDescription.containsString("squall"){
                iconName = Climacons.Haze.rawValue
        }
        return iconName
    }
    func getDate(date:NSDate)->(today:String, date:String){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.stringFromDate(date)
        
        var dateString = ((date.dayOfTheWeek())!).uppercaseString
        if NSCalendar.currentCalendar().isDateInToday(date){
            dateString = "TODAY"
        }else if NSCalendar.currentCalendar().isDateInTomorrow(date){
            dateString = "TOMORROW"
        }
        
        let str = (time,dateString)
        
        return str
    }
}