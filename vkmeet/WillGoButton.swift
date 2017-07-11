//
//  WillGoButton.swift
//  vkmeet
//
//  Created by user on 5/26/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import NotificationBannerSwift


class WillGoButton: UIButton {
    
    
    var willgoID: String = ""
    
    var status: Bool = false
    
    let activeColor = UIColor.rgb(red: 76, green: 163, blue: 248)
    let passiveColor = UIColor.rgb(red: 202, green: 219, blue: 236)
    
    
    func statusToogle() -> Bool {
        var value = self.status
        value = !value
        return value
    }
    
    
    class func setupNote(parrentViewController controller: UIViewController, button: WillGoButton, eventsID id: String, eventsName name: String, eventsActivity activity: String, eventsTime time: Int) {
        
        let notificationValue = UserDefaultsService.isNotificationEnabled
        if notificationValue == false {
            let banner = NotificationBanner(title: "Уведомления отключены", subtitle: "Включите уведомления в настройках приложения", style: .warning)
            banner.show()
        } else {
            
            button.status = button.statusToogle()
            if button.status {
                
                let alert = UIAlertController.init(title: nil, message: "Создать напоминание о мероприятии?", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "ОK", style: .default) { action in
                    
                    NotificationService.setTimeNotification(button: button, timeStart: time, id: id, subtitle: name, body: activity)
                    
                }
                let cencel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                    button.status = button.statusToogle()
                }
                alert.addAction(ok)
                alert.addAction(cencel)
                controller.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController.init(title: nil, message: "Удалить напоминание о мероприятиии?", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                    NotificationService.removeNotifications(withIdentifiers: [id])
                    button.backgroundColor = button.passiveColor
                    let indexOfEvent = UserDefaultsService.willgoEventIDs.index(of: id)
                    UserDefaultsService.willgoEventIDs.remove(at: indexOfEvent!)
                })
                let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                    button.status = button.statusToogle()
                    print("Удаление напоминания отменено!")
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                controller.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}
