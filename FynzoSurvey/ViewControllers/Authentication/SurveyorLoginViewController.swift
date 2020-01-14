//
//  SurveyouLoginViewController.swift
//  FynzoSurvey
//
//  Created by Satish Phogat on 01/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class SurveyorLoginViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var isNewuser = false
    var surveyorKey = ""
    var userId = ""
    var formsArray = [JSON]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        configureNavigationBar(withTitle: "Login As Surveyor", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonAction() {
        view.endEditing(true)
        
        if !isNewuser {
            if (textField.text ?? "").isEmpty {
                customizedAlert(message: "Please enter Surveyor Key.")
            } else {
                checkSurveyorKey()
            }
        } else {
            if (textField.text ?? "").isEmpty {
                customizedAlert(message: "Please enter name.")
            } else if (phoneTextField.text ?? "").isEmpty {
                customizedAlert(message: "Please enter phone number.")
            } else {
                updateSurveyorData()
            }
        }
    }
    
    private func checkSurveyorKey() {
        let dict = ["key": textField.text ?? "", "device_id" : UIDevice.current.identifierForVendor?.description ?? ""]
        FynzoWebServices.shared.survoyrLogin(showHud: true, showHudText: "", controller: self, parameters: dict) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            if json[Fynzo.ApiKey.status].boolValue {
                self.formsArray = json["forms"].arrayValue
                self.handleSuceess(SurveyorUserInfo(json))
            } else {
                self.customizedAlert(withTitle: "", message: json["msg"].stringValue, afterDelay: 0.5)
            }
        }
    }
    
    private func handleSuceess(_ userInfo: SurveyorUserInfo) {
        userId = userInfo.userId
        if userInfo.device.name.isEmpty || userInfo.device.phone.isEmpty {
            isNewuser = true
            surveyorKey = textField.text ?? ""
            textField.text = ""
            phoneTextField.text = ""
            phoneTextField.isHidden = false
            textField.placeholder = "Name"
        } else {
            saveFormToOffline()
        }
    }
    
    private func updateSurveyorData() {
        let dict = ["name": textField.text ?? "", "device_id" : UIDevice.current.identifierForVendor?.description ?? "",
                    "key": surveyorKey, "phone": phoneTextField.text ?? ""]
        FynzoWebServices.shared.updateSurvoyrLogin(showHud: true, showHudText: "", controller: self, parameters: dict) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.saveFormToOffline()
        }
    }
    
    private func saveFormToOffline() {
        var valueResult = [[String: Any]]()
        for item in formsArray {
            var temp = [String: Any]()
            for dictKey in item.dictionaryValue {
                temp[dictKey.key] = dictKey.value.stringValue
            }
            valueResult.append(temp)
        }
        AppUserDefaults.save(value: valueResult, forKey: .surveyorData)
        moveToDashboard()
    }
    
    private func moveToDashboard() {
        AppUserDefaults.save(value: userId, forKey: .id)
        AppUserDefaults.save(value: true, forKey: .isSurveyor)
        AppDelegate.shared.moveToDashboard()
    }
}


extension SurveyorLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isNewuser {
            return textField == phoneTextField ? range.location < 10 : range.location < 50
        } else {
            return range.location < 50 && string != " "
        }
    }
}
