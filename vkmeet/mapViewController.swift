//
//  mapViewController.swift
//  vkmeet
//
//  Created by user on 5/24/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import GoogleMaps

class mapViewController: UIViewController {
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    var eventName = ""
    
    var mapView:GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.title = eventName
        let markerColor = UIColor.rgb(red: 81, green: 192, blue: 171)
        marker.icon = GMSMarker.markerImage(with: markerColor)
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
