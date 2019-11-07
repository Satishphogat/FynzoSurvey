//
//  ResponseViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResponseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ResponseTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var graphReport = GraphReportResponse()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Responses", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }

}

extension ResponseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphReport.surverResponse.allResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ResponseTableViewCell.self)
        cell.titleLabel.text = "Response \(indexPath.row + 1)"
        cell.dateLabel.text = graphReport.surverResponse.allResponses[indexPath.row].startedOn.getRequiredDate("dd-MMM yy, hh:mm a")
        
        return cell
    }
}

extension ResponseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rawResponse = graphReport.surverResponse.allResponses[indexPath.row].rawResponse
        if let data = rawResponse.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
                var questionList = [Question]()
                for (_, value) in dictonary.enumerated() {
                    if let temp = graphReport.questions[value.key] {
                        var updatedQuestion = Question(json: JSON(temp))
                        updatedQuestion.detailResponseAnswer = "\(value.value)"
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
                let controller = ResponseDetailViewController.instantiate(fromAppStoryboard: .Home)
                controller.questionResponse = emptyArray
                self.navigationController?.pushViewController(controller, animated: true)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

