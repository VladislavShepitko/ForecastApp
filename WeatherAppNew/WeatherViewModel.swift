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
    
    var city:Observable<String>?
    var updateTime:Observable<String>?
    var temp:Observable<Double>
    var tempMin:Observable<Double>
    var tempMax:Observable<Double>
    var icon:Observable<UIImage!>
    var weatherDescription:Observable<String>
    var forecastForToday:[ForecastViewModel]?
    
    override init() {
        super.init()
        
        self.city = Observable<String>(value: "")
        self.updateTime = Observable<String>(value: "")
        self.temp = Observable<Double>(value: 0.0)
        
        self.tempMin = Observable<Double>(value: 0.0)
        self.tempMax = Observable<Double>(value: 0.0)
        self.icon = Observable<UIImage!>(value: nil)
        self.weatherDescription = Observable<String>(value: "")
        
        self.forecastForToday = Observable<ForecastViewModel>(value: nil)
        
    }
    func update(weather:Weather){
        
    }
}
class ForecastViewModel:NSObject{
    
}
