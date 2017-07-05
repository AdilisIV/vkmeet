//
//  CustomFloatingButton.swift
//  vkmeet
//
//  Created by user on 6/29/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class CustomFloatingButton: UIView {

    func setupFloatingButtonView(parrentView: UIView) {
        
        let actionButton = DTZFloatingActionButton(frame:CGRect(
            x: parrentView.frame.size.width - 56 - 14,
            y: parrentView.frame.size.height - 56 - 14,
            width: 56,
            height: 56
        ))
        
    }

}
