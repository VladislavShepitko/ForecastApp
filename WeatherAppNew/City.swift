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
import ObjectMapper

class City: Mappable  {
    var name:String!
    var id:Int!
    var country:String!
    var coords:CLLocationCoordinate2D!
    var weather:Weather?
    
    init(id:Int, name:String, country:String, coords:(Double,Double)){
        self.name = name
        self.id = id
        self.country = country
        self.coords = CLLocationCoordinate2D(latitude: coords.0, longitude: coords.1)
    }
    
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        country <- map["country"]
        coords <- (map["coords"],coordsTransform)
    }
}
let coordsTransform = TransformOf(fromJSON: { (value:Any?) -> CLLocationCoordinate2D? in
    guard let location = value as? NSDictionary,
        let latitude = location["lat"] as? Double,
        let longitude = location["lon"] as? Double else
    {
        return nil
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    }) { (value:CLLocationCoordinate2D?) -> Any? in
        var dict = [String:Double]()
        if let value = value {
         dict = [
            "lat":value.latitude,
            "lon":value.longitude
            ]
        }
        return dict
}

/*
let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
// transform value from String? to Int?
return Int(value!)
}, toJSON: { (value: Int?) -> String? in
// transform value from Int? to String?
if let value = value {
return String(value)
}
return nil
})

id <- (map["id"], transform)
*/
/*
extension CLLocationCoordinate2D: Convertible {
    public static func fromMap(value: Any) throws -> CLLocationCoordinate2D {
        guard let location = value as? NSDictionary,
            let latitude = location["lat"] as? Double,
            let longitude = location["lng"] as? Double else
        {
            throw MapperError.convertibleError(value: value, type: [String: Double].self)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}*/

