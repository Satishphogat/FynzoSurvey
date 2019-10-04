//
//  SuccessViewController.swift
//  Mohd Maruf
//
//  Created by SK on 03/12/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    enum SuccessType {
        case resetPassword
        case signup
        case changePassword
    }
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    var successType = SuccessType.signup
    
    init(withSuccessType successType: SuccessType) {
        super.init(nibName: "SuccessViewController", bundle: nil)
        super.modalPresentationStyle = .overCurrentContext
        super.modalTransitionStyle = .crossDissolve
        self.successType = successType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch successType {
        case .resetPassword, .changePassword:
            break
        case .signup:
            messageLabel.text = "Sign Up succefully"
            successLabel.text = "Registration Succefully"
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        AppDelegate.shared.moveToLogin()
    }
}
