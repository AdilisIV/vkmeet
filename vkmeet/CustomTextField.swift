//
//  CustomTextField.swift
//  vkmeet
//
//  Created by user on 3/18/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}
