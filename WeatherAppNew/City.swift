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
struct City {
    let name:String
    let id:Int
    let country:String
    let coords:CLLocationCoordinate2D
    let weather:Weather?
}
