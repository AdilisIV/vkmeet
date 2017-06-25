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
    
    
    var indexSelectedRow = ""
    
    var citiesData = [City]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        loadCities()
    }
    
    
    func loadCities() {
        startLoadIndication()
        Store.repository.extractCities { (cities, error, source) in
            if source == .server {
                // stop indication
                self.stopLoadIndication()
            }
            if error == nil {
                self.citiesData = cities
                self.indexSelectedRow = self.citiesData[0].id
                DispatchQueue.main.async {
                    self.cityPickerView.reloadAllComponents()
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    @IBAction func goToEventsBtn(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(self.indexSelectedRow, forKey: "city")
        
        performSegue(withIdentifier: "goToEventsView", sender: self)
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.indexSelectedRow = self.citiesData[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.citiesData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.citiesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName : UIColor.white]
        let attStringSaySomething = NSAttributedString(string: citiesData[row].title, attributes: attributes)
        return attStringSaySomething
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
