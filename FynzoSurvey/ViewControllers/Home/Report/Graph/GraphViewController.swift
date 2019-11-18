//
//  GraphViewController.swift
//  FynzoSurvey
//
//  Created by Satish Phogat on 08/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    let simplePieChartView = SimplePieChartView()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: GraphTableViewCell.self)
        }
    }

    var graphArray = [GraphDetailView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Graph Report", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        tableView.reloadData()
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension GraphViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return graphArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 372
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GraphHeaderView.instanceFromNib()
        let dynamicQuestion = (graphArray[section].questions.first ?? Question()).questions
        
        var segments = [Segment]()
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.blue, UIColor.green]
        if dynamicQuestion.isEmpty {
            let count = (graphArray[section].questions.filter { $0.detailResponseAnswer != "<null>" || $0.detailResponseAnswer.isEmpty }.map { $0.detailResponseAnswer }).count
            if count == 0 {
                return UIView()
            }
            let percentage = Double(100 / count)
            
            for index in 1...count {
                let segment = Segment(color: colors[index], value: CGFloat(percentage))
                segments.append(segment)
            }
            
            headerView.graphView.segments = segments
            
            if section == 3 {
                headerView.speedometerContainerView.isHidden = false
            } else {
                headerView.graphView.isHidden = false
            }
            
        } else {
            var graphCounter = 0
            for item in graphArray[section].questions where !item.rawStringArray.isEmpty {
                graphCounter += 1
            }
            let percentage = Double(100 / graphCounter)
            headerView.graphView.isHidden = false
            for index in 1...graphCounter {
                let segment = Segment(color: colors[index], value: CGFloat(percentage))
                segments.append(segment)
            }
            headerView.graphView.segments = segments
        }
        headerView.titleLabel.text = graphArray[section].questionText
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let res = (graphArray[section].questions.first ?? Question()).questions
        
        return res.isEmpty ? 5 : res.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GraphTableViewCell.self)
        let graphObj = graphArray[indexPath.section].questions
        let dynamicQuestion = (graphArray[indexPath.section].questions.first ?? Question()).questions
        
        if !dynamicQuestion.isEmpty {
            cell.titleLabel.isHidden = false
            cell.starView.isHidden = true
            cell.titleLabel.text = dynamicQuestion[indexPath.row].choice
            
            let value = graphObj.filter({$0.detailResponseAnswer == String(indexPath.row + 1)}).isEmpty ? "null" : String(graphObj.filter({$0.detailResponseAnswer == String(indexPath.row + 1)}).count)
            cell.valueLabel.text = value
            if cell.valueLabel.text != "null" {
                let numberOfValues = graphObj.filter({$0.detailResponseAnswer != "<null>"}).count / (Int(value ) ?? 0)
                cell.percentageLabel.text = String(Double(100 / numberOfValues)) + "%"
            } else {
                cell.percentageLabel.text = "0.00%"
            }
            let responseString = graphObj.map({$0.rawStringArray.first ?? ""})
            var stringArray = [""]
            for id in responseString {
                for obj in (graphObj.first?.questions ?? [Question()]) where obj.id == id {
                    stringArray.append(obj.choice)
                }
            }
            print(stringArray)
            var numberOfTimeValuePresent = 0
            for value in stringArray where value == cell.titleLabel.text {
                numberOfTimeValuePresent += 1
            }
            cell.valueLabel.text = String(numberOfTimeValuePresent)
            if numberOfTimeValuePresent == 0 {
                cell.percentageLabel.text = "0.00"
            } else {
                cell.percentageLabel.text = String(Double(100 / (stringArray.count - 1) / numberOfTimeValuePresent)) + "%"
            }
            //let responseValue = graphArray[indexPath.section].questions[indexPath.row].rawStringArray.first ?? ""
            
        } else {
            cell.starView.isHidden = false
            cell.titleLabel.isHidden = true
            cell.starView.rating = Double(indexPath.row + 1)
            let value = graphObj.filter({$0.detailResponseAnswer == String(indexPath.row + 1)}).isEmpty ? "null" : String(graphObj.filter({$0.detailResponseAnswer == String(indexPath.row + 1)}).count)
            cell.valueLabel.text = value
            if cell.valueLabel.text != "null" {
                let numberOfValues = graphObj.filter({$0.detailResponseAnswer != "<null>"}).count / (Int(value ) ?? 0)
                cell.percentageLabel.text = String(Double(100 / numberOfValues)) + "%"
            } else {
                cell.percentageLabel.text = "0.00%"
            }
        }
        
       return cell
    }
}
