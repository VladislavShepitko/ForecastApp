//
//  JSONSerialisation.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/31/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation


public class JSNONSerializer {
    public enum JSONSerializerError: ErrorType {
        case jsonIsNotDictionary
        case jsonIsNotArray
        case jsonIsNotValid
    }
    static func toDictionary(jsonString:String) throws -> NSDictionary {
        if let dict = try jsonToAnyObject(jsonString) as? NSDictionary{
            return dict
        }else{
            throw JSONSerializerError.jsonIsNotDictionary
        }
    }
    static func toArray(jsonString:String) throws -> NSArray {
        if let array = try jsonToAnyObject(jsonString) as? NSArray{
            return array
        }else{
            throw JSONSerializerError.jsonIsNotArray
        }
    }
    static func jsonToAnyObject(jsonString:String) throws -> Any? {
        var any: Any?
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding){
            do {
                any = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            }catch let error as NSError {
                let sError = String(error)
                print(sError)
                throw JSONSerializerError.jsonIsNotValid
            }
        }
        return any
    }
    typealias childNode = (label:String?, value: Any)
    
    static func toJSON(object :Any, prettify:Bool = false) -> String{
        var json = ""
        if !(object is Array<Any>){
            json += "{"
        }
        let mirror = Mirror(reflecting: object)
        var children = [childNode]()
        
        if let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children){
            children += mirrorChildrenCollection
        } else {
            //here can be error
            let mirrorIndexCollection = AnyForwardCollection(mirror.children)
            children += mirrorIndexCollection
        }
        var currentMirror = mirror
        while let superclassChildren = currentMirror.superclassMirror()?.children {
            let randomCollection = AnyRandomAccessCollection(superclassChildren)!
            children += randomCollection
            currentMirror = currentMirror.superclassMirror()!
        }
        var filteredChildren = [childNode]()
        
        for (label, value) in children {
            if let label = label {
                if label.containsString("notMapped_"){
                    filteredChildren.append((label, value))
                }
            }
            else {
                filteredChildren.append((nil, value))
            }
        }
        var skip = false
        var size = filteredChildren.count
        var index = 0
        var first = true
        
        for (label, value) in filteredChildren {
            let propertyName = label
            let property = Mirror(reflecting: value)
            var handledValue = String()
            
            if propertyName != nil && propertyName == "some" && property.displayStyle == Mirror.DisplayStyle.Struct{
                handledValue = toJSON(value)
                skip = true
                
            }else if (value is Int ||
                value is Int32 ||
                value is Int64 ||
                value is Double ||
                value is Float ||
                value is Bool) && property.displayStyle != Mirror.DisplayStyle.Optional {
                    handledValue = String(value)
            }
            else if let array = value as? [Int?]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if let array = value as? [Double?]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if let array = value as? [Float?]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if let array = value as? [Bool?]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if let array = value as? [String?]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += value != nil ? "\"\(value!)\"" : "null"
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            } else if let array = value as? [String]{
                handledValue += "["
                for (index, value)in array.enumerate() {
                    handledValue += "\"\(value)\""
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if let array = value as? NSArray {
                handledValue += "["
                for (index, value)in array.enumerate() {
                    if  !(value is Int) &&
                        !(value is Int32) &&
                        !(value is Int64) &&
                        !(value is Double) &&
                        !(value is Float) &&
                        !(value is Bool) &&
                        !(value is String){
                            handledValue += toJSON(value)
                    }else {
                        handledValue += "\(value)"
                    }
                    handledValue += (index < array.count - 1) ? ", " : ""
                }
                handledValue += "]"
            }else if property.displayStyle == Mirror.DisplayStyle.Class ||
                property.displayStyle == Mirror.DisplayStyle.Struct ||
                String(value).containsString("#"){
                    handledValue = toJSON(value)
            }
            else if property.displayStyle == Mirror.DisplayStyle.Optional {
                let str = String(value)
                if str != "nil"{
                    //str.characters.indices.
                    //str.substringWithRange(<#T##aRange: Range<Index>##Range<Index>#>)
                    //handledValue = String(str).substringWithRange(range)
                }else {
                    handledValue = "null"
                }
            }else {
                handledValue = String(value) != "nil" ? "\"\(value)\"" : "null"
            }
            if !skip {
                if let propertyName = propertyName {
                    json += "\"\(propertyName)\": \(handledValue)" + (index < size - 1 ? ", " : "")
                }else {
                    if first {
                        json += "["
                        first = false
                    }
                    json += "\(handledValue)" + (index < size - 1 ? ", " : "]")
                }
            }else {
                json += "\"\(propertyName)\": \(handledValue)" + (index < size - 1 ? ", " : "")
            }
            index += 1
        }
        if !skip {
            if !(object is Array<Any>){
                json += "}"
            }
        }
        if prettify {
            let data = json.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
            let prettyJSON = try! NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
            json = NSString(data: prettyJSON, encoding: NSUTF8StringEncoding) as! String
        }
        
        return json
        
    }
}
