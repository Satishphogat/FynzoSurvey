//
//  ViewController.swift
//  Mohd Maruf
//
//  Created by Mohd Maruf on 21/11/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
//import ObjectMapper

class LoginViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: CommonTableViewCell.self)
        }
    }
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.setAttributedTitle(underline("Create an account", font: UIFont.systemFont(ofSize: 16), color: AppDelegate.shared.appThemeColor), for: .normal)
        }
    }
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.setAttributedTitle(underline("Forgot password", font: UIFont.systemFont(ofSize: 16), color: AppDelegate.shared.appThemeColor), for: .normal)
        }
    }

        
    var titleArray = ["Email", "Password"]
    var userInfo = UserInfo()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        configureNavigationBar(withTitle: "Login", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))        
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func isValidate() -> Bool {
        var isVerified = false
        
        if userInfo.email.isEmpty {
            customizedAlert(message: "Please enter email id.")
        } else if !userInfo.email.isEmail() {
            customizedAlert(message: "Please enter valid email id.")
        } else if userInfo.password.isEmpty {
            customizedAlert(message: "Please enter password")
        } else {
            isVerified = true
        }
        
        return isVerified
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        
        if isValidate() {
            login()
        }
    }
    
    @IBAction func surveyorButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let controller = SurveyorLoginViewController.instantiate(fromAppStoryboard: .Authentication)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if !(navigationController?.viewControllers.filter({$0.isKind(of: SignUpViewController.self)}) ?? []).isEmpty {
            
            for controller in self.navigationController!.viewControllers as Array where controller.isKind(of: SignUpViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        } else {
            let controller = SignUpViewController.instantiate(fromAppStoryboard: .Authentication)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if !(navigationController?.viewControllers.filter({$0.isKind(of: ForgotPasswordViewController.self)}) ?? []).isEmpty {
            for controller in self.navigationController!.viewControllers as Array where controller.isKind(of: ForgotPasswordViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        } else {
            let controller = ForgotPasswordViewController.instantiate(fromAppStoryboard: .Authentication)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func showHidePasswordAction(_ sender: UIButton) {
        userInfo.showPassword = !userInfo.showPassword
        tableView.reloadData()
    }
    
    private func login() {
        FynzoWebServices.shared.login(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.email: "user@gmail.com", Fynzo.ApiKey.password: "12345", Fynzo.ApiKey.service: Fynzo.ApiKey.survey]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleLoginSuccess(json)
        }
    }
    
    private func handleLoginSuccess(_ json: JSON) {
        userInfo = UserInfo(json: json)
        AppUserDefaults.save(value: userInfo.id, forKey: .id)
        AppUserDefaults.save(value: userInfo.name, forKey: .fullName)
        AppUserDefaults.save(value: userInfo.email, forKey: .email)
        UserManager.shared.moveToHomeViewController()
    }
}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommonTableViewCell.self)
        
        cell.textField.delegate = self
        cell.textField.keyboardType = indexPath.row == 0 ? .emailAddress : .default
        cell.textField.textContentType = indexPath.row == 0 ? .emailAddress : .password
        cell.textField.layer.borderColor = UIColor.white.cgColor
        cell.textField.layer.borderWidth = 0.7
        cell.textField.isSecureTextEntry = indexPath.row == 1
        cell.passwordShowHide.isHidden = true
        cell.textField.placeholder = titleArray[indexPath.row]
        
        if titleArray[indexPath.row] == "Email" {
            cell.textField.text = userInfo.email
        } else {
            cell.textField.text = userInfo.password
            cell.passwordShowHide.isHidden = false
            cell.textField.isSecureTextEntry = !userInfo.showPassword
            cell.passwordShowHide.setImage(userInfo.showPassword ? #imageLiteral(resourceName: "ic_password_hide"): #imageLiteral(resourceName: "ic_password_visible"), for: .normal)
            cell.passwordShowHide.addTarget(self, action: #selector(showHidePasswordAction(_:)), for: .touchUpInside)
        }
        
        return cell
    }
}

extension LoginViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = textField.tableViewIndexPathIn(tableView) else { return }
        guard let text = textField.text else { return }
        
        let cellType = titleArray[indexPath.row]
        if cellType == "Email" {
            userInfo.email = text.trimmingCharacters(in: NSCharacterSet.whitespaces)
        } else {
            userInfo.password = text.trimmingCharacters(in: NSCharacterSet.whitespaces)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPathIn(tableView) else { return true}
        
        let cellType = titleArray[indexPath.row]
        
        if cellType == "Password" {
            textField.resignFirstResponder()
        } else {
            let nextCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? CommonTableViewCell
            nextCell?.textField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.clearsOnBeginEditing = false
        return string != " "
    }
}
