//
//  WeatherViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/1/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo

class WeatherViewModel: NSObject, WeatherServiceDelegate {
    
    var currentWeaher:Observable<Weather>?
    
    private var weathers:[Weather] = []
    
    weak var weatherService:WeatherAPIServiceInfo?
    override init() {
        super.init()
        self.currentWeaher = Observable<Weather>(value: nil)
    }
    
    
    func fetchWeather(result:WeatherResult){
        /*switch result{
        case let .Success(data):
            self.weathers = data
        case let .Failure(error):
            print(error)
        }*/
    }
}
