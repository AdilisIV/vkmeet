//
//  MeetWayAPIWorker.swift
//  vkmeet
//
//  Created by user on 6/21/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MeetWayAPIWorker {
    
    
    class func citiesGet() {
        
        //var citiesData = [City]()
        
        Alamofire.request("http://onetwomeet.ru/cities").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                var arrRes = [[String:AnyObject]]()
                if let resData = swiftyJsonVar.arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    //Repository.storeEvent(arrRes: arrRes)
                }
                
                
            }
        }
        
    }
    
    
}
