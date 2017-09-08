//
//  WeatherSevar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
import ObjectMapper

final class SaveService {
    class var shared:SaveService{
        struct SaveServiceWrapper{
            static let singleton:SaveService = SaveService()
        }
        return SaveServiceWrapper.singleton
    }
    //queue for loading and saving settings
    private let saveQ = dispatch_queue_create("saveQ",DISPATCH_QUEUE_CONCURRENT)
    //path to settings files
    private static let FILE = "settings.json"
    static let DIRECTORY = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
    static let PATH = NSURL(fileURLWithPath: DIRECTORY!).URLByAppendingPathComponent(FILE)
    
    //settings
    private (set) var settings:Settings!
    
    
    //cache for forecasts
    
    
    
    
    private init(){
        settings = Settings.byDefault
    }
    
    func load(){
        dispatch_async(saveQ,{ _ in
            do {
                let path = SaveService.PATH
                let settingsJSON = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print("from file: \(settingsJSON)")
                if let deserializedSettings = Mapper<Settings>().map(settingsJSON){
                    print(deserializedSettings.lastUpdate)
                    self.settings = deserializedSettings
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
    private func saveSettins(setting:Settings) {
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
            self.saveSettins(self.settings)
        })
    }
        
}