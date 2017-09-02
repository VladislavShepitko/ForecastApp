//
//  Weather.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

struct Weather {
    var main:Main
    var forecastForWeak:[ForecastItem]

    
    struct Main {
        var minTemp:Int
        var maxTemp:Int
        var currenTemp:Int
        
        var description:String
        
        var icon:String
        
        var humidity:Float
        
        var wind:Float
        var windDirection:Float
        
        var pressure:Float
        
        var forecastForDay:[ForecastItem]
        
        var lastUpdate:NSDate
        var location:(Double,Double)
    }
    
    struct ForecastItem {
        var temp:Int
        var icon:String
        var time:NSDate
    }
}




