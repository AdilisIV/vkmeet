//
//  CityViewController.swift
//  vkmeet
//
//  Created by user on 1/16/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK


class CityViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var choosedCityLabel: UILabel!
    
    
    public var citiesDataArray = [String]()
    public var indexSelectedRow = ""
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedCityLabel.text = "Компонент: \(component)"
        if (component == 0) {
            indexSelectedRow = self.citiesDataArray[row]
            choosedCityLabel.text = "Город: \(citiesDataArray[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.citiesDataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.citiesDataArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        //APIWorker.action(5)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destinationVC: EventsViewer = segue.destination as! EventsViewer
        let destinationVC: EventsViewer = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as! EventsViewer
        destinationVC.chossedCity = indexSelectedRow
    }
    
    
    @IBAction func goToEventsBtn(_ sender: Any) {
        performSegue(withIdentifier: "eventsViewShow", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
