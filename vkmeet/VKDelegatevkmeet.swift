//
//  VKDelegatevkmeet.swift
//  vkmeet
//
//  Created by user on 1/14/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import SwiftyVK


enum AuthorizationResult {
    case success
    case fail
}

protocol VKAuthorizationObserver {
    func authorizationCompleted(_ result: AuthorizationResult)
}


class VKDelegatevkmeet: VKDelegate {
    let appID = "5807290"
    let scope: Set<VK.Scope> = [.offline, .email, .groups, .wall]
    
    private var observers: [VKAuthorizationObserver] = []
    
    init() {
        VK.config.logToConsole = true
        VK.config.useSendLimit = false
        VK.config.language = "ru"
        VK.config.apiVersion = "5.63"
        VK.configure(withAppId: appID, delegate: self)
    }
    
    func addObserver(_ observer: VKAuthorizationObserver) {
        observers.append(observer)
    }
    
    
    // MARK: - VKDelegate protocol methods
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        Store.userID = parameters["user_id"]!
        Store.token = parameters["access_token"]!
        observers.forEach { $0.authorizationCompleted(.success) }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        observers.forEach { $0.authorizationCompleted(.fail) }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    func vkDidUnauthorize() {}
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }

}

