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
    func locationDidUpdate(service: LocationService, location: CLLocation)
}

class LocationService: NSObject {
    weak var delegate:LocationServiceDelegate?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    func fetchCurrentLocation(){        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationService : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            delegate?.locationDidUpdate(self, location: location)
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
}