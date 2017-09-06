//
//  WeatherServiceInfo.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol WeatherServiceDelegate:class {
    func fetchWeather(result:WeatherResult)
}

public enum WeatherResult{
    case Success(weatherForCity:Weather?)
    case Failure(ErrorType)
}
public enum WeatherError:ErrorType {
    case JSONConvertError
    case BadRequestError
}

public enum WeatherMethod: String {
    case GetWeather = "weather"
    case SeveralCity = "group"
    case Forecast = "forecast"
}

public enum Units:String {
    case Celsius = "metric"
    case Fahreinheit = "imperial"
}




public class WeatherAPIServiceInfo: NSObject {
    
    public static var unitSystem:Units = .Celsius
    public static var language:Language = .English
    
    let sharedSesion:NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: sessionConfig)
        }()
    
    public static let APP_KEY = "19e47aa5161a4692b93fdc510cf800ff"
    public static let BASE_URL = "http://api.openweathermap.org/data/2.5/"
    public static var cityID:Int = -1
    
    public weak var delegate:WeatherServiceDelegate?
    
    private static func weatherFromJSON(data:NSData) -> WeatherResult {
        
        print("printing response from server for city")
        var weather:Weather? = nil
        
        let json = JSON(data: data)
        
        if json["cod"].intValue != 200 {
            return .Failure(WeatherError.BadRequestError)
        }
        if let forecastJSON = json["list"].array {
            //extrat weather for today and for yesterday
            for (index, forecastJSONItem) in forecastJSON.enumerate() {
                
                let interval = (forecastJSONItem["dt"]).doubleValue
                let date = NSDate(timeIntervalSince1970: interval)
                
                if date.isToday() {
                    if index == 0 {
                        weather = Weather.weatherFromJSON(forecastJSONItem)
                        print("today")
                    }else {
                        if let forecastObject = Forecast.forecastJSON(forecastJSONItem){
                            weather?.forecast.append(forecastObject)
                        }
                        print("today forecast ")
                    }
                }else {
                    if let forecastObject = Forecast.forecastJSON(forecastJSONItem){
                        weather?.forecast.append(forecastObject)
                    }
                    print("forecast for other day")
                }
            }
        }else {
            //can't conver JSON
            return .Failure(WeatherError.JSONConvertError)
        }
        
        weather?.cityId = WeatherAPIServiceInfo.cityID
        return .Success(weatherForCity:weather)
        
    }
    
    private func processRecentWeatherResult(data data:NSData?, error:NSError?) -> WeatherResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return WeatherAPIServiceInfo.weatherFromJSON(jsonData)
    }
    
    private func updateWeather(forURL url:NSURL!){
        guard let delegate = self.delegate else {
            return
        }
        let request = NSURLRequest(URL: url)
        let task = sharedSesion.dataTaskWithRequest(request) { [unowned self](data, response, error) -> Void in
            let result = self.processRecentWeatherResult(data: data, error: error)
            delegate.fetchWeather(result)
        }
        task.resume()
    }
    
    static func weatherURL(method method:WeatherMethod, params:[String:String]?) -> NSURL {
        let components = NSURLComponents(string: self.BASE_URL + method.rawValue)!
        var queryItems = [NSURLQueryItem]()
        
        let defaults = NSURLQueryItem(name: "APPID", value: APP_KEY)
        queryItems.append(defaults)
        
        if let parameters = params {
            for (key, value) in parameters {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        queryItems.append(NSURLQueryItem(name: "units", value: WeatherAPIServiceInfo.unitSystem.rawValue))
        queryItems.append(NSURLQueryItem(name: "lang", value: WeatherAPIServiceInfo.language.rawValue))
        
        components.queryItems = queryItems
        
        return components.URL!
    }
    
}
extension WeatherAPIServiceInfo {
    
    public func updateWeather(forCity city:String){
        if let cityName = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()){
            let params = [
                "q":cityName
            ]
            
            let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params)
            print(url)
            updateWeather(forURL: url)
        }
    }
    
    public func updateWeather(forCityID id:Int){
        let params = [
            "id":String(id)
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    
    public func updateWeatherForLocation(id:Int, lat:Double, lon:Double){
        WeatherAPIServiceInfo.cityID = id
        let params = [
            "lat":"\(lat)",
            "lon":"\(lon)"
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    
}
