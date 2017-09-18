//
//  WeatherViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo

class WeatherViewModel: NSObject {
    private (set) var cityName:String
    private (set) var updateTime:String
    private (set) var isCurrentLocation:Bool
    private (set) var forecastForToday:[ForecastViewModel]
    
    override init() {
        self.cityName = ""
        self.updateTime = ""
        self.isCurrentLocation = false
        self.forecastForToday = [ForecastViewModel]()
        super.init()
    }
    
    convenience init?(weatherForCity city:City, withForecastType type:ForecastFor){
        self.init()
        if let weather = city.weather {
            //need some preparations
            self.isCurrentLocation = true
            
            self.updateTime = WeatherServiceWrapper.shared.updateTime.toSinceTime()
            
            forecastForToday.removeAll()
            
            if type == .Hours{
                for model in weather.forecast! {
                    let forecast = ForecastViewModel()
                    forecast.update(model)
                    self.forecastForToday.append(forecast)
                }
            }else {
                var forecastForWeather = weather.forecast![0]
                var times = 0
                for var i = 1; i < weather.forecast!.count; i++ {
                    let current = weather.forecast![i]
                    if forecastForWeather.time.dayNumberOfWeek() == current.time.dayNumberOfWeek() {
                        print("same day")
                        //addforecast to array
                        times++
                    }else {
                        //all divide dy times
                        let forecastForDay = ForecastViewModel()
                        print("add day to array")
                        self.forecastForToday.append(forecastForDay)
                        //day change
                        forecastForWeather = current
                        times = 0
                    }
                }
                
            }
            
            /*
            var max = weather.forecast![0].tempMin
            let _ = weather.forecast!.map({
            if $0.tempMax > max{
            max = $0.tempMax
            }
            })
            var min = max
            let _ = weather.forecast!.map({
            if $0.tempMin < min{
            min = $0.tempMin
            }
            })
            */
            
            
            self.cityName = weather.cityName
        }else{
            return nil
        }
    }
    
}

class ForecastViewModel:NSObject {
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
    
    
    override init() {
        self.temp = ""; self.icon = "";self.today = ""
        self.date = ""; self.weatherDescription = ""; self.pressure = ""
        self.humidity = ""; self.wSpeed = ""; self.wDirection = ""
        self.clouds = ""; self.snow = ""; self.tempMin = ""; self.tempMax = ""
        super.init()
    }
    
    func update(forecast:Forecast){
        self.temp = "\(Int(floor(forecast.temp)))º"
        self.tempMin = "\(Int(floor(forecast.tempMin)))"
        self.tempMax = "\(Int(floor(forecast.tempMax)))"
        var desc = forecast.description
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
        let date = ("NOW","9 SEPTEMBER")
        
        return date
    }
    
    deinit{
        print("delete data for: \(self.description): date: \(self.date)")
    }
}