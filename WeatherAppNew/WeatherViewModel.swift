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
    private (set) var cityName:Observable<String>
    private (set) var updateTime:String
    private (set) var isCurrentLocation:Bool
    private (set) var forecastForToday:[ForecastViewModel]
    private (set) var tempMin:String
    private (set) var tempMax:String
    
    override init() {
        self.cityName = Observable<String>(value: "")
        self.updateTime = ""
        self.isCurrentLocation = false
        self.tempMin = ""
        self.tempMax = "" 
        self.forecastForToday = [ForecastViewModel]()
        
        super.init()
    }
    convenience init?(weatherForCity city:City, withForecastType type:ForecastFor){
        self.init()
        if let weather = city.weather {
            //need some preparations
            self.isCurrentLocation = true
            self.updateTime = WeatherServiceWrapper.shared.updateTime.toSinceTime()
            forecastForToday = []
            
            for model in weather.forecast! {
                let forecast = ForecastViewModel()
                forecast.update(model)
                self.forecastForToday.append(forecast)
            }
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
            self.tempMin = "\(Int(floor(min)))"
            self.tempMax = "\(Int(floor(max)))"
            
            //here depend on what forecast we want fetch every hour, or for day
            
            //here notificate subscribers that model is updated
            self.cityName.value = weather.cityName
        }else{
            return nil
        }
    }
    
}

class ForecastViewModel:NSObject {
    private (set) var temp:String
    private (set) var icon:UIImage?
    
    private (set) var weatherDescription:String
    private (set) var pressure:String
    private (set) var humidity:String
    private (set) var wSpeed:String
    private (set) var wDirection:String
    private (set) var clouds:String
    private (set) var snow:String
    
    //NOT UPDATED!!!
    private (set) var today:String
    private (set) var date:String
    
    
    override init() {
        
        self.temp = ""
        self.icon = nil
        self.today = ""
        self.date = ""
        self.weatherDescription = ""
        self.pressure = ""
        self.humidity = ""
        self.wSpeed = ""
        self.wDirection = ""
        self.clouds = ""
        self.snow = ""
        
        super.init()
    }
    
    func update(forecast:Forecast){
        var tempMeasureIcon = ""
        switch WeatherServiceWrapper.shared.settings.model.tempUnits.value!{
        case .Celsius:
            tempMeasureIcon = "℃"
            break
        case .Fahreinheit:
            tempMeasureIcon = "℉"
            break
        }
        self.temp = "\(Int(floor(forecast.temp)))\(tempMeasureIcon)"
        var desc = forecast.description
        self.weatherDescription = desc.capitalizedString
        self.pressure = "\(round(forecast.pressure))"
        self.humidity = "\(round(forecast.humidity))"
        self.wSpeed = "\(round(forecast.speed))"
        self.wDirection = "\(forecast.direction.toEarthDirection())"
        self.clouds = "\(Int(floor(forecast.clouds)))"
        self.snow = "\(Int(floor(forecast.snow)))"
        
        let forecastDate = getDate(forecast.time)
        self.date = forecastDate.date
        self.today =  forecastDate.today
    }
    func getDate(date:NSDate)->(today:String, date:String){
        let date = ("NOW","9 SEPTEMBER")
        
        return date
    }
    
    deinit{
        print("delete data for: \(self.description): date: \(self.date)")
    }
}