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

class City:NSObject {
    let name:String
    let id:Int
    let country:String
    let coords:CLLocationCoordinate2D
    var weather:Weather?
    
    init(id:Int, name:String, country:String, coords:(Double,Double)){
        self.name = name
        self.id = id
        self.country = country
        self.coords = CLLocationCoordinate2D(latitude: coords.0, longitude: coords.1)
        super.init()
    }
}


