//
//  CatalogInfo.swift
//  vkmeet
//
//  Created by user on 3/8/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class CatalogInfo: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var CatalogTable: UITableView!
    @IBOutlet var addItemView: UIView!

    @IBOutlet var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    //var customCell : CustomCell?
    
    var indexSelectedRowID: String = ""
    
    var selectedCityFromPrevView: String = ""
    
    
    var groupID = [String]()
    var groupName = [String]()
    var groupActivity = [String]()
    var groupImage = [String]()
    var groupStart_date = [Int]()
    var groupMembers_count = [String]()
//    var groupLatitude = [Double]()
//    var groupLongitude = [Double]()
//    var groupDescription = [String]()
//    var groupURL = [URL]()


    
    // объявляю структуру
    struct Event {
        var id: String
        var name: String
        var image: String
        var memb: String
        var timeStart: Int
        var activity: String
//        var url: URL
//        var latitude: Double
//        var longitude: Double
    }
    
    var eventsArr = [Event]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    
    var willgoEventsID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userCity = defaults.string(forKey: "city")
        
//        if defaults.value(forKey: "willgoevents") != nil {
//            willgoEventsID = defaults.array(forKey: "willgoevents") as! [String]
//        }
        //willgoEventsID = ["146609781","133127050","147241231"]
        
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Все встречи"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        self.startActivityIndicator()
        self.getEvents(city: userCity!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear method")
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "willgoevents") != nil {
            willgoEventsID = defaults.array(forKey: "willgoevents") as! [String]
        }
        self.CatalogTable!.reloadData()
        //let userCity = defaults.string(forKey: "city")
        //self.getEvents(city: userCity!)
    }
    
    
    func getEvents(city: String) {
        
        Alamofire.request("http://onetwomeet.ru/events/\(city)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                for i in 0..<self.arrRes.count {
                    let id = self.arrRes[i]["id"]
                    let title = self.arrRes[i]["name"]
                    let activity = self.arrRes[i]["activity"]
                    let img = self.arrRes[i]["photo"]
                    let dateStart = self.arrRes[i]["start"]
                    let memb = self.arrRes[i]["members"]?.stringValue
//                    let latitude = self.arrRes[i]["latitude"]
//                    let longitude = self.arrRes[i]["longitude"]
//                    let description = self.arrRes[i]["description"]
//                    let url = self.arrRes[i]["screenname"]
                    //print("TITLE: \(self.arrRes[i]["name"])")
                    
                    
                    //let nsurl = URL(string: url as! String)
                    //print("URL: \(nsurl)")

                    self.groupID.append(id as! String)
                    self.groupName.append(title as! String)
                    self.groupActivity.append(activity as! String)
                    self.groupImage.append(img as! String)
                    self.groupStart_date.append(dateStart as! Int)
                    self.groupMembers_count.append("Участников: " + memb! )
//                    self.groupLatitude.append(latitude as! Double)
//                    self.groupLongitude.append(longitude as! Double)
//                    self.groupURL.append(nsurl!)

                }
                
                
                if self.groupStart_date != [] {
                    DispatchQueue.main.async {
                        
                        print("Число полученных ID: \(self.groupID.count)")
                        for j in 0..<self.groupID.count {
                            //print("Вот j: \(j)")
                            
                            let eventStruct = Event(id: self.groupID[j], name: self.groupName[j], image: self.groupImage[j], memb: self.groupMembers_count[j], timeStart: self.groupStart_date[j], activity: self.groupActivity[j])
                            
                            self.eventsArr.append(eventStruct)
                        }
                        
                        self.stopActivityIndicator()
                        self.CatalogTable!.reloadData()
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
            self.getEvents(city: self.selectedCityFromPrevView)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func willGoButton(_ sender: Any) {
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToEventDetails" {
            (segue.destination as! EventDetailsViewController).selectedEventIDFromPrevView = indexSelectedRowID
        }
        
//        let controller = segue.destination as! EventDetailsViewController
//        controller.selectedEventIDFromPrevView = indexSelectedRowID
        
//        if let navVC = segue.destination as? UINavigationController {
//            if let eventDetails = navVC.viewControllers[0] as? EventDetailsViewController {
//                eventDetails.selectedEventIDFromPrevView = indexSelectedRowID
//            }
//        }
        
    }
    
    
    
    
    
    // start and stop activityIndicator
    func startActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
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
    
    
    @IBAction func addItem(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.CatalogTable.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath) as! CustomCell
        
        cell.cellName.text = eventsArr[indexPath.row].name
        cell.countOfMembers.text = eventsArr[indexPath.row].memb
        cell.eventDateLabel.text = eventsArr[indexPath.row].activity
        cell.willgoButtonOutlet.willgoID = eventsArr[indexPath.row].id
        
        if self.willgoEventsID.contains(cell.willgoButtonOutlet.willgoID) {
            cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 81, green: 192, blue: 171)
        } else {
            cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
        }
        
        cell.cellImage.sd_setImage(with: URL(string: eventsArr[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEvent = eventsArr[indexPath.row]
        self.indexSelectedRowID = selectedEvent.id
        
        performSegue(withIdentifier: "goToEventDetails", sender: self)
        
//        let selectedEvent = eventsArr[indexPath.row]
//        let safaryVC = SFSafariViewController(url: (selectedEvent.url))
//        safaryVC.delegate = self
//        self.present(safaryVC, animated: true, completion: nil)
        
    }

}


extension CatalogInfo: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
