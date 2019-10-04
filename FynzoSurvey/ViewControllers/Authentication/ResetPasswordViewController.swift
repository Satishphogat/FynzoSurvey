//
//  ResetPasswordViewController.swift
//  Mohd Maruf
//
//  Created by SK on 03/12/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Reset Password", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func submit(_ sender: Any) {
        view.endEditing(true)
        
        if isValidate() {
            navigationController?.present(SuccessViewController(withSuccessType: .resetPassword), animated: true, completion: nil)
        }
    }
    
    private func isValidate() -> Bool {
        var verify = false
        if (newPasswordTextField.text ?? "").isEmpty {
            customizedAlert(message: "Please enter new Password")
        } else if (newPasswordTextField.text ?? "").count < 8 {
            customizedAlert(message: "Password must contain atleast 8 characters")
        } else if (confirmNewPasswordTextField.text ?? "").isEmpty {
            customizedAlert(message: "Please enter confirm password")
        } else if (newPasswordTextField.text ?? "") != (confirmNewPasswordTextField.text ?? "") {
            customizedAlert(message: "Password and confirm password did not matched")
        } else {
            verify = true
        }
        
        return verify
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPasswordTextField {
            confirmNewPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return string != " "
    }
}
