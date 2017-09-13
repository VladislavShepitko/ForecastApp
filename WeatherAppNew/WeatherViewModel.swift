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
    
    override init() {
        self.cityName = Observable<String>(value: "")
        self.updateTime = ""
        self.isCurrentLocation = false
        self.forecastForToday = [ForecastViewModel]()
            
        super.init()
    }
    
    func update(weatherForCity city:City, withForecastType type:ForecastFor){
        if let weather = city.weather {
            self.cityName.value = weather.cityName
            //need some preparations
            //self.isCurrentLocation =
            self.updateTime = WeatherServiceWrapper.shared.updateTime.toSinceTime()
            for /*forecastItem*/_ in weather.forecast! {
                
            }
            //here depend on what forecast we want fetch every hour, or for day
            //weather.forecast
            
        }
        /*
        let weather = city.weather {
            self.city.value = city.name
            //self.updateTime?.value = weather.updateTime.toSinceTime()
            self.updateTime.value = WeatherServiceWrapper.shared.updateTime.toSinceTime()
            /*self.weatherDescription.value = weather.weatherDescription.capitalizedString
            self.pressure.value = "\(weather.pressure) hPa"
            self.humidity.value = "\(weather.humidity) %"
            self.windSpeed.value = "\(weather.speed) KM/H"
            self.windDirection.value =  weather.direction.toEarthDirection()*/
        }*/
    }
    
}


class ForecastViewModel:NSObject {
    private (set) var time:String
    private (set) var temp:String
    private (set) var tempMin:String
    private (set) var tempMax:String
    private (set) var icon:UIImage?
    
    
    
    private (set) var today:String
    private (set) var date:String
    
    
    override init() {
        
        self.temp = ""
        self.time = ""
        self.tempMin = ""
        self.tempMax = ""
        self.icon = nil
        
        self.today = ""
        self.date = ""
        
        super.init()
    }
    
    func update(forecast:Forecast){
        //if let weather = city.weather {
            /*
            self.temp.value = "\(Int(floor(weather.temp)))º"
            self.tempMin.value = "\(Int(floor(weather.tempMin)))º"
            self.tempMax.value = "\(Int(floor(weather.tempMax)))º"*/
            //self.icon.value = "\(weather.temp) º"
        //}
    }
    
}







