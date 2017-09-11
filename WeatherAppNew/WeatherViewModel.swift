//
//  WeatherViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo

class WeatherViewModel: ForecastViewModel {
    var city:Observable<String>
    var updateTime:Observable<String>
    
    var weatherDescription:Observable<String>
    var pressure:Observable<String>
    var humidity:Observable<String>
    var windSpeed:Observable<String>
    var windDirection:Observable<String>
    
    var forecastForToday:Observable<[ForecastViewModel]>
    
    override init() {
        self.city = Observable<String>(value: "")
        self.updateTime = Observable<String>(value: "")
        self.weatherDescription = Observable<String>(value: "")
        
        self.pressure = Observable<String>(value: "")
        self.humidity = Observable<String>(value: "")
        self.windSpeed = Observable<String>(value: "")
        self.windDirection = Observable<String>(value: "")
        
        self.forecastForToday = Observable<[ForecastViewModel]>(value: [])
        
        super.init()
    }
    
    override func update(weatherForCity city:City){
        super.update(weatherForCity: city)
        if let weather = city.weather {
            self.city.value = city.name
            //self.updateTime?.value = weather.updateTime.toSinceTime()
            self.updateTime.value = WeatherServiceWrapper.shared.updateTime.toSinceTime()
            /*self.weatherDescription.value = weather.weatherDescription.capitalizedString
            self.pressure.value = "\(weather.pressure) hPa"
            self.humidity.value = "\(weather.humidity) %"
            self.windSpeed.value = "\(weather.speed) KM/H"
            self.windDirection.value =  weather.direction.toEarthDirection()*/
        }
    }
    
}


class ForecastViewModel:NSObject{
    var time:Observable<String>?
    var temp:Observable<String>
    var tempMin:Observable<String>
    var tempMax:Observable<String>
    var icon:Observable<UIImage!>
    
    override init() {
        
        self.temp = Observable<String>(value: "")
        self.time = Observable<String>(value: "")
        self.tempMin = Observable<String>(value: "")
        self.tempMax = Observable<String>(value: "")
        self.icon = Observable<UIImage!>(value: nil)
        super.init()
    }
    
    func update(weatherForCity city :City){
        if let weather = city.weather {
            /*
            self.temp.value = "\(Int(floor(weather.temp)))º"
            self.tempMin.value = "\(Int(floor(weather.tempMin)))º"
            self.tempMax.value = "\(Int(floor(weather.tempMax)))º"*/
            //self.icon.value = "\(weather.temp) º"
        }
    }
    
}







