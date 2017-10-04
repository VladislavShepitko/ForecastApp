//
//  CitiesService.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/24/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import CoreLocation

protocol CitiesServiceDelegate:class {
    func citiesDidLoad(citiesService:CitiesService?, cities:[City]?)
    func citiesDidFetched(citiesService:CitiesService?, cities:[City]?, forName name:String)
}

class CitiesService: NSObject {
    
    weak var delegate:CitiesServiceDelegate?
    
    var cities:[City] {
        return CitiesService._cities
    }
    var filteredCities: [City]? {
        return CitiesService._filteredCities
    }
    var areLoaded:Bool {
        return CitiesService._areLoaded
    }
    
    private static var _cities:[City] = []
    private static var _filteredCities:[City]? = []
    private static var _areLoaded:Bool = false
    
    override init(){
        super.init()
    }
    private let queue = dispatch_queue_create("com.weatherApp.loadQueue", DISPATCH_QUEUE_CONCURRENT)
    
    func loadSities(){
        dispatch_async(queue) { [weak self] in
            if let path = NSBundle.mainBundle().URLForResource("city.list", withExtension: "json"){
                do {
                    
                    let cityData = try NSData(contentsOfURL: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                    let JSONResult = try NSJSONSerialization.JSONObjectWithData(cityData, options: .MutableContainers)
                    if let citiesInJSON = JSONResult as? [NSDictionary] {
                        for JSONData in citiesInJSON {
                            if let id = JSONData["id"] as? Int,
                            let name = JSONData["name"] as? String,
                            let country = JSONData["country"] as? String,
                            let coordJSONData = JSONData["coord"] as? NSDictionary,
                            let lat = coordJSONData["lat"] as? Double,
                            let lon = coordJSONData["lon"] as? Double {
                                let city = City(id: id, name: name, country: country, coords: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                                
                                CitiesService._cities.append(city) 
                            }
                            
                        }
                        CitiesService._areLoaded = true
                        if self?.delegate != nil {
                            self?.delegate?.citiesDidLoad(self,cities: CitiesService._cities)
                        }
                        print("loaded cities: \(CitiesService._cities.count)")
                    }else {
                        print("error")
                    }
                }catch{
                    print("Error")
                }
            }
        }
    }
    func filterCityByName(cityName name: String){
        dispatch_async(queue) { [weak self] in
            CitiesService._filteredCities = CitiesService._cities.filter { (city) -> Bool in
                //print("\(city.name) : \(name.lowercaseString)")
                return city.name.lowercaseString.containsString(name.lowercaseString)
            }
            if self?.delegate != nil {
                self?.delegate?.citiesDidFetched(self, cities: CitiesService._filteredCities, forName: name)
            }
        }
    }
    
    func CleanFiltered(){
        CitiesService._filteredCities?.removeAll()
    }
    
    func CleanAll(){
        CitiesService._cities.removeAll()
        CitiesService._filteredCities?.removeAll()
    }
}
