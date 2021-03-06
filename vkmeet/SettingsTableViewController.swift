//
//  SettingsTableViewController.swift
//  vkmeet
//
//  Created by user on 7/8/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var NotificationSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let notificationValue = UserDefaultsService.isNotificationEnabled {
            NotificationSwitch.setOn(notificationValue, animated: false)
        } else {
            NotificationSwitch.setOn(true, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    private func changeNotificationSettings() {
        if UserDefaultsService.isNotificationEnabled! {
            UserDefaultsService.isNotificationEnabled = false
            if #available(iOS 10.0, *) {
                NotificationService.cancelNotification()
            } else {
                let alert = UIAlertController.init(title: "К сожаления уведомления доступны с версии iOS 10.0", message: "Для использования данной функции, выполните обновление, установив iOs 10.0.", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "ОК", style: .default) { action in }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            UserDefaultsService.isNotificationEnabled = true
        }
    }
    
    
    @IBAction func notificationSwitchDidChanged(_ sender: UISwitch) {
        changeNotificationSettings()
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController.init(title: nil, message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let cancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
        let ok = UIAlertAction.init(title: "Выйти", style: .default) { action in
            
            UserDefaults.standard.removeObject(forKey: "city")
            
            VKAPIWorker.action(2)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "authorization") as! AuthViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            UIView.transition(with: appDelegate.window!, duration: 0.8, options: .transitionCrossDissolve, animations: {
                appDelegate.window?.rootViewController = viewController
            }, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        // l__r9@ntagil.org
    }
    
    
}
