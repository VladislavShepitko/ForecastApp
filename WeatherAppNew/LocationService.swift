//
//  LocationService.swift
//  Forecast
//
//  Created by Vladyslav Shepitko on 9/25/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationDidUpdate(service: LocationService, location: CLLocation?)
}

class LocationService: NSObject {
    weak var delegate:LocationServiceDelegate?
    private let locationManager = CLLocationManager()
    private static var isUpdated = false
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    func fetchCurrentLocation(){
        LocationService.isUpdated = false
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
}

extension LocationService : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            if !LocationService.isUpdated{
                delegate?.locationDidUpdate(self, location: location)
                LocationService.isUpdated = true
                struct Static {
                    static var i = 0
                }
                Static.i++
                print("update \(Static.i) times")
            }
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
        delegate?.locationDidUpdate(self, location: nil)
    }
}