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
    
    /*
    let file = "file.txt" //this is the file. we will write to and read from it
    
    let text = "some text" //just a text
    
    if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
    let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
    
    //writing
    do {
    try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
    }
    catch {/* error handling here */}
    
    //reading
    do {
    let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
    }
    catch {/* error handling here */}
    }
    */
    private static let FILE = "settings.json"
    static let DIRECTORY = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
    static let PATH = NSURL(fileURLWithPath: DIRECTORY!).URLByAppendingPathComponent(FILE)
    
    static var settings:Settings!
    
    
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
    
    //MARK:- all for settings
    func loadSettings(){
        
        //reading
        do {
            let path = WeatherServiceWrapper.PATH
            let settings = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
            print("from file: \(settings)")
            if let deserializedSettings = Mapper<Settings>().map(settings){
                print(deserializedSettings.lastUpdate)
                WeatherServiceWrapper.settings = deserializedSettings
            }else {
                print("loading error")
            }
        }
        catch {
            let settingsToSave = Settings.byDefault
            //so, file doesn't exist we need create new one
            if let serializedSettings = Mapper().toJSONString(Settings.byDefault){
                do {
                    try serializedSettings.writeToURL(WeatherServiceWrapper.PATH, atomically: true, encoding: NSUTF8StringEncoding)
                    WeatherServiceWrapper.settings = settingsToSave
                }catch {
                    print("cant write settings")
                }
            }
            
        }
        /*dispatch_async(weatherQ) { () -> Void in
        
        }*/
        
    }
    
    func saveSettings(){
        if WeatherServiceWrapper.settings != nil {
            if let serializedSettings = Mapper().toJSONString(WeatherServiceWrapper.settings!){
                do {
                    try serializedSettings.writeToURL(WeatherServiceWrapper.PATH, atomically: true, encoding: NSUTF8StringEncoding)
                }catch {
                    print("cant write settings")
                }
            }
        }
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
