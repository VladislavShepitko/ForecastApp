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

public enum ForecastFor{
    case Hours
    case Days
}

final class WeatherServiceWrapper: NSObject {
    class var shared:WeatherServiceWrapper {
        struct SingletonWrapper{
            static let singleton:WeatherServiceWrapper = WeatherServiceWrapper()
        }
        return SingletonWrapper.singleton
    }
    
    //private var isInterentAvailable:Bool = false
    private var currentCityIndex:Int = 0
    //private var updatedCities:Int = 0
    
    private (set) var error:Observable<String?>
    private (set) var updateTime = NSDate()
    
    //make this observable
    private (set) var viewModel:Observable<WeatherViewModel?>
    
    private (set) var settings = SaveService.shared
    
    
    var forecastType:ForecastFor = .Hours
    //var citiesCache:NSCache?
    //get weather from cache where city id equals weather's city id
    //test
    
    
    //private queue for send requests
    private var weatherAPI:WeatherAPIServiceInfo = WeatherAPIServiceInfo()
    //private queue for send async resuests for weather
    private let weatherQ: dispatch_queue_t = dispatch_queue_create("weatherQueue", DISPATCH_QUEUE_SERIAL)
    
    private override init(){
        viewModel = Observable<WeatherViewModel?>(value: nil)
        self.error = Observable<String?>(value: "")
        super.init()
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
        for city in self.settings.cities {
            dispatch_async(weatherQ, { () -> Void in
                //this is mean that city hasn't name and other stuff
                if city.id == -1 && city.coords != nil{
                    //here search by coords
                    let coords = city.coords!
                    self.weatherAPI.updateWeatherForLocation(coords.latitude, lon: coords.longitude)
                }else {
                    //by id
                    self.weatherAPI.updateWeather(forCityID: city.id)
                }
            })
        }
        
        
    }
    
    /*
    use this method when you just want to get downloaded weather from store,
    and dont need to send request to server
    */
    func fetchWeatherForCity(withID id:Int){
        self.currentCityIndex = id
        let city = self.settings.model.cities[self.currentCityIndex]
        viewModel.value = WeatherViewModel(weatherForCity: city, withForecastType: self.forecastType)
    }
    
}


extension WeatherServiceWrapper: WeatherServiceDelegate {
    func fetchWeather(result: WeatherResult) {
        switch result{
        case .Success(let weather ):
            //cache update weather for city with id or add new item to cache
            struct UpdatedCities{
                static var count:Int = 0
            }
            let cities = self.settings.cities
            let cityID = (weather?.cityID)!
            let cityCoords = (weather?.cityCoords)!
            
            print("updated weather for city:\(cityID)")
            //find city and update weather for
            let filteredByID = Array(cities.filter(){return $0.id == cityID })
            if let cityToUpdate = filteredByID.first {
                cityToUpdate.weather = weather
            }else {
                //then try to filter with coords
                
                print("try to find with coords")
                let filteredByCoords = Array(cities.filter(){ $0.coords == cityCoords })
                if let cityToUpdateWithCoords = filteredByCoords.first {
                    //here update need city
                    cityToUpdateWithCoords.id = cityID
                    cityToUpdateWithCoords.coords = cityCoords
                    cityToUpdateWithCoords.name = (weather?.cityName)!
                }else {
                    print("citi not found")
                }
                
            }
            
            UpdatedCities.count++
            //finish updating
            if UpdatedCities.count == cities.count {
                self.updateTime = NSDate()
                let city = cities[self.currentCityIndex]
                viewModel.value = WeatherViewModel(weatherForCity: city, withForecastType: self.forecastType)
                UpdatedCities.count = 0
            }
            break
        case .Failure(let error):
            
            print("weather not updated: some errors")
            if error is ConnectionError {
                self.error.value = "Make sure that your device is connected to the internet."
            }else if error is WeatherError {
                let wError = error as! WeatherError
                switch wError {
                case .JSONConvertError:
                    self.error.value = "Some bad happend, we can't display data"
                    break
                case .BadRequestError:
                    self.error.value = "Oh no, something bad happend"
                    break
                case .WeatherForCityDoesntFound:
                    self.error.value = "Cant fetch weather. Weather doesn't found"
                    break
                }
            }
            break
        }
        
    }
}

extension CLLocationCoordinate2D : Equatable { }
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude ? true : false
}





