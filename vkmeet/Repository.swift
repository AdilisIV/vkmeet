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
    
    // Fetchs all events from server
    func fetchAllEvents(for city: String, handler: @escaping ([Event], Error?) -> Void) {
        Alamofire.request("http://onetwomeet.ru/events/\(city)").responseJSON { (responseData) -> Void in
            switch responseData.result {
            case .success:
                let swiftyJsonVar = JSON(responseData.result.value!)
                var arrRes = [[String:AnyObject]]()
                var eventsArr = [Event]()
                
                if let resData = swiftyJsonVar.arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                for i in 0..<arrRes.count {
                    let id = arrRes[i]["id"]
                    let title = arrRes[i]["name"]
                    let activity = arrRes[i]["activity"]
                    let img = arrRes[i]["photo"]
                    let dateStart = arrRes[i]["start"]
                    let memb = arrRes[i]["members"]
                    
                    let eventObject = Event.init(id: id as! String, name: title as! String, image: img as! String, memb: "Участников: \(memb!)", timeStart: dateStart as! Int, activity: activity as! String, latitude: nil, longitude: nil, description: nil, url: nil)
                    eventsArr.append(eventObject)
                }
                handler(eventsArr, nil)
                
            case .failure(let error):
                handler([], error)
            }
            
        }
    }
    
    // Fetchs event's description from server
    func fetchEvent(with eventID: String, handler: @escaping (Event?, Error?) -> Void) {
        Alamofire.request("http://onetwomeet.ru/events/eventbyid/\(eventID)").responseJSON { (responseData) -> Void in
            switch responseData.result {
            case .success:
                let swiftyJsonVar = JSON(responseData.result.value!)
                var arrRes = [[String:AnyObject]]()
                if let resData = swiftyJsonVar.arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                let id = arrRes[0]["id"]
                let title = arrRes[0]["name"]
                let activity = arrRes[0]["activity"]
                let start = arrRes[0]["start"]
                let img = arrRes[0]["photo"]
                let memb = arrRes[0]["members"]
                let latitude = arrRes[0]["latitude"]
                let longitude = arrRes[0]["longitude"]
                let description = arrRes[0]["description"]
                let url = arrRes[0]["screenname"]
                let nsurl = URL(string: url as! String)
                
                let eventsObject = Event.init(id: id as! String, name: title as! String, image: img as! String, memb: "Участников: \(memb!)", timeStart: start as! Int, activity: activity as! String, latitude: latitude as! Double, longitude: longitude as! Double, description: description as! String, url: nsurl!)
                handler(eventsObject, nil)
                
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    
    // Extract/Update cities from web
    func extractCities(handler: @escaping ([City], Error?, Source) -> Void) {
        fetchCities { (cities, error) in
            handler(cities, error, .server)
        }
    }
    
    // Extract/Update AllEvents from web
    func extractAllEvents(cityID: String, handler: @escaping ([Event], Error?, Source) -> Void) {
        fetchAllEvents(for: cityID) { (events, error) in
            handler(events, error, .server)
        }
    }
    
    // Extract/Update Event from web
    func extractEvent(eventID: String, handler: @escaping (Event?, Error?, Source) -> Void) {
        fetchEvent(with: eventID) { (event, error) in
            handler(event, error, .server)
        }
    }
}
