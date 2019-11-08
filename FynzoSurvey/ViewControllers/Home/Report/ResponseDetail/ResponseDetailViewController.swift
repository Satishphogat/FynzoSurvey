//
//  ResponseDetailViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResponseDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ResponseDetailTableViewCell.self)
        }
    }
    
    var questionResponse = [Question]()
    var selectedIndex = 0
    var graphResponse = GraphReportResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        manageData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Response \(selectedIndex + 1)", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        navigationController?.navigationBar.isHidden = false
    }
    
    private func manageData() {
        let rawResponse = graphResponse.surverResponse.allResponses[selectedIndex].rawResponse
        if let data = rawResponse.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
                var questionList = [Question]()
                for (_, value) in dictonary.enumerated() {
                    if let temp = graphResponse.questions[value.key] {
                        var updatedQuestion = Question(json: JSON(temp))
                        if let res = value.value as? [String] {
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
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResponseDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionResponse.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section + 1). " + questionResponse[section].questionText
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ResponseDetailTableViewCell.self)
        
        let question = questionResponse[indexPath.section]
        if question.questionTypeId == "5" && question.isNps == "0" || question.questionTypeId == "5" && question.isNps.isEmpty {
            cell.titleLabel.isHidden = true
            cell.starView.rating = Double(question.detailResponseAnswer) ?? 0
        } else {
            cell.titleLabel.isHidden = false
            if !question.detailResponseAnswerArray.isEmpty {
                cell.titleLabel.text = question.detailResponseAnswerArray.joined(separator: ",")
            } else {
                cell.titleLabel.text = question.detailResponseAnswer
                cell.titleLabel.text = question.detailResponseAnswer == "<null>" ? "skipped" : question.detailResponseAnswer
            }
        }
        cell.starView.isHidden = !cell.titleLabel.isHidden
        cell.starView.isUserInteractionEnabled = false
        
        return cell
    }
}

extension ResponseDetailViewController: UITableViewDelegate {
    
}
