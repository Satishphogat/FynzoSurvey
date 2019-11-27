//
//  ContactUsViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = Fynzo.LabelText.writeFeedBack
            textView.textColor = AppDelegate().appDarkGray
        }
    }
    
    @IBAction func submitButtonAction() {
        view.endEditing(true)
        if textView.text.isEmpty || textView.text == Fynzo.LabelText.writeFeedBack {
            customizedAlert(withTitle: "", message: "Please enter some text", completion: nil)
        } else {
            contactUsApi()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configFreshChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Contact Us", leftBarImage: #imageLiteral(resourceName: "ic_menu"), leftSelector: #selector(leftButtonAction))
    }
    
    private func configFreshChat() {
        let user = FreshchatUser.sharedInstance();
        user?.firstName = AppUserDefaults.value(forKey: .fullName, fallBackValue: "") as? String ?? ""
        user?.lastName = ""
        user?.email = AppUserDefaults.value(forKey: .email, fallBackValue: "") as? String ?? ""
        user?.phoneCountryCode = "+91"
        user?.phoneNumber = AppUserDefaults.value(forKey: .phone, fallBackValue: "") as? String ?? ""
        Freshchat.sharedInstance().setUser(user)
        
        //TODO: uncomment to open chat window
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            Freshchat.sharedInstance().showConversations(self)
//        }
        
        //TODO: use this code to check message count
        
//        Freshchat.sharedInstance().unreadCount { (count:Int) -> Void in
//            print("Unread count (Async) :\(count)")
//        }
    }
    
    @objc func leftButtonAction() {
        openMenu()
    }
    
    private func contactUsApi() {
        let parameter = ["name": AppUserDefaults.value(forKey: .fullName, fallBackValue: false) as? String ?? "", "email": AppUserDefaults.value(forKey: .email, fallBackValue: false) as? String ?? "", "message": textView.text ?? ""] as [String : Any]
        FynzoWebServices.shared.contactUs(controller: self, parameter: parameter) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleContactUsApi(json)
        }
    }
    
    private func handleContactUsApi(_ json: JSON) {
        customizedAlert(withTitle: "Alert!", message: "Contact Form Submitted successfully and Email has alse been sent", buttonTitles: ["Ok"], afterDelay: 0.5) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension ContactUsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Fynzo.LabelText.writeFeedBack {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Fynzo.LabelText.writeFeedBack
            textView.textColor = AppDelegate().appDarkGray
        }
    }
}
