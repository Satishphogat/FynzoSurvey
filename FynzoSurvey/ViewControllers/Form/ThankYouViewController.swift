//
//  ThankYouViewController.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 28/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func exitKioskButtonAction() {
        
    }
    
    @IBAction func startButtonAction() {
        
    }

}
