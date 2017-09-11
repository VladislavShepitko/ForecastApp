//
//  SettingsViewModel.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/11/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
/*
var notification:NotificationWrapper!
var language:Language!
var tempUnits:TempUnits!
var windSpeedUnits:WindSpeedUnits!
var citis:[City] = []
var lastUpdate:NSDate!
*/
class SettingsViewModel: NSObject {
    
    var notification: Observable<Bool>
    var notificationFrom: Observable<NSDate?>
    var notificationTo: Observable<NSDate?>
    
    var language: Observable<Language>
    var tempUnits:Observable<TempUnits>
    var windSpeedUnits:Observable<WindSpeedUnits>
    
    
    override init(){
        notification = Observable<Bool>(value: false)
        notificationFrom = Observable<NSDate?>(value:nil)
        notificationTo = Observable<NSDate?>(value:nil)
        language = Observable<Language>(value: .ENG)
        tempUnits = Observable<TempUnits>(value: .Celsius)
        windSpeedUnits = Observable<WindSpeedUnits>(value: .KilomertPerHour)
        
        super.init()
    }
    
    func setModel(model: Settings){
        switch model.notification.notification{
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
    }
}
