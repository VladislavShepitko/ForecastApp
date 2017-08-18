//
//  WeatherServiceWrapper.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo

class WeatherServiceWrapper: NSObject {
    let weatherService = WeatherAPIServiceInfo.sharedService
    override init(){
        super.init()
        weatherService.da
    }
}
extension WeatherAPIServiceInfo : WeatherServiceDelegate{
    public func fetchWeather(result:WeatherResult)
    {
        
    }
}
