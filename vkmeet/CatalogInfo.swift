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
    @IBOutlet var addItemView: PopupMenuView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    //var customCell : CustomCell?
    
    var indexSelectedRowID: String = ""
    var selectedCityFromPrevView: String = ""

    var eventsArr = [Event]()
    
    var willgoEventsID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получаем id города, который выбрал пользователь
        // id в UserDefaults записывается в классе CityViewController
        let defaults = UserDefaults.standard
        let userCity = defaults.string(forKey: "city")
        
        
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Все встречи"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        self.startActivityIndicator()
        self.getEvents(city: userCity!)
    }
    
    
    // при каждом показе View обновляем данные, сверяясь с UserDefaults
    // и делая willGoButton активной (зеленой), есди event добавлен в UserDefaults
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "willgoevents") != nil {
            willgoEventsID = defaults.array(forKey: "willgoevents") as! [String]
        }
        self.CatalogTable!.reloadData()
    }
    
    
    // получаем данные, записываем в массив, обновляем данные в таблице
    func getEvents(city: String) {
        
        Alamofire.request("http://onetwomeet.ru/events/\(city)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                var arrRes = [[String:AnyObject]]()
                
                if let resData = swiftyJsonVar.arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                DispatchQueue.main.async {
                    for i in 0..<arrRes.count {
                        let id = arrRes[i]["id"]
                        let title = arrRes[i]["name"]
                        let activity = arrRes[i]["activity"]
                        let img = arrRes[i]["photo"]
                        let dateStart = arrRes[i]["start"]
                        let memb = arrRes[i]["members"]
                        
                        let eventObject = Event.init(id: id as! String, name: title as! String, image: img as! String, memb: String(describing: memb), timeStart: dateStart as! Int, activity: activity as! String, latitude: nil, longitude: nil, description: nil, url: nil)
                        self.eventsArr.append(eventObject)
                    }
                    
                    self.stopActivityIndicator()
                    self.CatalogTable!.reloadData()
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


    @IBAction func willGoButton(_ sender: Any) {}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToEventDetails" {
            (segue.destination as! EventDetailsViewController).selectedEventIDFromPrevView = indexSelectedRowID
        }
        
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
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        addItemView.animateIn(parrentView: self.view, popupView: addItemView, visualEffect: visualEffectView)
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        addItemView.animateOut(parrentView: self.view, popupView: addItemView, visualEffect: visualEffectView)
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
        
    }

}


extension CatalogInfo: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
