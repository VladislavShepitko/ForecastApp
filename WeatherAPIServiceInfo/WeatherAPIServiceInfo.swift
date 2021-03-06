//
//  WeatherServiceInfo.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

public protocol WeatherServiceDelegate:class {
    func fetchWeather(result:WeatherResult)
}

public typealias CityData = (cityID:Int, cityName:String, cityCoords:CLLocationCoordinate2D)

public enum WeatherResult{
    case Success(weather:[Forecast],CityData)
    case Failure(ErrorType)
}
public enum WeatherError:ErrorType {
    case JSONConvertError
    case BadRequestError
    case WeatherForCityDoesntFound
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
    
    public weak var delegate:WeatherServiceDelegate?
    
    private static func weatherFromJSON(data:NSData) -> WeatherResult {
        
        print("printing response from server for city")
        var forecast = [Forecast]()
        
        let json = JSON(data: data)
        if json["cod"].intValue != 200 {
            return .Failure(WeatherError.BadRequestError)
        }
        guard let cityID = (json["city"]["id"]).int,
        let cityName = (json["city"]["name"]).string,
        let cityLat = (json["city"]["coord"]["lat"]).double,
        let cityLon = (json["city"]["coord"]["lon"]).double else {
            return .Failure(WeatherError.WeatherForCityDoesntFound)
        }
        
        if let forecastJSON = json["list"].array {
             for forecastJSONItem in forecastJSON {
                forecast.append(Forecast(json: forecastJSONItem))
            }            
        }else {
            //can't conver JSON
            return .Failure(WeatherError.JSONConvertError)
        }
        let data = CityData(cityID,cityName, CLLocationCoordinate2D(latitude: cityLat, longitude: cityLon))
        return .Success(weather:forecast,data)
        
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
    public func updateWeather(forCityID id:Int){
        let params = [
            "id":String(id)
        ]
        //updateWeather(forURL: WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.GetWeather, params: params))
        updateWeather(forURL: WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params))
    }
    
    public func updateWeatherForLocation(lat:Double, lon:Double){
        let params = [
            "lat":"\(lat)",
            "lon":"\(lon)"
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params)
        print("\(url)")
        updateWeather(forURL: url)
    }
    
}
