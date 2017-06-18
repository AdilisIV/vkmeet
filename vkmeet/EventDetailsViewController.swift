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

class EventDetailsViewController: UIViewController {
    
    @IBOutlet var willGoOutlet: WillGoButton!
    
    
    @IBOutlet var addItemView: UIView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    
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
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    
    var stringURL: String?
    
    var IDString: String?
    
    
    var groupName = [String]()
    var groupLatitude = [Double]()
    var groupLongitude = [Double]()
    
    
    // объявляю структуру
    struct Event {
        var id:String
        var name: String
        var image: String
        var memb: String
        var activity: String
        var start: Int
        var latitude: Double
        var longitude: Double
        var description: String
        var url: URL
    }
    
    var eventsArr = [Event]()

    var willgoEventsID = [String]()
    var checkMark:Bool!
    
    var defaults = UserDefaults.standard
    
    var stringUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButton = DTZFloatingActionButton(frame:CGRect(x: view.frame.size.width - 56 - 14,
                                                                y: view.frame.size.height - 56 - 14,
                                                                width: 56,
                                                                height: 56
        ))
        actionButton.handler = {
            button in
            print("Hi!")
            
            let alert = UIAlertController.init(title: nil, message: "Вы уверены, что хотите поделиться этим мероприятием с друзьями?", preferredStyle: .alert)
            
            let cancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
            let ok = UIAlertAction.init(title: "Ок", style: .default) { action in
                
                let userId = Store.userID
                APIWorker.uploadPostToWall(userID: userId!, activity: self.eventsArr[0].activity, url: self.stringUrl, eventTitle: self.eventsArr[0].name)
                
            }
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
        
        //var defaults = UserDefaults.standard
        if self.defaults.value(forKey: "willgoevents") != nil {
            self.willgoEventsID = self.defaults.array(forKey: "willgoevents") as! [String]
        }
        
        //willgoEventsID = ["146609781","133127050","147241231"]
        self.checkMark = false
        print(self.checkMark)
        
        setupViews()
        getEvents(eventID: selectedEventIDFromPrevView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Мероприятие"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        placeholderSmallMap.isHidden = true
        
        
//        eventMarker.position = CLLocationCoordinate2D(latitude: 55.7494733, longitude: 37.3523193)
//        eventMarker.title = "Moscow"
//        eventMarker.map = mapView
        
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
    
    
    func getEvents(eventID: String) {
        
        Alamofire.request("http://onetwomeet.ru/events/eventbyid/\(eventID)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
//                var groupName = [String]()
                var groupId = [String]()
                var groupActivity = [String]()
                var groupImage = [String]()
                var groupMembers_count = [String]()
//                var groupLatitude = [Double]()
//                var groupLongitude = [Double]()
                var groupDescription = [String]()
                var groupURL = [URL]()
                var groupStart = [Int]()
                
                
                let id = self.arrRes[0]["id"]
                let title = self.arrRes[0]["name"]
                let activity = self.arrRes[0]["activity"]
                let start = self.arrRes[0]["start"]
                let img = self.arrRes[0]["photo"]
                let memb = self.arrRes[0]["members"]?.stringValue
                let latitude = self.arrRes[0]["latitude"]
                let longitude = self.arrRes[0]["longitude"]
                let description = self.arrRes[0]["description"]
                let url = self.arrRes[0]["screenname"]
                self.stringUrl = url as! String
                let nsurl = URL(string: url as! String)

                
                groupId.append(id as! String)
                self.groupName.append(title as! String)
                groupActivity.append(activity as! String)
                groupStart.append(start as! Int)
                groupImage.append(img as! String)
                groupMembers_count.append("Участников: " + memb! )
                self.groupLatitude.append(latitude as! Double)
                self.groupLongitude.append(longitude as! Double)
                groupDescription.append(description as! String)
                groupURL.append(nsurl!)
                
                let eventStruct = Event(id: groupId[0], name: self.groupName[0], image: groupImage[0], memb: groupMembers_count[0], activity: groupActivity[0], start: groupStart[0], latitude: self.groupLatitude[0], longitude: self.groupLongitude[0], description: groupDescription[0], url: groupURL[0])
                
                self.eventsArr.append(eventStruct)
                
                
                // заполнение UI
                self.willGoOutlet.willgoID = self.eventsArr[0].id
                self.dateLabel.text = self.eventsArr[0].activity
                self.eventNameLabel.text = self.eventsArr[0].name
                self.eventMembersLabel.text = self.eventsArr[0].memb
                self.eventDescription.text = self.eventsArr[0].description
                self.blurBackImage.sd_setImage(with: URL(string: self.eventsArr[0].image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
                self.eventAvatar.sd_setImage(with: URL(string: self.eventsArr[0].image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
                
                if (self.eventsArr[0].latitude == 0) {
                    self.mapButtonOutlet.isEnabled = false
                    self.placeholderSmallMap.isHidden = false
                } else {
                    let eventPosition = GMSCameraPosition.camera(withLatitude: self.eventsArr[0].latitude,
                                                                 longitude: self.eventsArr[0].longitude,
                                                                 zoom: 15,
                                                                 bearing: 270,
                                                                 viewingAngle: 45)
                    self.smallMapView.camera = eventPosition
                    let eventMarker = GMSMarker()
                    let markerColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                    eventMarker.position = CLLocationCoordinate2D(latitude: self.eventsArr[0].latitude, longitude: self.eventsArr[0].longitude)
                    eventMarker.icon = GMSMarker.markerImage(with: markerColor)
                    eventMarker.map = self.smallMapView
                }
                
                if self.willgoEventsID.contains(self.willGoOutlet.willgoID) {
                    self.willGoOutlet.backgroundColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                    self.checkMark = true
                    print(self.checkMark)
                } else {
                    self.willGoOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
                    //self.checkMark = true
                }
                
            } else {
                self.dataLoadFailed()
            }
        }
        
    }
    
    
    /*func runGroupByID(eventID: String) {
        
        VK.API.Groups.getById([VK.Arg.groupId:"\(eventID)", VK.Arg.fields:"activity,members_count,start_date"]).send(
            onSuccess: {
                response in print("SwiftyVK: Groups.getById success \n \(response)")
                
                for i in 0..<response.count {
                    
                    let name = response[i,"name"].stringValue
                    var activity = response[i,"activity"].stringValue
                    let img = response[i,"photo_200"].stringValue
                    var memb = response[i,"members_count"].stringValue
                    let screenName = response[i,"place"].stringValue
                    
                    self.stringURL = "https://m.vk.com/" + screenName
                    let url = URL(string: self.stringURL!)
                    
                    memb = "Участников: " + memb
                    
                    if response[i,"is_closed"] == 0 {
                        print("Открыток сообщество")
                    } else {
                        memb = "?"
                        activity = "Данные недоступны"
                    }
                }

                let eventStruct = Event(id: self.groupID[0], name: self.groupName[0], image: self.groupImage[0], memb: self.groupMembers_count[0], timeStart: self.groupStart_date[0], activity: self.groupActivity[0], url: self.groupURL[0])
                self.eventsArr.append(eventStruct)
                
        },
            onError: {
                error in print("SwiftyVK: Groups.getById fail \n \(error)")
        }
        )
        
    }*/
    
    
    func dataLoadFailed() {
        let alert = UIAlertController.init(title: nil, message: "Ошибка загрузки данных. Попробовать еще раз?", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Ок", style: .default) { action in
            self.getEvents(eventID: self.selectedEventIDFromPrevView)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func goToVKAction(_ sender: Any) {
        let safaryVC = SFSafariViewController(url: self.eventsArr[0].url)
        safaryVC.delegate = self
        self.present(safaryVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMapView" {
            let controller = segue.destination as! mapViewController
            controller.latitude = self.groupLatitude[0]
            controller.longitude = self.groupLongitude[0]
            controller.eventName = self.groupName[0]
        }

    }
    
    
    @IBAction func addItem(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }
    
    
    func animateIn() {
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            self.addItemView.removeFromSuperview()
        }
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
                let time = self.eventsArr[0].start - nowDateInSeconds - 4900
                
                
                self.willGoOutlet.backgroundColor = UIColor.rgb(red: 81, green: 192, blue: 171)
                
                self.willgoEventsID.append(self.eventsArr[0].id)
                print("Добавление в willgoEventsID элемента - \(self.eventsArr[0].id)")
                print("willgoEventsID: \(self.willgoEventsID)")
                self.defaults.set(self.willgoEventsID, forKey: "willgoevents")
                print("UserDefaults for key:willdoevents - \(self.defaults.array(forKey: "willgoevents") as! [String])")
                
                self.scheduleNotification(inSeconds: 20, id: self.selectedEventIDFromPrevView, subtitle: self.eventsArr[0].name, body: self.eventsArr[0].activity, completion: { (success) in
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
            //willGoOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
            let alert = UIAlertController.init(title: nil, message: "Удалить напоминание о мероприятиии?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                self.removeNotifications(withIdentifiers: [self.selectedEventIDFromPrevView])
                self.willGoOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
                let indexOfEvent = self.willgoEventsID.index(of: self.eventsArr[0].id)
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
