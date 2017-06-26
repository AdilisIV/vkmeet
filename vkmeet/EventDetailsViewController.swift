//
//  EventDetailsViewController.swift
//  vkmeet
//
//  Created by user on 5/20/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices
import GoogleMaps
import UserNotifications

class EventDetailsViewController: LiveViewController {
    
    @IBOutlet var willGoOutlet: WillGoButton!
    
    @IBOutlet var addItemView: PopupMenuView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var blurBackImage: UIImageView!
    @IBOutlet var eventAvatar: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventMembersLabel: UILabel!
    @IBOutlet var eventDescription: UITextView!
    
    @IBOutlet var smallMapView: GMSMapView!
    @IBOutlet var placeholderSmallMap: UIImageView!
    @IBOutlet var mapButtonOutlet: UIButton!
    
    @IBOutlet var dateShadow: UIImageView!

    
    var selectedEventIDFromPrevView: String = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var eventsObject: Event?

    var willgoEventsID = [String]()
    var checkMark:Bool!
    
    var defaults = UserDefaults.standard
    
    //var stringUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButton = DTZFloatingActionButton(frame:CGRect(
            x: view.frame.size.width - 56 - 14,
            y: view.frame.size.height - 56 - 14,
            width: 56,
            height: 56
        ))
        actionButton.handler = {
            button in
            
            let alert = UIAlertController.init(title: nil, message: "Вы уверены, что хотите поделиться этим мероприятием с друзьями?", preferredStyle: .alert)
            
            let cancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
            let ok = UIAlertAction.init(title: "Ок", style: .default) { action in
                let userId = Store.userID
                VKAPIWorker.uploadPostToWall(userID: userId!, activity: self.eventsObject!.activity, url: self.eventsObject!.url, eventTitle: self.eventsObject!.name)
            }
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
        
        if self.defaults.value(forKey: "willgoevents") != nil {
            self.willgoEventsID = self.defaults.array(forKey: "willgoevents") as! [String]
        }
        
        self.checkMark = false
        print(self.checkMark)
        
        setupViews()
        //getEvents(eventID: selectedEventIDFromPrevView)
        loadEventInfo(id: selectedEventIDFromPrevView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Мероприятие"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        placeholderSmallMap.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func mapButton(_ sender: Any) {
        performSegue(withIdentifier: "goToMapView", sender: self)
    }
    

    @IBAction func backButton(_ sender: Any) {
        if let nvc = navigationController {
            nvc.popViewController(animated: true)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.index(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
    }
    
    
    func loadEventInfo(id: String) {
        startLoadIndication()
        Store.repository.extractEvent(eventID: id) { (event, error, source) in
            if source == .server {
                // stop indication
                self.stopLoadIndication()
            }
            if error == nil {
                
                self.eventsObject = event
                
                DispatchQueue.main.async {
                    self.willGoOutlet.willgoID = event!.id
                    self.dateLabel.text = event!.activity
                    self.eventNameLabel.text = event!.name
                    self.eventMembersLabel.text = event!.memb
                    self.eventDescription.text = event!.description
                    self.blurBackImage.sd_setImage(with: URL(string: event!.image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
                    self.eventAvatar.sd_setImage(with: URL(string: event!.image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
                    
                    if (event!.latitude == 0) {
                        self.mapButtonOutlet.isEnabled = false
                        self.placeholderSmallMap.isHidden = false
                    } else {
                        let eventPosition = GMSCameraPosition.camera(
                                withLatitude: event!.latitude,
                                longitude: event!.longitude,
                                zoom: 15,
                                bearing: 270,
                                viewingAngle: 45)
                        self.smallMapView.camera = eventPosition
                        let eventMarker = GMSMarker()
                        let markerColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                        eventMarker.position = CLLocationCoordinate2D(
                            latitude: event!.latitude,
                            longitude: event!.longitude)
                        eventMarker.icon = GMSMarker.markerImage(with: markerColor)
                        eventMarker.map = self.smallMapView
                    }
                    
                    if self.willgoEventsID.contains(self.willGoOutlet.willgoID) {
                        self.willGoOutlet.backgroundColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                        self.checkMark = true
                        print(self.checkMark)
                    } else {
                        self.willGoOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
                    }
                }
            } else {
                self.dataLoadFailed()
            }
        }
    }
    
    
    func dataLoadFailed() {
        let alert = UIAlertController.init(title: nil, message: "Ошибка загрузки данных. Попробовать еще раз?", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Ок", style: .default) { action in
            self.loadEventInfo(id: self.selectedEventIDFromPrevView)
        }
        let cencel = UIAlertAction.init(title: "Cencel", style: .cancel) { (action) in
            print("DataLoad Failed. Pressed Cencel Button")
        }
        alert.addAction(ok)
        alert.addAction(cencel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func goToVKAction(_ sender: Any) {
        let safaryVC = SFSafariViewController(url: self.eventsObject!.url)
        safaryVC.delegate = self
        self.present(safaryVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMapView" {
            let controller = segue.destination as! mapViewController
            controller.latitude = self.eventsObject!.latitude
            controller.longitude = self.eventsObject!.longitude
            controller.eventName = self.eventsObject!.name
        }

    }
    
    
    @IBAction func addItem(_ sender: Any) {
        addItemView.animateIn(parrentView: self.view, popupView: addItemView, visualEffect: visualEffectView)
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        addItemView.animateOut(parrentView: self.view, popupView: addItemView, visualEffect: visualEffectView)
    }
    
    
    @IBAction func willGoClick(_ sender: Any) {
        self.checkMark = self.willGoOutlet.willgoToggle(checkMark: self.checkMark)
        print(self.checkMark)
        if self.checkMark {
            
            let alert = UIAlertController.init(title: nil, message: "Создать напоминание о мероприятии?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "ОK", style: .default) { action in
                
                let nowDate = Date()
                let timeInterval = nowDate.timeIntervalSince1970
                let nowDateInSeconds = Int(timeInterval)
                let time = self.eventsObject!.timeStart - nowDateInSeconds - 4900
                
                self.willGoOutlet.backgroundColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                
                self.willgoEventsID.append(self.eventsObject!.id)
                print("Добавление в willgoEventsID элемента - \(self.eventsObject!.id)")
                print("willgoEventsID: \(self.willgoEventsID)")
                self.defaults.set(self.willgoEventsID, forKey: "willgoevents")
                print("UserDefaults for key:willdoevents - \(self.defaults.array(forKey: "willgoevents") as! [String])")
                
                self.scheduleNotification(inSeconds: TimeInterval(time), id: self.selectedEventIDFromPrevView, subtitle: self.eventsObject!.name, body: self.eventsObject!.activity, completion: { (success) in
                    if success {
                        print("We send this Notification")
                    } else {
                        print("Failed")
                    }
                })
                
            }
            let cencel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                self.checkMark = self.willGoOutlet.willgoToggle(checkMark: self.checkMark)
                print("Добавление Уведомления отменено")
            }
            alert.addAction(ok)
            alert.addAction(cencel)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController.init(title: nil, message: "Удалить напоминание о мероприятиии?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                self.removeNotifications(withIdentifiers: [self.selectedEventIDFromPrevView])
                self.willGoOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
                let indexOfEvent = self.willgoEventsID.index(of: self.eventsObject!.id)
                self.willgoEventsID.remove(at: indexOfEvent!)
                self.defaults.set(self.willgoEventsID, forKey: "willgoevents")
            })
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                self.checkMark = self.willGoOutlet.willgoToggle(checkMark: self.checkMark)
                print("Удаление напоминания отменено!")
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    func scheduleNotification(inSeconds seconds: TimeInterval, id: String, subtitle: String, body: String, completion: (Bool) -> ()) {
        
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
    
    
    func removeNotifications(withIdentifiers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    
    func setupViews() {
        // eventAvatar
        eventAvatar.layer.cornerRadius = 10
        eventAvatar.layer.masksToBounds = true
        
        // dateShadow
        dateShadow.frame = CGRect(x: 141, y: -16, width: dateShadow.frame.width, height: dateShadow.frame.height)
        dateShadow.clipsToBounds = false
        dateShadow.layer.shadowColor = UIColor.black.cgColor
        dateShadow.layer.shadowOpacity = 0.30
        dateShadow.layer.shadowRadius = 5
        dateShadow.layer.shadowOffset = CGSize.zero
        dateShadow.layer.shadowPath = UIBezierPath(rect: dateShadow.bounds).cgPath
    }
    

}


extension EventDetailsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
