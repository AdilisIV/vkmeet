//
//  CityViewController.swift
//  vkmeet
//
//  Created by user on 1/16/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import SwiftyJSON



class CityViewController: LiveViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    var citiesData: [City] = [] {
        didSet {
            cityPickerView.reloadAllComponents()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        loadCities()
    }
    
    
    
    func loadCities() {
        startLoadIndication()
        Store.repository.extractCities { [weak self] (cities, error, source) in
            if source == .server {
                // stop indication
                self?.stopLoadIndication()
            }
            if error == nil {
                self?.citiesData = cities
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultsService.userCity = citiesData[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return citiesData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citiesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName : UIColor.white]
        let attStringSaySomething = NSAttributedString(string: citiesData[row].title, attributes: attributes)
        return attStringSaySomething
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func chooseBtnPressed(_ sender: UIButton) {
        if UserDefaultsService.userCity == "" {
            presentNotification(parentViewController: self, notificationTitle: "Ошибка", notificationMessage: "Не выбран город", completion: nil)
        } else {
            performSegue(withIdentifier: "goToEventsView", sender: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
