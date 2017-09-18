//
//  sFont.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/16/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
let CLIMACONS_FONT = "Climacons-Font"

enum Climacons: String {
    
    case Cloud                   = "!"
    case CloudSun                = "\""
    case CloudMoon               = "#"
    
    case Rain                    = "$"
    case RainSun                 = "%"
    case RainMoon                = "&"
    
    case RainAlt                 = "\\"
    case RainSunAlt              = "("
    case RainMoonAlt             = ")"
    
    case Downpour                = "*"
    case DownpourSun             = "+"
    case DownpourMoon            = ""
    
    case Drizzle                 = "-"
    case DrizzleSun              = "."
    case DrizzleMoon             = "/"
    
    case Sleet                   = "0"
    case SleetSun                = "1"
    case SleetMoon               = "2"
    
    case Hail                    = "3"
    case HailSun                 = "4"
    case HailMoon                = "5"
    
    case Flurries                = "6"
    case FlurriesSun             = "7"
    case FlurriesMoon            = "8"
    
    case Snow                    = "9"
    case SnowSun                 = ":"
    case SnowMoon                = ";"
    
    case Fog                     = "<"
    case FogSun                  = "="
    case FogMoon                 = ">"
    
    case Haze                    = "?"
    case HazeSun                 = "@"
    case HazeMoon                = "A"
    
    case Wind                    = "B"
    case WindCloud               = "C"
    case WindCloudSun            = "D"
    case WindCloudMoon           = "E"
    
    case Lightning               = "F"
    case LightningSun            = "G"
    case LightningMoon           = "H"
    
    case Sun                     = "I"
    case Sunset                  = "J"
    case Sunrise                 = "K"
    case SunLow                  = "L"
    case SunLower                = "M"
    
    case Moon                    = "N"
    case MoonNew                 = "O"
    case MoonWaxingCrescent      = "P"
    case MoonWaxingQuarter       = "Q"
    case MoonWaxingGibbous       = "R"
    case MoonFull                = "S"
    case MoonWaningGibbous       = "T"
    case MoonWaningQuarter       = "U"
    case MoonWaningCrescent      = "V"
    
    case Snowflake               = "W"
    case Tornado                 = "X"
    
    case Thermometer             = "Y"
    case ThermometerLow          = "Z"
    case ThermometerMediumLoew   = "["
    //case ThermometerMediumHigh   = "\\"
    case ThermometerHigh         = "]"
    case ThermometerFull         = "^"
    case Celsius                 = "_"
    //case Fahrenheit              = "\""
    case Compass                 = "a"
    case CompassNorth            = "b"
    case CompassEast             = "c"
    case CompassSouth            = "d"
    case CompassWest             = "e"
    
    case Umbrella                = "f"
    case Sunglasses              = "g"
    
    case CloudRefresh            = "h"
    case CloudUp                 = "i"
    case CloudDown               = "j"
}
