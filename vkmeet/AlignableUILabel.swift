//
//  AlignableUILabel.swift
//  vkmeet
//
//  Created by user on 7/15/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class AlignableUILabel: UILabel {

    override func drawText(in rect: CGRect) {
        var newRect = CGRect(x: rect.origin.x,y: rect.origin.y,width: rect.width, height: rect.height)
        let fittingSize = sizeThatFits(rect.size)
        
        if contentMode == UIViewContentMode.top {
            newRect.size.height = min(newRect.size.height, fittingSize.height)
        } else if contentMode == UIViewContentMode.bottom {
            newRect.origin.y = max(0, newRect.size.height - fittingSize.height)
        }
        
        super.drawText(in: newRect)
    }

}
