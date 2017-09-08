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
import SystemConfiguration
import ObjectMapper

public enum ConnectionError:ErrorType {
    case InternetIsNotAvailable
}


final class WeatherServiceWrapper: NSObject {
    class var shared:WeatherServiceWrapper {
        struct SingletonWrapper{
            static let singleton:WeatherServiceWrapper = WeatherServiceWrapper()
        }
        return SingletonWrapper.singleton
    }
    
    private var isInterentAvailable:Bool = false
    private var currentCityIndex:Int = 0
    private var updatedCities:Int = 0
    
    var error:Observable<String?>
    var updateTime:NSDate!
    //make this observable
    var weatherModel:WeatherViewModel? {
        didSet{
            print("set model to \(weatherModel)")
        }
    }
    var settingsService = SaveService.shared
    //cities for forecast
    var cities:[City] = []
    
    //private queue for send requests
    private var weatherAPI:WeatherAPIServiceInfo = WeatherAPIServiceInfo()
    
    //private queue for send async resuests for weather
    private let weatherQ: dispatch_queue_t = dispatch_queue_create("weatherQueue", DISPATCH_QUEUE_SERIAL)
    
    private override init(){
        self.error = Observable<String?>(value: "")
        super.init()
        weatherModel = WeatherViewModel()
        weatherAPI.delegate = self
    }
    
    //MARK:- update weather
    
    /*
    Update weather for all cities? send async request to server,
    handle number of requests in time
    */
    func updateWeather(){
        //check internet connection
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            fetchWeather(.Failure(ConnectionError.InternetIsNotAvailable))
            return
        default:
            break
        }
        
        for city in  cities {
            dispatch_async(weatherQ, { () -> Void in
                let coords = city.coords
                let id = city.id
                print("send request for city:\(id)")
                self.weatherAPI.updateWeatherForLocation(id, lat: coords.latitude, lon: coords.longitude)
            })
        }
        
    }
    
    /*
    use this method when you just want to get downloaded weather from store,
    and dont need to send request to server
    */
    func fetchWeatherForCity(withID id:Int){
        self.currentCityIndex = id
        
        let city = self.cities[self.currentCityIndex]
        weatherModel?.update(weatherForCity: city)
    }
    
}


extension WeatherServiceWrapper: WeatherServiceDelegate {
    func fetchWeather(result: WeatherResult) {
        switch result{
        case .Success(let weather):
            let cityID = weather?.cityId
            print("updated weather for city:\(cityID)")
            let filtered = Array(self.cities.filter(){ $0.id == cityID })
            print(filtered)
            guard let selectedCity = filtered.first else {
                //throw becouse citi in not in array
                print("city hasn't in array")
                break
            }
            selectedCity.weather = weather
            
            //or just update weather in db????
            self.updatedCities++
            if self.updatedCities == self.cities.count {
                print("finish updating")
                //updating is finished
                self.updateTime = NSDate()
                let city = self.cities[self.currentCityIndex]
                weatherModel?.update(weatherForCity: city)
                self.updatedCities = 0
            }
            //update update time
            break
        case .Failure(let error):
            print("weather not updated: some errors")
            if error is ConnectionError {
                self.error.value = "Make sure your device is connected to the internet."
            }else if error is WeatherError {
                let wError = error as! WeatherError
                switch wError {
                case .JSONConvertError:
                    self.error.value = "Some bad happend, we can't display data"
                    break
                case .BadRequestError:
                    self.error.value = "Oh no, something bad happend"
                    break
                }
            }
            break
        }
        
    }
}
