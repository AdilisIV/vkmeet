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
    @IBOutlet weak var showallbuttonImage: UIImageView!
    @IBOutlet weak var showallButton: UIButton!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl!

    var eventsArr: [Event] = [] {
        didSet {
            self.CatalogTable!.reloadData()
        }
    }
    
    /// получаем id города, который выбрал пользователь
    /// id в UserDefaults записывается в классе CityViewController
    let userCity = UserDefaultsService.userCity
    
    
    // MARK: - datepicker config
    /// конфигурируем datepicker
    @IBOutlet weak var datepicker: ScrollableDatepicker! {
        didSet {
            var dates = [Date]()
            for day in 0...15 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datepicker.dates = dates
            datepicker.selectedDate = Date()
            datepicker.delegate = self
            
            var configuration = Configuration()
            
            /// weekend customization
            configuration.weekendDayStyle.dateTextColor = UIColor(red: 76.0/255.0, green: 163.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
            configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 76.0/255.0, green: 163.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            
            /// selected date customization
            //configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 1)
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datepicker.configuration = configuration
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CatalogTable.delegate = self
        CatalogTable.dataSource = self
        
        datepicker.collectionView.backgroundColor = UIColor.clear
        
        /// конфигурируем navigationBar
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Все встречи"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        self.startActivityIndicator()
        
        /// установка UIRefresh
        DispatchQueue.main.async {
            self.refreshControl = UIRefreshControl()
            self.refreshControl.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
            self.refreshControl.addTarget(self, action: #selector(CatalogInfo.showSelectedDate), for: UIControlEvents.valueChanged)
            self.CatalogTable.insertSubview(self.refreshControl, at: 50)
        }
        
        DispatchQueue.main.async {
            self.showSelectedDate()
            self.datepicker.scrollToSelectedDate(animated: false)
        }
    }
    
    /// Установка значения datepicker. Загрузка events
    @objc fileprivate func showSelectedDate() {
        guard let selectedDate = datepicker.selectedDate else {
            return
        }
        DispatchQueue.main.async {
            self.showallbuttonImage.isHidden = true
            self.showallButton.isHidden = true
        }
        
        let timestamp = selectedDate.timeIntervalSince1970
        let timeOn = Int(timestamp)
        let timeOff = timeOn + 86400
        
        self.loadEvents(timeOn: timeOn, timeOff: timeOff)
    }
    
    
    /// при каждом показе View обновляем данные, сверяясь с UserDefaults
    /// и делая willGoButton активной (зеленой), есди event добавлен в UserDefaults
    override func viewWillAppear(_ animated: Bool) {
        self.CatalogTable!.reloadData()
    }
    
    
    /// загрузка мероприятий в соответствии с текущим значением selectedDate в datepicker
    private func loadEvents(timeOn: Int, timeOff: Int) {
        startLoadIndication()
        Store.repository.extractEventsByTime(cityID: self.userCity!, timeOn: timeOn, timeOff: timeOff) { [weak self] (events, error, source) in
            if source == .server {
                /// stop indication
                DispatchQueue.main.async {
                    self?.stopLoadIndication()
                    self?.stopActivityIndicator()
                    self?.refreshControl.endRefreshing()
                }
            }
            if error == nil {
                self?.eventsArr = events
                DispatchQueue.main.async {
                    if events.count <= 2 {
                        self?.showallbuttonImage.isHidden = false
                        self?.showallButton.isHidden = false
                    }
                }
            } else {
                let errorMessage = error?.localizedDescription
                self?.presentNotification(parentViewController: self!, notificationTitle: "Сетевой запрос", notificationMessage: "Ошибка при обновлении данных: \(String(describing: errorMessage))", completion: nil)
            }
        }
    }
    
    
    /// start and stop activityIndicator
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
    
    
    /// делаем загрузку все мероприятий по городу, если по дате показывается <= 2 мероприятий
    @IBAction func showAllButtonPressed(_ sender: UIButton) {
        
        startLoadIndication()
        Store.repository.extractAllEvents(cityID: self.userCity!) { [weak self] (events, error, source) in
            if source == .server {
                /// stop indication
                DispatchQueue.main.async {
                    self?.stopLoadIndication()
                    self?.stopActivityIndicator()
                    self?.refreshControl.endRefreshing()
                }
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
        DispatchQueue.main.async {
            self.showallbuttonImage.isHidden = true
            self.showallButton.isHidden = true
        }
        
    }
    
    
    // MARK: - Popup Methods
    
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
    
    
    // MARK: - tableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath) as! CustomCell
        
        if eventsArr[indexPath.row].commerce {
            cell.takeCommerce()
        } else {
            cell.cancelCommerce()
        }
        
        cell.cellName.text = eventsArr[indexPath.row].name
        cell.countOfMembers.text = eventsArr[indexPath.row].memb
        cell.eventDateLabel.text = eventsArr[indexPath.row].activity
        cell.willgoButtonOutlet.willgoID = eventsArr[indexPath.row].id
        
        if let userDefWillGo = UserDefaultsService.willgoEventIDs {
            if userDefWillGo.contains(cell.willgoButtonOutlet.willgoID) {
                cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 76, green: 163, blue: 248)
            } else {
                cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 196, green: 212, blue: 228)
            }
        } else {
            cell.willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 196, green: 212, blue: 228)
        }
        
        cell.cellImage.sd_setImage(with: URL(string: eventsArr[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToEventDetails", sender: eventsArr[indexPath.row])
    }
    
    /// при переходе по нажатию ячейки передаем объект Event на DetailsVC для отображения в UI
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToEventDetails" {
            let event = sender as! Event
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


// MARK: - ScrollableDatepickerDelegate

extension CatalogInfo: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        showSelectedDate()
    }
    
}

extension Double {
    func toInt() -> Int? {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
