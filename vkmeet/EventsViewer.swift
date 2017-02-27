//
//  EventsViewer.swift
//  vkmeet
//
//  Created by user on 2/26/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class EventsViewer: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    var chossedCity: String = ""
    var names = ["Марафон 8 марта", "Дегустация вин", "Дегустация осетинских пирогов", "Открытия магазина спортивных товаров", "Встреча членов клуба Субаристов"];
    var breeds = ["Приходить всем-всем-всем-всем-всем-всем-всем-всем-всем-всем-всем", "Приходить всем", "Приходить всем", "Приходить всем", "Приходить всем"];
    var images = [UIImage(named: "cakes"), UIImage(named: "fitfood"), UIImage(named: "flowers"), UIImage(named: "subaru"), UIImage(named: "wine")];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.photo.image = images[indexPath.row]
        cell.name.text = names[indexPath.row]
        //cell.breedName.text = breeds[indexPath.row]
        cell.eventDescription.text = breeds[indexPath.row]
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
