//
//  Repository.swift
//  vkmeet
//
//  Created by user on 6/21/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Source {
    case server
    case database
}


class Repository {
    
    // Fetchs all cities from server
    func fetchCities(handler: @escaping ([City], Error?) -> Void) {
        Alamofire.request("http://onetwomeet.ru/cities").responseJSON { (responseData) -> Void in
            switch responseData.result {
            case .success:
                let swiftyJsonVar = JSON(responseData.result.value!)
                var arrRes = [[String:AnyObject]]()
                var citiesData = [City]()
                
                if let resData = swiftyJsonVar.arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                }
                for i in 0..<arrRes.count {
                    let id = arrRes[i]["id"]
                    let title = arrRes[i]["name"]
                    let cityObject = City.init(id: id as! String, title: title as! String)
                    citiesData.append(cityObject)
                    print(citiesData[i].title)
                }
                handler(citiesData, nil)
                
            case .failure(let error):
                print(error)
                handler([], error)
            }
        }
    }
    
    // Extract/Update cities from web
    func extractCities(handler: @escaping ([City], Error?, Source) -> Void) {
        fetchCities { (cities, error) in
            handler(cities, error, .server)
        }
    }
    
    
}
