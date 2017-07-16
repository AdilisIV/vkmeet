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

class CatalogInfo: LiveViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CatalogTable: UITableView!
    @IBOutlet weak var addItemView: PopupMenuView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl!

    var eventsArr = [Event]()
    
    // получаем id города, который выбрал пользователь
    // id в UserDefaults записывается в классе CityViewController
    let userCity = UserDefaults.standard.string(forKey: "city")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CatalogTable.delegate = self
        CatalogTable.dataSource = self

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Все встречи"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        self.startActivityIndicator()
        //self.loadEvents(city: self.userCity!)
        self.loadEvents()
        
        /// UIRefresh
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        refreshControl.addTarget(self, action: #selector(CatalogInfo.loadEvents), for: UIControlEvents.valueChanged)
        CatalogTable.insertSubview(refreshControl, at: 0)
    }
    
    
    // при каждом показе View обновляем данные, сверяясь с UserDefaults
    // и делая willGoButton активной (зеленой), есди event добавлен в UserDefaults
    override func viewWillAppear(_ animated: Bool) {
        self.CatalogTable!.reloadData()
    }
    
    
    func loadEvents() {
        startLoadIndication()
        Store.repository.extractAllEvents(cityID: self.userCity!) { [weak self] (events, error, source) in
            if source == .server {
                // stop indication
                self?.stopLoadIndication()
                self?.stopActivityIndicator()
                self?.refreshControl.endRefreshing()
            }
            if error == nil {
                self?.eventsArr = events
                DispatchQueue.main.async {
                    self?.CatalogTable!.reloadData()
                }
            } else {
                let errorMessage = error?.localizedDescription
                self?.presentNotification(parentViewController: self!, notificationTitle: "Сетевой запрос", notificationMessage: "Ошибка при обновлении данных: \(String(describing: errorMessage))", completion: nil)
            }
        }
    }// string interpolation produces a debug description for an optional value; did you mean to make this explicit?
    
    
    // start and stop activityIndicator
    func startActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath) as! CustomCell
        
        cell.cellName.text = eventsArr[indexPath.row].name
        cell.countOfMembers.text = eventsArr[indexPath.row].memb
        cell.eventDateLabel.text = eventsArr[indexPath.row].activity
        cell.willgoButtonOutlet.willgoID = eventsArr[indexPath.row].id
        
        if UserDefaultsService.willgoEventIDs.contains(cell.willgoButtonOutlet.willgoID) {
            cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 76, green: 163, blue: 248)
        } else {
            cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
        }
        
        cell.cellImage.sd_setImage(with: URL(string: eventsArr[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToEventDetails", sender: eventsArr[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToEventDetails" {
            let event = sender as! Event
            print("latitude: \(event.latitude)")
            print("longitude: \(event.longitude)")
            print("description: \(event.description)")
            print("url: \(event.url)")
            let dvc = segue.destination as! EventDetailsViewController
            dvc.eventsObject = event
        } else if segue.identifier == "toCitySegue" {
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    deinit {
        print("CatalogController is deinit")
    }

}


extension CatalogInfo: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
