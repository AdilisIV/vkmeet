//
//  UserDefaultsService.swift
//  vkmeet
//
//  Created by user on 7/9/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation

class UserDefaultsService {
    
    static var userCity: String! {
        get {
            if let userCityDef = UserDefaults.standard.string(forKey: "city") {
                return userCityDef 
            } else { return "" }
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "city")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isNotificationEnabled: Bool! {
        get {
            return UserDefaults.standard.value(forKey: "notification") as? Bool
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "notification")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var willgoEventIDs: [String]! {
        get {
            if let willgoeventsUserDef = UserDefaults.standard.array(forKey: "willgoevents") {
                return willgoeventsUserDef as! [String]
            } else { return [] }
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "willgoevents")
            UserDefaults.standard.synchronize()
        }
    }
    
}
