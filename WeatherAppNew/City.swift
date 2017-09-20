//
//  City.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/6/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import CoreLocation
import WeatherAPIServiceInfo


class City {
    var name:String = ""
    var id:Int = -1
    var country:String = ""
    var coords:CLLocationCoordinate2D?
    var weather:Weather?
    var isCurrentLocation:Bool = false
    
    init(id:Int, name:String, country:String, coords:(lat:Double,lon:Double)){
        self.name = name
        self.id = id
        self.country = country
        self.coords = CLLocationCoordinate2D(latitude: coords.lat, longitude: coords.lon)
    }
}
 