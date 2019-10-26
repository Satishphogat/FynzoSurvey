//
//  ReportViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var reponseCollectedLabel: UILabel!
    @IBOutlet weak var surveyStatusLabel: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var updatedOn: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Report", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func graphReportButtonAction() {
        
    }
    
    @IBAction func detailedReportButtonAction() {
        let controller = ResponseViewController.instantiate(fromAppStoryboard: .Home)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
