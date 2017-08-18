//
//  WeatherServiceInfo.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

public protocol WeatherServiceDelegate:class {
    func fetchWeather(result:WeatherResult)
}

public enum WeatherResult{
    case Success(weatherForCities:[Weather])
    case Failure(ErrorType)
}

public enum WeatherMethod: String {
    case GetWeather = "weather"
    case SeveralCity = "group"
    case Forecast = "forecast/daily"
}
public enum Units:String {
    case Celsius = "metric"
    case Fahreinheit = "imperial"
}

public final class WeatherAPIServiceInfo: NSObject {
    public class var sharedService:WeatherAPIServiceInfo {
        struct SingletonServiceWrapper{
            static let singleton = WeatherAPIServiceInfo()
        }
        return SingletonServiceWrapper.singleton
    }
    
    private override init(){
        super.init()
    }
    static var unitSystem:Units = .Celsius
    static var language:Language = .English
    
    let sharedSesion:NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: sessionConfig)
        }()
    
    static let APP_KEY = "19e47aa5161a4692b93fdc510cf800ff"
    static let BASE_URL = "http://api.openweathermap.org/data/2.5/"
    
    public weak var delegate:WeatherServiceDelegate?
    
    private static func weatherFromJSON(data:NSData) -> WeatherResult {
        do {
            let _:AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options:[])
            
            let weathers = [Weather]()
            
            return .Success(weatherForCities:weathers)
            
        }catch let error {
            return .Failure(error)
        }
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
    
    func updateWeather(forCity city:String){
        if let cityName = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()){
            let params = [
                "q":cityName
            ]
            
            let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.GetWeather, params: params)
            print(url)
            updateWeather(forURL: url)
        }
    }
    
    func updateWeather(forCityID id:Int){
        let params = [
            "id":String(id)
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.GetWeather, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    
    func updateWeather(forCityZipCode code:Int, countryCode:String){
        let params = [
            "zip":"\(code),\(countryCode)"
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.GetWeather, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    func updateWeather(forSeveralCityIds ids:[Int], countryCode:String){
        let idsString = ids.flatMap({String($0)}).joinWithSeparator(",")
        let params = [
            "id":idsString
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.SeveralCity, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    func updateWeather(forecastForCity id:Int, numberOfDays:Int){
        let params = [
            "id":String(id),
            "cnt":String(numberOfDays)
        ]
        let url = WeatherAPIServiceInfo.weatherURL(method: WeatherMethod.Forecast, params: params)
        print(url)
        updateWeather(forURL: url)
    }
    
}
