//
//  JsonConverters.swift
//  HuaweiBaseline
//
//  Created by Krijn Schaap on 02/07/2018.
//  Copyright © 2018 Stoneroos. All rights reserved.
//

import Foundation
import Gloss

extension Gloss.Encoder {
    public static func encode(dateAsStringForKey key: String) -> (Date?) -> JSON? {
        return {
            date in
            
            if let date = date {
                let secondsSince1970: Int64 = Int64(date.timeIntervalSince1970)
                return [key : String(secondsSince1970 * 1000)]
            }
            
            return nil
        }
    }
    
    public static func encode(urlArrayForKey key: String) -> ([URL]?) -> JSON? {
        return {
            urlArray in
            
            if let urlArray = urlArray {
                let urls: [String] = urlArray.map { $0.absoluteString }
                return [key : urls]
            }
            
            return nil
        }
    }
}
extension Gloss.Decoder {
    
    static func decodeNumberFromString(key: String, json: JSON) -> Int? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let stringValue = json[key] as? String, let intValue = Int(stringValue) {
            return intValue
        }
        
        if let intValue = json[key] as? Int {
            return intValue
        }
        
        return nil
    }
    
    static func decodeNumberFromStringArray(key: String, json: JSON) -> [Int]? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let array = json[key] as? [Any?] {
            var result: [Int] = []
            
            array.forEach {
                if let stringValue = $0 as? String, let intValue = Int(stringValue) {
                    result.append(intValue)
                }
                
                if let intValue = $0 as? Int {
                    result.append(intValue)
                }
            }
            
            return result
        }
        
        return nil
    }
    
    static func decodeDateFromString(key: String, json: JSON) -> Date? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let stringValue = json[key] as? String, let longValue = Int64(stringValue) {
            let seconds = longValue / 1000
            return Date(timeIntervalSince1970: TimeInterval(seconds))
        }
        
        return nil
    }
    
    static func decodeFloatFromString(key: String, json: JSON) -> Float? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let stringValue = json[key] as? String, let floatValue = Float(stringValue) {
            return floatValue
        }
        
        if let floatValue = json[key] as? Float {
            return floatValue
        }
        
        return nil
    }
    
    static func decodeBooleanFromNumberString(key: String, json: JSON) -> Bool? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let stringValue = json[key] as? String, let intValue = Int(stringValue) {
            return intValue == 1
        }
        
        if let intValue = json[key] as? Int {
            return intValue == 1
        }
        
        if let boolValue = json[key] as? Bool {
            return boolValue
        }
        
        return nil
    }
    
    static func decodeKeyValue(key: String, json: JSON) -> [String: [String]]? {
        let data = json[key]
        if (data == nil) { return nil }
        
        if let fields = json[key] as? [Any] {
            var result: [String: [String]] = [:]
            fields.forEach {
                if let keyValue = $0 as? [String: Any], let key = keyValue["key"] as? String, let values = keyValue["values"] as? [String] {
                    result[key] = values
                }
            }
            
            return result
        }
        
        return nil
    }
}
