//
//  City.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class City:NSObject, NSCoding, NSCopying {
    typealias Coord = (lon:Double, lat:Double)
    
    private(set) var id:Int
    private(set) var name:String
    private(set) var country:String
    private(set) var coord:Coord
    
    var lastUpdate:NSDate?
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeInt(Int32(self.id), forKey: "id")
        aCoder.encodeObject(self.country, forKey: "country")
        aCoder.encodeDouble(self.coord.lat, forKey: "lat")
        aCoder.encodeDouble(self.coord.lon, forKey: "lon")
    }
    required init?(coder aDecoder: NSCoder){
        id = aDecoder.decodeIntegerForKey("id")
        name = aDecoder.decodeObjectForKey("name") as! String
        country = aDecoder.decodeObjectForKey("country") as! String
        let lat = aDecoder.decodeDoubleForKey("lat")
        let lon = aDecoder.decodeDoubleForKey("lon")
        self.coord = (lon,lat)
    }
    
    convenience init?(cityFromDictionary dict:NSDictionary){
        
        guard let name = dict["name"] as? String,
              let id = dict["id"] as? Int,
              let country = dict["country"] as? String,
              let coord = dict["coord"] as? NSDictionary,
              let lon = coord["lon"] as? Double,
              let lat = coord["lat"] as? Double else {
               /* self.name = ""
                self.id = 0
                self.country = ""
                self.coord = (0,0)*/
                return nil
        }
        self.init(id: id, name:name, country:country, coord:(lon,lat), lastUpdate:nil)
     
    }
    
    init(id: Int, name:String, country:String, coord:Coord, lastUpdate:NSDate? = nil){
        //super.init()
        
        self.id = id
        self.name = name
        self.country = country
        self.coord = coord
        
    }
    func copyWithZone(zone: NSZone) -> AnyObject{
        return City(id: self.id, name: self.name, country: self.country, coord: self.coord, lastUpdate: nil)
    }
}

extension City{
    
    func toDictionary() -> NSDictionary {
        let dictionary = [
        "name":self.name,
        "id":self.id,
        "country":self.country,
        "coord":[
            "lon":self.coord.lon,
            "lat":self.coord.lat
            ]
        ]
        return NSDictionary(dictionary: dictionary)
    }

}