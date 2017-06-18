//
//  TestAPIViewController.swift
//  vkmeet
//
//  Created by user on 2/28/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit
import SwiftyVK
import MessageUI

class TestAPIViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var Subject: UITextField!
    @IBOutlet var Body: UITextView!
    
    let tintColor = UIColor(red: 87/255.0, green: 197/255.0, blue: 171/255.0, alpha: 0.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        titleLabel.text = ""
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        Body.delegate = self
        Subject.delegate = self
        
        Body.text = "Текст сообщения:"
        Body.textColor = tintColor
        Body.layer.borderWidth = 1
        Body.layer.borderColor = UIColor(colorLiteralRed: 87/255.0, green: 197/255.0, blue: 171/255.0, alpha: 0.2).cgColor
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        if let nvc = navigationController {
            nvc.popViewController(animated: true)
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if Body.textColor == self.tintColor {
            Body.text = ""
            Body.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if Body.text.isEmpty {
            Body.text = "Текст сообщения:"
            Body.textColor = self.tintColor
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    @IBAction func SendEmail(_ sender: Any) {
        
        let SubjectText = Subject.text
        let MessageBody = Body.text
        
        let mailComposeViewController = configuredMailComposeViewController(subject: SubjectText, body: MessageBody)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    
    func configuredMailComposeViewController(subject: String?, body: String?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["fedoroff.ilia@gmail.com"])
        mailComposerVC.setSubject(subject!)
        mailComposerVC.setMessageBody(body!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {

        let alertController: UIAlertController = UIAlertController(title: "Невозможно отправить сообщение", message: "Ваще устройство не может отправить сообщение. Пожалуйста, проверьте настройки e-mail и попробуйте снова.", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .cancel) { action -> Void in }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
