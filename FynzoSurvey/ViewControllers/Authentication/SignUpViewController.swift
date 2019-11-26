//
//  SignUpViewController.swift
//  MyMusicPlayer
//
//  Created by Mohd Maruf on 14/01/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: CommonTableViewCell.self)
        }
    }
    @IBOutlet weak var tickMarkButton: UIButton! {
        didSet {
            tickMarkButton.setImage(UIImage(named: "checkbox_c")?.imageWithColor(color: AppDelegate.shared.appThemeColor), for: .normal)
        }
    }
    
    let titleArray = ["Name", "Email", "Phone", "Password", "Company/Organization"]
    var userInfo = UserInfo()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Sign Up", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        view.endEditing(true)
        
        if !(navigationController?.viewControllers.filter({$0.isKind(of: LoginViewController.self)}) ?? []).isEmpty {

            for controller in self.navigationController!.viewControllers as Array where controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        } else {
            let controller = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func tickMarkButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        tickMarkButton.isSelected = !tickMarkButton.isSelected
        tickMarkButton.setImage(UIImage(named: tickMarkButton.isSelected ? "checkbox_c" : "checkbox_u")?.imageWithColor(color: AppDelegate.shared.appThemeColor), for: .normal)
    }
    
    private func signUpApi() {
        if !tickMarkButton.isSelected {
            customizedAlert(message: "Please agree with Terms and Conditions")
            
            return
        }
        let parameters = ["first_name":userInfo.name,"last_name":"","phone":userInfo.phone,"countrycode":"IND","email":userInfo.email,"password":userInfo.password,"company_name":userInfo.company,"category_id":"","service": "survey"]
        FynzoWebServices.shared.signUp(controller: self, parameters: parameters) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSignUpSuccess(json)
        }
    }
    
    private func handleSignUpSuccess(_ json: JSON) {
        customizedAlert(withTitle: "Success", message: json["msg"].stringValue, iconImage: #imageLiteral(resourceName: "ic_success"), buttonTitles: ["Ok"], afterDelay: 0.5) { (_) in
            if json["status"].boolValue {
                let controller = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func isValidate() -> Bool {
        var verify = false
        
        if userInfo.name.isEmpty {
            customizedAlert(message: "Please enter name")
        } else if userInfo.email.isEmpty {
            customizedAlert(message: "Please enter email id")
        } else if !userInfo.email.isEmail() {
            customizedAlert(message: "Please enter valid email id.")
        } else if userInfo.phone.isEmpty {
            customizedAlert(message: "Please enter Mobile number")
        } else if userInfo.phone.count < 10 {
            customizedAlert(message: "Please enter correct Mobile number")
        } else if userInfo.password.isEmpty {
            customizedAlert(message: "Please enter Password")
        } else if userInfo.password.count < 5 {
            customizedAlert(message: "Password must contain atleast 5 characters")
        } else if userInfo.company.count < 5 {
            customizedAlert(message: "Please enter Company/Organization")
        }
        else {
            verify = true
        }
        
        return verify
    }
    
    @objc func showHideConfirmPasswordAction(_ sender: UIButton) {
        userInfo.showConfirmPassword = !userInfo.showConfirmPassword
        tableView.reloadData()
    }
    
    @objc func showHidePasswordAction(_ sender: UIButton) {
        userInfo.showPassword = !userInfo.showPassword
        tableView.reloadData()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if isValidate() {
            signUpApi()
        }
    }
    
    @IBAction func termsAndConditionAction(_ sender: UIButton) {
        openUrl()
    }
    
    func openUrl() {
        guard let url = URL(string: "https://www.fynzo.com/terms") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension SignUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommonTableViewCell.self)
        
        cell.textField.delegate = self
        cell.textField.returnKeyType = indexPath.row == titleArray.count ? .done : .next
        cell.textField.keyboardType = .default
        cell.textField.autocapitalizationType = .none
        cell.textField.isSecureTextEntry = false
        cell.passwordShowHide.isHidden = true
        cell.textField.returnKeyType = .next
        cell.textField.placeholder = titleArray[indexPath.row]
        
        switch titleArray[indexPath.row] {
        case "Name":
            cell.textField.text = userInfo.name
            cell.textField.autocapitalizationType = .words
            cell.textField.textContentType = .name
        case "Email":
            cell.textField.text = userInfo.email
            cell.textField.keyboardType = .emailAddress
            cell.textField.textContentType = .emailAddress
        case "Phone":
            cell.textField.text = userInfo.phone
            cell.textField.keyboardType = .phonePad
            cell.textField.textContentType = .emailAddress
        case "Password":
            cell.textField.text = userInfo.password
            cell.textField.isSecureTextEntry = !userInfo.showPassword
            cell.passwordShowHide.isHidden = false
            cell.passwordShowHide.setImage(userInfo.showPassword ? #imageLiteral(resourceName: "ic_password_visible").imageWithColor(color: AppDelegate.shared.appThemeColor): #imageLiteral(resourceName: "ic_password_hide").imageWithColor(color: AppDelegate.shared.appThemeColor), for: .normal)
            cell.passwordShowHide.addTarget(self, action: #selector(showHidePasswordAction(_:)), for: .touchUpInside)
            cell.textField.textContentType = .newPassword
        case "Company/Organization":
            cell.textField.text = userInfo.company
            cell.textField.autocapitalizationType = .words
            cell.textField.textContentType = .name
        default:
            break
        }
        
        return cell
    }
}

extension SignUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = (textField.text ?? "").trim()
        
        guard let indexPath = textField.tableViewIndexPathIn(tableView) else { return }
        switch titleArray[indexPath.row] {
        case "Name":
            userInfo.name = text
        case "Phone":
            userInfo.phone = text
        case "Email":
            userInfo.email = text
        case "Password":
            userInfo.password = text
        case "Company/Organization":
            userInfo.company = text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPathIn(tableView) else { return true}
        
        let cellType = titleArray[indexPath.row]
        
        if cellType == "Company/Organization" {
            textField.resignFirstResponder()
        } else {
            let nextCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? CommonTableViewCell
            nextCell?.textField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return range.location < 50 && string != " "
    }
}
