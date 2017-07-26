//
//  ViewController.swift
//  vkmeet
//
//  Created by user on 1/14/17.
//  Copyright © 2017 Ski. All rights reserved.
//
import UIKit
import SwiftyVK


class AuthViewController: UIViewController, VKAuthorizationObserver {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).vkdelegate.addObserver(self)
    }
    
    // MARK: - VKAuthorizationObserver
    
    internal func authorizationCompleted(_ result: AuthorizationResult) {
        if result == .success {
            DispatchQueue.main.async {
                self.perform(#selector(self.performLoginSegue), with: nil, afterDelay: 1)
            }
        } else {
            stopLoadIndication()
        }
    }
    
    // MARK: - LoadIndication
    
    func stopLoadIndication() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.loginButton.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loginButton.setTitle("Войти через ВКонтакте", for: .normal)
        }
    }
    
    
    func startLoadIndication() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.loginButton.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.loginButton.setTitle("", for: .normal)
            self.activityIndicator.startAnimating()
        }
    }
    
    // MARK: - Action Methods
    
    func performLoginSegue() {
        self.performSegue(withIdentifier: "chooseCityShow", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    private func showConnectionErrorWithAlert() {
        let alert = UIAlertController.init(title: nil, message: "Нет доступа к сети", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonDown(_ sender: Any) {
        startLoadIndication()
        if InternetChecker.check() {
            VKAPIWorker.authorize()
        } else {
            stopLoadIndication()
            showConnectionErrorWithAlert()
        }
    }
    
}

