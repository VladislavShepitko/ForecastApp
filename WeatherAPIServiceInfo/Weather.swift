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