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
    
    var form = Form()
    var graphReport = GraphReportResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getReport()
    }
    
    private func getReport() {
        let dict = [Fynzo.ApiKey.userId: AppUserDefaults.value(forKey: .id, fallBackValue: "") as? String ?? "",
                    Fynzo.ApiKey.surveyFormId: form.id]
        FynzoWebServices.shared.getGraphReport(showHud: true, showHudText: "", controller: self, parameters: dict) { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            print(json)
            self.graphReport = GraphReportResponse(json: json)
            self.handleSuccessResponse()
        }
    }
    
    private func handleSuccessResponse() {
        let selectedForm = graphReport.surveyForms.filter { $0.id == form.id }.first ?? Form()
        createdOn.text = selectedForm.createTime.getRequiredDate("dd-MMM yy, hh:mm a")
        updatedOn.text = selectedForm.updateTime.getRequiredDate("dd-MMM yy, hh:mm a")
        reponseCollectedLabel.text = "\(graphReport.surverResponse.allResponses.count)"
    }
    
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
        controller.graphReport = graphReport
        navigationController?.pushViewController(controller, animated: true)
    }
}
