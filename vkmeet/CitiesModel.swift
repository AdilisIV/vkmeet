//
//  CitiesModel.swift
//  vkmeet
//
//  Created by user on 1/18/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation

class CitiesModel: NSObject {
    let id: String
    let title: String
    
    override var description: String {
        return "id: \(id), Title: \(title)\n"
    }
    
    init(id: String?, title: String?) {
        self.id = id ?? ""
        self.title = title ?? ""
    }
}
