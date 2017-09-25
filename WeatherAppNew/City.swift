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
import SwiftyJSON

@objc public class City: NSObject, NSCoding {
    var name:String = ""
    var id:Int = -1
    var country:String = ""
    var coords:CLLocationCoordinate2D?
    var forecast:[Forecast]? = []
    var isCurrentLocation:Bool = false
    
    init(id:Int, name:String, country:String, coords:CLLocationCoordinate2D){
        self.name = name
        self.id = id
        self.country = country
        self.coords = coords
    }
    convenience init(withLocation coords:CLLocationCoordinate2D){
        let name = ""
        let id = -1
        let country = "" 
        self.init(id: id,name: name, country: country, coords: coords)
    }
    convenience init(cityFromJSON json:JSON){
        let name = json["name"].string!
        let id = json["id"].int!
        let country = json["country"].string!
        let coord = json["coord"]
        let coords = CLLocationCoordinate2D(latitude: coord["lon"].double!, longitude: coord["lat"].double!)
        self.init(id: id,name: name, country: country, coords: coords)
    }

    
    required public init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        id = Int(aDecoder.decodeIntForKey("id"))
        country = aDecoder.decodeObjectForKey("country") as! String
        if let locationDict = aDecoder.decodeObjectForKey("location") as? [String : NSNumber]{
            let userLat = locationDict["lat"]?.doubleValue ?? 0
            let userLng = locationDict["lng"]?.doubleValue ?? 0
            coords = CLLocationCoordinate2D(latitude: userLat, longitude: userLng)
        }
        isCurrentLocation = aDecoder.decodeBoolForKey("isCurrentLocation")
        //forecast = aDecoder.decodeObjectForKey("forecast") as? [Forecast]
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(country, forKey: "country")
        //First Convert it to NSNumber.
        let lat : NSNumber = NSNumber(double: coords!.latitude)
        let lng : NSNumber = NSNumber(double: coords!.longitude)
        //Store it into Dictionary
        let locationDict = ["lat": lat, "lng": lng]
        aCoder.encodeObject(locationDict, forKey: "location")
        
        aCoder.encodeBool(isCurrentLocation, forKey: "isCurrentLocation")
        //aCoder.encodeObject(forecast, forKey: "forecast")
    }
}
