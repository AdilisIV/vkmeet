//
//  APIWorker.swift
//  vkmeet
//
//  Created by user on 1/14/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import SwiftyVK


final class APIWorker {
    
    class func action(_ tag: Int) {
        switch tag {
        case 1:
            authorize()
        case 2:
            logout()
        case 3:
            captcha()
        case 4:
            usersGet()
        case 5:
            citiesGet()
        case 6:
            uploadPhoto()
        case 7:
            validation()
        default:
            print("Unrecognized action!")
        }
    }
    
    
    class func authorize() {
        VK.logOut()
        print("SwiftyVK: LogOut")
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
    
    
    
    class func usersGet() {
        VK.API.Users.get([VK.Arg.userId : "1"]).send(
            onSuccess: {response in print("SwiftyVK: users.get success \n \(response)")},
            onError: {error in print("SwiftyVK: users.get fail \n \(error)")}
        )
    }
    
    
    
    class func citiesGet() {
        VK.API.Database.getCities([VK.Arg.countryId: "1", VK.Arg.count: "100", VK.Arg.needAll: "0"]).send(
            onSuccess: {
                response in print("SwiftyVK: Database.getCitiesById success \n \(response)")
            },
            onError: {error in print("SwiftyVK: Database.getCitiesById fail \n \(error)")}
        )
    }
    
    
    
    class func uploadPhoto() {
        let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "testImage", ofType: "jpg")!))
        let media = Media(imageData: data, type: .JPG)
        VK.API.Upload.Photo.toWall.toUser(media, userId: "4680178").send(
            onSuccess: {response in print("SwiftyVK: friendsGet success \n \(response)")},
            onError: {error in print("SwiftyVK: friendsGet fail \n \(error)")},
            onProgress: {done, total in print("send \(done) of \(total)")}
        )
    }
}
