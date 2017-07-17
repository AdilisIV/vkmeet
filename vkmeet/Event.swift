//
//  Event.swift
//  vkmeet
//
//  Created by user on 6/20/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation

class Event {
    
    var id: String
    var name: String
    var image: String
    var memb: String
    var timeStart: Int
    var activity: String
    var latitude: Double!
    var longitude: Double!
    var description: String!
    var url: URL!
    var commerce: Bool
    
    
    init(id: String, name: String, image: String, memb: String, timeStart: Int, activity: String, latitude: Double!, longitude: Double!, description: String!, url: URL!, commerce: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.memb = memb
        self.timeStart = timeStart
        self.activity = activity
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.url = url
        self.commerce = commerce
    }
    
}
