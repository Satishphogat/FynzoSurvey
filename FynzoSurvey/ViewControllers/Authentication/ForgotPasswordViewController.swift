//
//  ForgotPasswordViewController.swift
//  Mohd Maruf
//
//  Created by SK on 30/11/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Forget Password", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        view.endEditing(true)
        
        
        if (emailTextField.text ?? "").isEmpty {
            customizedAlert(message: "Please enter email Id.")
        } else if !(emailTextField.text ?? "").isEmail() {
            customizedAlert(message: "Please enter valid email id")
        } else {
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return string != " "
    }
}
