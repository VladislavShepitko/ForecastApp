//
//  SettingsViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/11/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import WeatherAPIServiceInfo


class SettingsViewModel: NSObject {
    
    private (set) var notification: Observable<Bool>
    private (set) var notificationFrom: Observable<NSDate?>
    private (set) var notificationTo: Observable<NSDate?>
    
    private (set) var language: Observable<Language>
    private (set) var tempUnits:Observable<Units>
    private (set) var windSpeedUnits:Observable<WindSpeedUnits>
    private (set) var cities:Observable<[City]>
    
    var settings:Settings{
        let settings = Settings()
        settings.notification =
            self.notification.value == true
            ? .On(from: notificationFrom.value!, to: notificationTo.value!)
            : .Off
        settings.language = self.language.value!
        settings.tempUnits = self.tempUnits.value!
        settings.windSpeedUnits = self.windSpeedUnits.value!
        return settings
    }
    
    override init(){
        notification = Observable<Bool>(value: false)
        notificationFrom = Observable<NSDate?>(value:nil)
        notificationTo = Observable<NSDate?>(value:nil)
        language = Observable<Language>(value: .English)
        tempUnits = Observable<Units>(value: .Celsius)
        windSpeedUnits = Observable<WindSpeedUnits>(value: .KilomertPerHour)
        cities = Observable<[City]>(value: [])
        super.init()
    }
    convenience init(settings:Settings){
        self.init()
        updateModel(settings)
    }
    
    func updateModel(model: Settings){
        switch model.notification {
        case .On(let from, let to):
            self.notification.value = true
            self.notificationFrom.value = from
            self.notificationTo.value = to
            break
        case .Off:
            self.notification.value = false
            self.notificationFrom.value = nil
            self.notificationTo.value = nil
            break
        }
        self.language.value = model.language
        self.tempUnits.value = model.tempUnits
        self.windSpeedUnits.value = model.windSpeedUnits
        self.cities.value = model.citis
    }
}
