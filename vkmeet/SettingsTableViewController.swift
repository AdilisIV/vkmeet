//
//  SettingsTableViewController.swift
//  vkmeet
//
//  Created by user on 7/8/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    func changeNotificationSettings() {
        if UserDefaultsService.isNotificationEnabled == nil {
            UserDefaultsService.isNotificationEnabled = false
            print("isNotificationEnabled = nil")
        } else if UserDefaultsService.isNotificationEnabled! {
            print("isNotificationEnabled = true")
            UserDefaultsService.isNotificationEnabled = false
            NotificationService.cancelNotification()
        } else {
            print("isNotificationEnabled = false")
            UserDefaultsService.isNotificationEnabled = true
        }
    }
    
    
    @IBAction func notificationSwitchDidChanged(_ sender: UISwitch) {
        changeNotificationSettings()
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        print("logoutButtonPressed")
        
        let alert = UIAlertController.init(title: nil, message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let cancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
        let ok = UIAlertAction.init(title: "Выйти", style: .default) { action in
            
            UserDefaults.standard.removeObject(forKey: "city")
            
            VKAPIWorker.action(2)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "authorization") as! ViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            UIView.transition(with: appDelegate.window!, duration: 0.8, options: .transitionCrossDissolve, animations: {
                appDelegate.window?.rootViewController = viewController
            }, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
