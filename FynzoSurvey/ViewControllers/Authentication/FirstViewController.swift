//
//  FirstViewController.swift
//  FynzoSurvey
//
//  Created by Satish Phogat on 01/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var isDemo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? "").isEmpty || isDemo {
            let controller = HomeViewController.instantiate(fromAppStoryboard: .Home)
            controller.isDemoSurvey = isDemo
            navigationController?.pushViewController(controller, animated: isDemo ? false : true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func demoSurveyButtonAction() {
        let controller = HomeViewController.instantiate(fromAppStoryboard: .Home)
        controller.isDemoSurvey = true
        navigationController?.pushViewController(controller, animated: true)
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
