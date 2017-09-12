//
//  WeatherSevar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import ObjectMapper
enum SettingsKeys: String{
    case Notification
    case NotificationFromDate
    case NotificationToDate
    case Language
    case Temperature
    case WindSpeed
}

final class SaveService {
    //singleton object
    class var shared:SaveService{
        struct SaveServiceWrapper{
            static let singleton:SaveService = SaveService()
        }
        return SaveServiceWrapper.singleton
    }
    //Path to settings file in documents diractory
    private static let file = "settings.json"
    private static let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
    private lazy var path = {
        return NSURL(fileURLWithPath: directory).URLByAppendingPathComponent(file)
        }()
    
    //queue for loading and saving settings
    private let queue = dispatch_queue_create("com.svapp.saveQ",DISPATCH_QUEUE_SERIAL)
    
    //settings
    let model:SettingsViewModel
    
    
    private init(){
        self.model = SettingsViewModel(settings: .byDefault)
        
        self.model.notification.subscribe { [weak self] value in
            self?.updateModel()
        }
        self.model.language.subscribe { [weak self] value in
            self?.updateModel()
        }
        self.model.tempUnits.subscribe { [weak self] value in
            self?.updateModel()
        }
        self.model.windSpeedUnits.subscribe { [weak self] value in
            self?.updateModel()
        }
        
    }
    
    func updateModel(){
        save()
    }
    func load(){
        dispatch_async(queue,{ _ in
            do {
                let path = path
                let settingsJSON = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print("from file: \(settingsJSON)")
                if let deserializedSettings = Mapper<Settings>().map(settingsJSON){
                    self.model.updateModel(deserializedSettings)
                }else {
                    print("loading error")
                }
            } catch {
                let settingsToSave = Settings.byDefault
                self.saveSettins(settingsToSave)
            }
        })
    }
    private func saveSettins(settings:Settings) {
        if let serializedSettings = Mapper().toJSONString(settings){
            do {
                try serializedSettings.writeToURL(path, atomically: true, encoding: NSUTF8StringEncoding)
            }catch {
                print("cant write settings")
            }
        }
    }
    func save(){
        dispatch_async(queue,{ _ in
            self.saveSettins(self.model.settings)
        })
    }
    
    /*
    
    //path to settings files
    
    
    
    private init(){
        self.model = SettingsViewModel(settings: .byDefault)
    }
    
    func load(){
        dispatch_async(saveQ,{ _ in
            do {
                let path = SaveService.PATH
                let settingsJSON = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print("from file: \(settingsJSON)")
                if let deserializedSettings = Mapper<Settings>().map(settingsJSON){
                    self.model.updateModel(deserializedSettings)
                }else {
                    print("loading error")
                }
            }
            catch {
                let settingsToSave = Settings.byDefault
                self.saveSettins(settingsToSave)
            }
        })
    }
    
    private func saveSettins(settings:Settings) {
        if let serializedSettings = Mapper().toJSONString(settings){
            do {
                try serializedSettings.writeToURL(SaveService.PATH, atomically: true, encoding: NSUTF8StringEncoding)
            }catch {
                print("cant write settings")
            }
        }
    }
    func save(){
        dispatch_async(saveQ,{ _ in            
            self.saveSettins(self.model.settings)
        })
    }
    */
}