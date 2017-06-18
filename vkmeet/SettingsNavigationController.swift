//
//  SettingsNavigationController.swift
//  vkmeet
//
//  Created by user on 3/18/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationBar.barTintColor = UIColor(red: 23/255.0, green: 146/255.0, blue: 164/255.0, alpha: 1.0)
        //self.navigationBar.tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
