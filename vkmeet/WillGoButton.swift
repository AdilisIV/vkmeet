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
    
    let activeColor = UIColor.rgb(red: 76, green: 163, blue: 248)
    
    
    func willgoToggle(checkMark: Bool) -> Bool {
        var value = checkMark
        value = !value
        return value
    }

    
}
