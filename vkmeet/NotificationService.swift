//
//  NotificationService.swift
//  vkmeet
//
//  Created by user on 7/9/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationService: NSObject {
    
    class func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    class func removeNotifications(withIdentifiers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    
    class func scheduleNotification(inSeconds seconds: TimeInterval, id: String, subtitle: String, body: String, completion: (Bool) -> ()) {
        
        removeNotifications(withIdentifiers: [id])
        
        let date = Date(timeIntervalSinceNow: seconds)
        
        let content = UNMutableNotificationContent()
        content.title = "Уже завтра состоится мероприятие:"
        content.subtitle = subtitle
        content.body = body
        let badgeCount = UIApplication.shared.applicationIconBadgeNumber
        content.badge = badgeCount + 1 as NSNumber
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    
    class func setTimeNotification(button: WillGoButton, id: String, subtitle name: String, body activity: String) {
        let nowDate = Date()
        let timeInterval = nowDate.timeIntervalSince1970
        let nowDateInSeconds = Int(timeInterval)
        //let time = self.eventsObject!.timeStart - nowDateInSeconds - 4900
        
        button.backgroundColor = UIColor.rgb(red: 76, green: 163, blue: 248)
        
        //self.willgoEventsID.append(id)
        UserDefaultsService.willgoEventIDs.append(id)
        //UserDefaultsService.willgoEventIDs = self.willgoEventsID
        
        NotificationService.scheduleNotification(inSeconds: 20, id: id, subtitle: name, body: activity, completion: { (success) in
            if success {
                print("We send this Notification")
            } else {
                print("Failed")
            }
        })
    }
    
}
