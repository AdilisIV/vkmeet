//
//  EventDetailsViewController.swift
//  vkmeet
//
//  Created by user on 5/20/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices
import GoogleMaps
import UserNotifications
import NotificationBannerSwift


class EventDetailsViewController: LiveViewController {
    
    @IBOutlet weak var willGoOutlet: WillGoButton!
    
    @IBOutlet weak var addItemView: PopupMenuView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var blurBackImage: UIImageView!
    @IBOutlet weak var eventAvatar: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventMembersLabel: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var smallMapView: GMSMapView!
    @IBOutlet weak var placeholderSmallMap: UIImageView!
    @IBOutlet weak var mapButtonOutlet: UIButton!
    
    @IBOutlet weak var dateShadow: UIImageView!

    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    weak var eventsObject: Event!
    var defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI(event: eventsObject)
        
        // MARK: - actionButton config
        let actionButton = DTZFloatingActionButton(frame:CGRect(
            x: view.frame.size.width - 56 - 14,
            y: view.frame.size.height - 56 - 14,
            width: 56,
            height: 56
        ))
        actionButton.handler = { [weak self]
            button in
            
            if let title = self?.eventsObject!.name {
                if let activity = self?.eventsObject!.activity {
                    let alertVC = PMAlertController(title: "Отправить на стену?", description: "#ПойдуНа \(title)! \(activity)", image: UIImage(named: "photoToWallPost.png"), style: .alert)
                    
                    alertVC.addAction(PMAlertAction(title: "Отмена", style: .cancel, action: { () -> Void in
                        print("Capture action Cancel")
                    }))
                    
                    alertVC.addAction(PMAlertAction(title: "Отправить", style: .default, action: { () in
                        print("Capture action OK")
                        let userId = Store.userID
                        VKAPIWorker.uploadPostToWall(userID: userId!, activity: (self?.eventsObject!.activity)!, url: (self?.eventsObject!.url)!, eventTitle: (self?.eventsObject!.name)!)
                    }))
                    
                    DispatchQueue.main.async {
                        self?.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
        
        setupViews()

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = "Мероприятие"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        placeholderSmallMap.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("DetailsController is deinit")
    }
    
    
    @IBAction func mapButton(_ sender: Any) {
        performSegue(withIdentifier: "goToMapView", sender: self)
    }

    
    private func prepareUI(event: Event!) {
        DispatchQueue.main.async {
            self.willGoOutlet.willgoID = event!.id
            self.dateLabel.text = event!.activity
            self.eventNameLabel.text = event!.name
            self.eventMembersLabel.text = event!.memb
            self.eventDescription.text = event!.description
            self.blurBackImage.sd_setImage(with: URL(string: event!.image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
            self.eventAvatar.sd_setImage(with: URL(string: event!.image), placeholderImage: #imageLiteral(resourceName: "placeholder_toload"), options: [.continueInBackground, .progressiveDownload])
            
            if (event!.latitude == 0) {
                self.mapButtonOutlet.isEnabled = false
                self.placeholderSmallMap.isHidden = false
            } else {
                let eventPosition = GMSCameraPosition.camera(
                    withLatitude: event!.latitude,
                    longitude: event!.longitude,
                    zoom: 15,
                    bearing: 270,
                    viewingAngle: 45)
                self.smallMapView.camera = eventPosition
                
                let eventMarker = GMSMarker()
                let markerColor = UIColor.rgb(red: 76, green: 163, blue: 248)
                eventMarker.position = CLLocationCoordinate2D(
                    latitude: event!.latitude,
                    longitude: event!.longitude)
                eventMarker.icon = GMSMarker.markerImage(with: markerColor)
                eventMarker.map = self.smallMapView
            }
            
            if let userDefWillGo = UserDefaultsService.willgoEventIDs {
                if userDefWillGo.contains(self.willGoOutlet.willgoID) {
                    self.willGoOutlet.backgroundColor = self.willGoOutlet.activeColor
                    self.willGoOutlet.status = true
                }
            } else {
                self.willGoOutlet.backgroundColor = self.willGoOutlet.passiveColor
            }
        }
    }
    
    
    @available(iOS 9.0, *)
    @IBAction func goToVKAction(_ sender: Any) {
        let safaryVC = SFSafariViewController(url: self.eventsObject!.url)
        safaryVC.delegate = self
        self.present(safaryVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMapView" {
            let controller = segue.destination as! mapViewController
            controller.eventName = self.eventsObject!.name
            controller.latitude = self.eventsObject!.latitude
            controller.longitude = self.eventsObject!.longitude
        }
    }
    
    //MARK: - Popup Methods
    
    @IBAction func addItem(_ sender: Any) {
        let view = self.view
        addItemView.animateIn(parrentView: view!, popupView: addItemView, visualEffect: visualEffectView)
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        let view = self.view
        addItemView.animateOut(parrentView: view!, popupView: addItemView, visualEffect: visualEffectView)
    }
    
    
    @IBAction func willGoClick(_ sender: Any) {
        WillGoButton.setupNote(parrentViewController: self, button: self.willGoOutlet, eventsID: self.eventsObject.id, eventsName: self.eventsObject.name, eventsActivity: self.eventsObject.activity, eventsTime: self.eventsObject.timeStart)
    }
    
    
    //MARK: - UI config
    func setupViews() {
        DispatchQueue.main.async {
            // eventAvatar
            self.eventAvatar.layer.cornerRadius = 10
            self.eventAvatar.layer.masksToBounds = true
            
            // dateShadow
            self.dateShadow.frame = CGRect(x: 141, y: -16, width: self.dateShadow.frame.width, height: self.dateShadow.frame.height)
            self.dateShadow.clipsToBounds = false
            self.dateShadow.layer.shadowColor = UIColor.black.cgColor
            self.dateShadow.layer.shadowOpacity = 0.30
            self.dateShadow.layer.shadowRadius = 5
            self.dateShadow.layer.shadowOffset = CGSize.zero
            self.dateShadow.layer.shadowPath = UIBezierPath(rect: self.dateShadow.bounds).cgPath
        }
    }
    

}


extension EventDetailsViewController: SFSafariViewControllerDelegate {
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
