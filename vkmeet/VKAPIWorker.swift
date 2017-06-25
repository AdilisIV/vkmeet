//
//  APIWorker.swift
//  vkmeet
//
//  Created by user on 2/27/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import SwiftyVK


final class VKAPIWorker {
    
    
    
    class func uploadPostToWall(userID: String, activity: String, url: String, eventTitle: String) {
        
        VK.API.Wall.post([VK.Arg.ownerId: userID, VK.Arg.message: "#ПойдуНа \(eventTitle)! \(activity)", VK.Arg.attachments: "photo-147782353_456239020,\(url)"]).send(
            onSuccess: {response in print("SwiftyVK: Wall.post success \n \(response)")},
            onError: {error in print("SwiftyVK: Wall.post fail \n \(error)")}
        )
        
    }
    
    class func action(_ tag: Int) {
        switch tag {
        case 1:
            authorize()
        case 2:
            logout()
        case 3:
            captcha()
        case 4:
            validation()
        default:
            print("Unrecognized action!")
        }
    }
    
    
    class func authorize() {
        VK.logIn()
        print("SwiftyVK: authorize")
    }

    class func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }

    class func captcha() {
        VK.API.custom(method: "captcha.force").send(
            onSuccess: {response in print("SwiftyVK: captcha.force success \n \(response)")},
            onError: {error in print("SwiftyVK: captcha.force fail \n \(error)")}
        )
    }

    class func validation() {
        VK.API.custom(method: "account.testValidation").send(
            onSuccess: {response in print("SwiftyVK: account.testValidation success \n \(response)")},
            onError: {error in print("SwiftyVK: account.testValidation fail \n \(error)")}
        )
    }
    
}
