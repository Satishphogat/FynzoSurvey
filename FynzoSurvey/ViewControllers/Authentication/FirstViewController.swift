//
//  FirstViewController.swift
//  FynzoSurvey
//
//  Created by Satish Phogat on 01/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func demoSurveyButtonAction() {
        
    }
    
    @IBAction func loginButtonAction() {
        let controller = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signUpButtonAction() {
        let controller = SignUpViewController.instantiate(fromAppStoryboard: .Authentication)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
