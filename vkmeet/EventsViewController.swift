//
//  EventsViewController.swift
//  vkmeet
//
//  Created by user on 2/22/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var chossedCity: String = ""
    var names = ["Марафон 8 марта", "Дегустация вин", "Дегустация осетинских пирогов", "Открытия магазина спортивных товаров", "Встреча членов клуба Субаристов"];
    var breeds = ["Приходить всем", "Приходить всем", "Приходить всем", "Приходить всем", "Приходить всем"];
    var images = [UIImage(named: "cakes"), UIImage(named: "fitfood"), UIImage(named: "flowers"), UIImage(named: "subaru"), UIImage(named: "wine")];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.photo.image = images[indexPath.row]
        cell.name.text = names[indexPath.row]
        cell.breedName.text = breeds[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
