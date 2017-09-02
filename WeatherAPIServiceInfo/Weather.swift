//
//  Weather.swift
//  WeatherService
//
//  Created by Vladyslav Shepitko on 8/14/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

public struct Weather {
    let description:String
    let data:NSDate
    let icon:String
    
    let main:Main
    let wind:Wind
    let system:System
    let clouds:Clouds
    
    
}
struct System {
    let countryCode:String
    let sunRise:Double
    let sunSet:Double
}

struct Main {
    let temp:Double
    let temp_min:Double
    let temp_max:Double
    let pressure:Double
    let humidity:Double
    let atmosphericLevel:Double
}
struct Wind
{
    let speed:Double
    let direction:String
}
struct Clouds {
    let value:String
    let name:String
}
/*

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


*/
