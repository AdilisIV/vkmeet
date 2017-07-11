//
//  UserDefaultsService.swift
//  vkmeet
//
//  Created by user on 7/9/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation

class UserDefaultsService {
    
    static var isNotificationEnabled: Bool! {
        get {
            return UserDefaults.standard.value(forKey: "notification") as? Bool
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "notification")
            UserDefaults.standard.synchronize()
        }
    }
    
    //self.defaults.set(self.willgoEventsID, forKey: "willgoevents")
    
    static var willgoEventIDs: [String]! {
        get {
            return UserDefaults.standard.array(forKey: "willgoevents") as! [String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "willgoevents")
            UserDefaults.standard.synchronize()
        }
    }
    
}
