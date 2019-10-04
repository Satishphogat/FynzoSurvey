//
//  SignUpViewController.swift
//  MyMusicPlayer
//
//  Created by Mohd Maruf on 14/01/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: CommonTableViewCell.self)
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
    
    @IBAction func next(_ sender: Any) {
        view.endEditing(true)
        
        if isValidate() {

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
        } else if userInfo.password.isEmpty {
            customizedAlert(message: "Please enter Password")
        } else if userInfo.password.count < 8 {
            customizedAlert(message: "Password must contain atleast 8 characters")
        } else if userInfo.confirmPassword.isEmpty {
            customizedAlert(message: "Please enter confirm password")
        } else if userInfo.password != userInfo.confirmPassword {
            customizedAlert(message: "Password and confirm password did not matched")
        } else {
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
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
//        if ((navigationController?.viewControllers.filter({$0.isKind(of: LoginViewController.self)})) != nil) {
//            navigationController?.popViewController(animated: true)
//        } else {
            let controller = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            navigationController?.pushViewController(controller, animated: true)
//        }
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
            cell.textField.text = userInfo.email
            cell.textField.keyboardType = .emailAddress
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
        return 70
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
