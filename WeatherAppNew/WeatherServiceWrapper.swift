//
//  WeatherServiceWrapper.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo
import CoreLocation

final class WeatherServiceWrapper: NSObject {
    class var shared:WeatherServiceWrapper {
        struct SingletonWrapper{
            static let singleton:WeatherServiceWrapper = WeatherServiceWrapper()
        }
        return SingletonWrapper.singleton
    }
    
    var currentCityIndex:Int = 0
    //make this observable
    var weatherModel:Observable<WeatherViewModel>?
    
    
    //cities for forecast
    var cities:[City] = []
    
    //private queue for send requests
    private var weatherAPI:WeatherAPIServiceInfo = WeatherAPIServiceInfo()

    //
    private let weatherQ: dispatch_queue_t = dispatch_queue_create("weatherQueue", DISPATCH_QUEUE_SERIAL)
    
    private override init(){
        super.init()
        weatherModel = Observable<WeatherViewModel>(value: WeatherViewModel())
        weatherAPI.delegate = self
    }
    
    func updateWeather(){
        for _ in 0..<1 {
        //for city in  cities {
            dispatch_async(weatherQ, { () -> Void in
                //let coords = city.coords
                //self.weatherAPI.updateWeatherForLocation(lat: coords.latitude, lon: coords.longitude)
                self.weatherAPI.updateWeatherForLocation(lat: 1.0, lon:  1.0)
            })
        }
    }
    func fetchWeatherForCity(withID id:Int){
        self.currentCityIndex = id
//        weatherModel.currentCity
    }
    
    
}
extension WeatherServiceWrapper: WeatherServiceDelegate {
    func fetchWeather(result: WeatherResult) {
        
        //update weather model
        
        switch result{
        case .Success(let weather):
            let cityID = weather
            //set view model
            //print(weather)
            break
        case .Failure(let error):break
        }
        
    }
}
