//
//  WeatherSevar.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/8/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

final class SaveService {
    class var shared:SaveService{
        struct SaveServiceWrapper{
            static let singleton:SaveService = SaveService()
        }
        return SaveServiceWrapper.singleton
    }
    private static let saveQ = dispatch_queue_create("saveQ",DISPATCH_QUEUE_CONCURRENT)
    
    private static let FILE = "settings.json"
    static let DIRECTORY = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
    static let PATH = NSURL(fileURLWithPath: DIRECTORY!).URLByAppendingPathComponent(FILE)
    
    
    private (set) var settings:Settings?
    
    private init(){
        settings = Settings.byDefault
    }
    
    func load(){
        dispatch_async(saveQ,{ _ in
            do {
                let path = SaveService.PATH
                let settings = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                print("from file: \(settings)")
                if let deserializedSettings = Mapper<Settings>().map(settings){
                    print(deserializedSettings.lastUpdate)
                    settings = deserializedSettings
                }else {
                    print("loading error")
                }
            }
            catch {
                let settingsToSave = Settings.byDefault
                saveSettins(setting:settingsToSave)
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
        
    }
        
}