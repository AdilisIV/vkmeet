//
//  NotificationService.swift
//  vkmeet
//
//  Created by user on 7/9/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationService: NSObject {
    
    class func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
