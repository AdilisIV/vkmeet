//
//  LiveViewController.swift
//  vkmeet
//
//  Created by user on 6/25/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startLoadIndication() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopLoadIndication() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
