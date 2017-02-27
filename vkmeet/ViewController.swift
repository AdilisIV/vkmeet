//
//  ViewController.swift
//  vkmeet
//
//  Created by user on 1/14/17.
//  Copyright © 2017 Ski. All rights reserved.
//
import UIKit
import SwiftyVK


class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    public var citiesArray = [String]()
    
    internal weak static var delegate: VKDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VK.logOut()
        print("SwiftyVK: LogOut")
        VK.logIn()
        print("SwiftyVK: authorize")
        
        VK.API.Database.getCities([VK.Arg.countryId: "1", VK.Arg.count: "1000", VK.Arg.needAll: "0"]).send(
            onSuccess: {
                response in print("SwiftyVK: Database.getCitiesById success \n \(response)")
                for i in 0..<response.count {
                    let title = response[i,"title"].stringValue
                    self.citiesArray.append(title)
                }
                print("Array is: \n \(self.citiesArray)")
        },
            onError: {
                error in print("SwiftyVK: Database.getCitiesById fail \n \(error)")
        }
        )

    }
    
    override func prepare(for segue: UIStoryboardSegue,         sender: Any?) {
        let destinationVC: CityViewController = segue.destination as! CityViewController
        destinationVC.citiesDataArray = citiesArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonDown(_ sender: Any) {
        if (VK.state == .authorized) {
            self.performSegue(withIdentifier: "hateitShow", sender: self)
        }
    }
    
}

