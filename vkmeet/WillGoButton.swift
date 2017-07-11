//
//  WillGoButton.swift
//  vkmeet
//
//  Created by user on 5/26/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class WillGoButton: UIButton {
    
    
    var willgoID: String = ""
    
    var status: Bool = false
    
    let activeColor = UIColor.rgb(red: 76, green: 163, blue: 248)
    let passiveColor = UIColor.rgb(red: 202, green: 219, blue: 236)
    
    
    func statusToogle() -> Bool {
        var value = self.status
        value = !value
        return value
    }
    
}
