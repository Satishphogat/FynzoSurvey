//
//  ReportViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportHeadingLabel: UILabel! {
        didSet {
            reportHeadingLabel.text = form.name
        }
    }
    @IBOutlet weak var reponseCollectedLabel: UILabel!
    @IBOutlet weak var surveyStatusLabel: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var updatedOn: UILabel!
    
    var form = Form()
    var graphReport = GraphReportResponse()
    var questionResponse = [Question]()
    var graphArray = [GraphDetailView]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Report", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getReport()
    }
    
    private func getQuestions(_ index: Int) -> [Question] {
        let rawResponse = graphReport.surverResponse.allResponses[index].rawResponse
        if let data = rawResponse.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
                var questionList = [Question]()
                for (_, value) in dictonary.enumerated() {
                    if let temp = graphReport.questions[value.key] {
                        var updatedQuestion = Question(json: JSON(temp))
                        if let res = value.value as? [String] {
                            updatedQuestion.rawStringArray = res
                            for item in res {
                                let selectedQuestion = updatedQuestion.questions.filter { $0.id == item}.first ?? Question()
                                updatedQuestion.detailResponseAnswerArray.append(selectedQuestion.choice)
                            }
                        } else {
                            updatedQuestion.detailResponseAnswer = "\(value.value)"
                        }
                        questionList.append(updatedQuestion)
                    }
                }
                questionList.sort(by: { $0.screenNo <= $1.screenNo })
                var tempArray = [Question]()
                for item in questionList {
                    if tempArray.isEmpty {
                        tempArray.append(item)
                    } else {
                        var isAdd = true
                        for item2 in tempArray {
                            if item2.screenNo == item.screenNo {
                                isAdd = false
                                break
                            }
                        }
                        if isAdd {
                            tempArray.append(item)
                        }
                    }
                }
                var modelArray = [[Question]]()
                for item in tempArray {
                    modelArray.append([item])
                }
                for item in questionList {
                    for index in (0..<modelArray.count) {
                        let res = modelArray[index].first ?? Question()
                        if res.screenNo == item.screenNo {
                            modelArray[index].append(item)
                            break
                        }
                    }
                }
                for index in (0..<modelArray.count) {
                    modelArray[index].remove(at: 0)
                }
                var emptyArray = [Question]()
                for item in modelArray {
                    let newTemp = item.sorted(by: { $0.questingNo < $1.questingNo })
                    emptyArray += newTemp
                }
                questionResponse = emptyArray
            } catch {
                print("error")
            }
        }
        
        return questionResponse
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
        var questionsArray = [[Question]]()
        for index in 0..<graphReport.surverResponse.allResponses.count {
          let questions = getQuestions(index)
            questionsArray.append(questions)
        }
        var withoutNameArray = [[Question]]()
        for obj in questionsArray {
            var arr = [Question]()
            for objWithoutName in obj where objWithoutName.questionTypeId != "1" {
                arr.append(objWithoutName)
            }
            withoutNameArray.append(arr)
        }
        
        if let questionTexts = withoutNameArray.map({$0.map({$0.questionText})}).first {
            for text in questionTexts {
                var answerArray = [Question]()
                for obj in withoutNameArray {
                    for specificObj in obj where specificObj.questionText == text && specificObj.questionTypeId != "1" {
                        answerArray.append(specificObj)
                    }
                }
                var temp = GraphDetailView()
                temp.questionText = text
                temp.questions = answerArray
                graphArray.append(temp)
            }
        }
    }
    
    @objc func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func graphReportButtonAction() {
        if graphArray.isEmpty {
            customizedAlert(message: "No Response Available")
            
            return
        }
        let controller = GraphViewController.instantiate(fromAppStoryboard: .Home)
        if graphArray.isEmpty {
            customizedAlert(message: "No Response Available")
            
            return
        }
        controller.graphArray = graphArray
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func detailedReportButtonAction() {
        let controller = ResponseViewController.instantiate(fromAppStoryboard: .Home)
        controller.graphReport = graphReport
        navigationController?.pushViewController(controller, animated: true)
    }
}
