//
//  WeatherServiceWrapper.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo


final class WeatherServiceWrapper: NSObject {
    class var sharedService:WeatherServiceWrapper {
        struct SingletonServiceWrapper{
            static let singleton = WeatherServiceWrapper()
        }
        return SingletonServiceWrapper.singleton
    }
    
    private let weatherService:WeatherAPIServiceInfo = WeatherAPIServiceInfo()
    
    var allCities:[City]? = []
    var areCitiesLoaded:Bool = false
    
    private(set) var cities:[City]! = []
    private let PATH_TO_CITY_FILES = "/tmp/cities.bin"
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    
    private override init(){
        super.init()
        weatherService.delegate = self
        
    }
    func loadAllCities(completion:([City]?)->Void)
    {
        dispatch_async(self.queue) {[weak self] () -> Void in
            if let path = NSBundle.mainBundle().pathForResource("city.list", ofType: "json"){
                if let cityData = NSFileManager.defaultManager().contentsAtPath(path) {
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(cityData
                            , options: NSJSONReadingOptions.MutableContainers)
                        if let citiesJSON = jsonResult as? [NSDictionary]{
                            for cityJSON in citiesJSON{
                                if let city = City(cityFromDictionary: cityJSON){
                                    self!.allCities?.append(city)
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                                self!.areCitiesLoaded = true
                                completion(self!.allCities)
                            })
                        }else {
                            print("cannot convert JSON to array")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(nil)
                            })
                        }
                        
                    }catch let error{
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(nil)
                        })
                    }
                }
            }
        }
    }
    
    func preloadCitiesFromFile(){
        self.cities = []
        dispatch_async(self.queue) { () -> Void in
            if let loadedCities = NSKeyedUnarchiver.unarchiveObjectWithFile(self.PATH_TO_CITY_FILES) as? [City]{
                print("print loaded cities:")
                for city in loadedCities {
                    print(city)
                    self.cities.append(city)
                }
            }else {
                print("load cities error")
            }
        }
    }
    
    func saveCitiesToFile(){
        dispatch_async(self.queue) { () -> Void in
            if self.cities.count > 0 {
                if NSKeyedArchiver.archiveRootObject(self.cities, toFile: self.PATH_TO_CITY_FILES){
                    print("cities are saved")
                }else {
                    print("something wrong!")
                }
            }
        }
    }
    
    func addCity(city:City){
        self.cities.append(city)
        print("added new city:")
        //print(self.cities)
        saveCitiesToFile()
    }
    func removeCity(withIndex index:Int){
        self.cities.removeAtIndex(index)
        saveCitiesToFile()
    }
    
    func filterCitiestForRequest(forName name:String, completion:(result:[City]?)->Void){
        dispatch_async(self.queue) { () -> Void in
            if let cities = self.allCities where cities.count > 0 {
                var res = cities.filter { return $0.name.lowercaseString.hasPrefix(name.lowercaseString) }
                if res.count > 100 {
                   res = Array(res[0..<100])
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(result: res)
                })
            }else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(result: nil)
                })
            }
        }
    }
}

extension WeatherServiceWrapper : WeatherServiceDelegate{
    
    internal func fetchWeather(result:WeatherResult)
    {
        
    }
}
