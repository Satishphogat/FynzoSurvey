//
//  SurveyouLoginViewController.swift
//  FynzoSurvey
//
//  Created by Satish Phogat on 01/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class SurveyorLoginViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        configureNavigationBar(withTitle: "", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @IBAction func loginButtonAction() {
        if (textField.text ?? "").isEmpty {
            customizedAlert(message: "Please enter Surveyor Key.")
        } else {
            
        }
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension SurveyorLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return string != " "
    }
}
