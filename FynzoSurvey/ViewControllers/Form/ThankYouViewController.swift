//
//  ThankYouViewController.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 28/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import Kingfisher

enum ThankType {
    case demo
    case templete
    case loggedIn
    case offline
}

class ThankYouViewController: UIViewController {
    
    var thankType = ThankType.loggedIn
    var logoImageUrl = ""
    
    @IBOutlet weak var thankYouTitleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            if let url = URL(string: AppConfiguration.appUrl + logoImageUrl) {
                logoImageView.kf.setImage(with: url)
            }
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            switch thankType {
            case .demo:
                messageLabel.text = "Response Stored On Cloud Successfully."
            case .templete:
                messageLabel.text = "Response Stored On Cloud Successfully."
            case .loggedIn:
                messageLabel.text = "Response Stored On Cloud Successfully."
            case .offline:
                messageLabel.text = "Response Stored On Locally!."
            }
        }
    }
    
    var timerValue = 8
    var isTimerStoped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveToPortrait()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isTimerStoped = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isTimerStoped {
                return
            }
            if self.timerValue > 0 {
                self.timerValue -= 1
                self.timerLabel.text = "Starting new survey in \(self.timerValue) seconds"
                self.startTimer()
            } else {
                self.exitSurvey()
            }
        }
    }

    @IBAction func exitKioskButtonAction() {
        exitSurvey()
    }
    
    private func exitSurvey() {
        switch thankType {
        case .demo:
            UserManager.shared.moveToLogin(true)
        case .loggedIn:
            AppDelegate.shared.moveToDashboard()
        case .templete:
            AppDelegate.shared.moveToDashboard()
        case .offline:
            AppDelegate.shared.moveToDashboard()
        }
    }
    
    @IBAction func startButtonAction() {
        if thankType == .demo {
            UserManager.shared.moveToLogin(true)
        } else {
            AppDelegate.shared.moveToDashboard()
        }
    }
}
