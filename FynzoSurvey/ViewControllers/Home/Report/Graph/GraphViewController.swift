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
    let starColors = [#colorLiteral(red: 0.3098039216, green: 0.5137254902, blue: 0.7254901961, alpha: 1), #colorLiteral(red: 0.7490196078, green: 0.3098039216, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.6117647059, green: 0.7294117647, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.7490196078, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.4862745098, green: 0.4039215686, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.5803921569, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.3098039216, green: 0.5137254902, blue: 0.7254901961, alpha: 1), #colorLiteral(red: 0.7490196078, green: 0.3098039216, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.6117647059, green: 0.7294117647, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.7490196078, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.4862745098, green: 0.4039215686, blue: 0.6235294118, alpha: 1)]
    var meeterStaticArr = [(title: "Detractors", value: ""), (title: "Passive", value: ""), (title: "Promoters", value: "")]
    
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
        let dynamicQuestion = graphArray[section].questions.first ?? Question()
        headerView.speedometerContainerView.isHidden = true
        headerView.graphView.isHidden = false

        var segments = [Segment]()
        
        if dynamicQuestion.questionTypeId == "5" && dynamicQuestion.question.isNps == "1" {
            headerView.speedometerContainerView.isHidden = false
            headerView.graphView.isHidden = true
            let ansArray = graphArray[section].questions.map { $0.detailResponseAnswer }
            var prometrs = 0
            var detractors = 0
            for item in ansArray {
                if (Int(item) ?? 0) >= 9 {
                    prometrs += 1
                } else if (Int(item) ?? 0) < 7 {
                    detractors += 1
                }
            }
            let meterValue = ((prometrs - detractors) / 100) * 100
            headerView.netPromoterValueLabel.text = "\(meterValue)"
            headerView.speedometerView.needleValue = CGFloat((meterValue == 0 ? 1 : meterValue) / 2 + 50)
        } else if dynamicQuestion.questions.isEmpty {
            let ansArray = graphArray[section].questions.map { $0.detailResponseAnswer }
            var starArray = [false, false, false, false, false, false]
            for item in ansArray {
                let val = Int(item) ?? 0
                if val < 6 {
                    starArray[val] = true
                }
            }
            starArray.removeFirst()
            let percentage = Double(100 / (starArray.filter {$0}.count))
            var colors = [UIColor]()
            for index in (0..<starArray.count) {
                if starArray[index] {
                    colors.append(starColors[index])
                }
            }
            for index in (0..<starArray.filter {$0}.count) {
                let segment = Segment(color: colors[index], value: CGFloat(percentage))
                segments.append(segment)
            }
            
            headerView.graphView.segments = segments
        } else {
            let graphObj = graphArray[section].questions
            let responseString = graphObj.map({$0.rawStringArray.first ?? ""})
            var stringArray = [String]()
            for id in responseString {
                for obj in (graphObj.first?.questions ?? [Question()]) where obj.id == id {
                    stringArray.append(obj.choice)
                }
            }
            var colors = [UIColor]()
            let questionTitles = (graphArray[section].questions.first ?? Question()).questions
            for index in (0..<(questionTitles.map { $0.choice }).count) {
                if stringArray.contains((questionTitles.map { $0.choice })[index]) {
                    colors.append(starColors[index])
                }
            }
            let percentage = Double(100 / colors.count)
            for item in colors {
                let segment = Segment(color: item, value: CGFloat(percentage))
                segments.append(segment)
            }
            headerView.graphView.segments = segments
        }
        headerView.titleLabel.text = graphArray[section].questionText
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let res = (graphArray[section].questions.first ?? Question()).questions
        let dynamicQuestion = graphArray[section].questions.first ?? Question()
        if dynamicQuestion.questionTypeId == "5" && dynamicQuestion.question.isNps == "1" {
            return meeterStaticArr.count
        } else {
            return res.isEmpty ? 5 : res.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let headerQuesttype = graphArray[indexPath.section].questions.first ?? Question()
        if headerQuesttype.questionTypeId == "5" && headerQuesttype.question.isNps == "1" {
            return meeterCell(indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GraphTableViewCell.self)
        let graphObj = graphArray[indexPath.section].questions
        let dynamicQuestion = (graphArray[indexPath.section].questions.first ?? Question()).questions
        cell.sideIndecatorLabel.backgroundColor = starColors[indexPath.row]
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
    
    private func meeterCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GraphTableViewCell.self)
        cell.titleLabel.isHidden = false
        cell.starView.isHidden = true
        cell.titleLabel.text = meeterStaticArr[indexPath.row].title
        
        let ansArray = graphArray[indexPath.section].questions.map { $0.detailResponseAnswer}
        let arrayWithoutNull = ansArray.filter({$0 != "<null>"})
        meeterStaticArr[0].value = String(arrayWithoutNull.filter({Int($0) ?? 0 < 7}).count)
        meeterStaticArr[1].value = String(arrayWithoutNull.filter({Int($0) ?? 0 > 6 && Int($0) ?? 0 < 9}).count)
        meeterStaticArr[2].value = String(arrayWithoutNull.filter({Int($0) ?? 0 > 8}).count)

        cell.valueLabel.text = meeterStaticArr[indexPath.row].value
        if var count = Int(meeterStaticArr[indexPath.row].value), count > 0 {
            count = count == 0 ? 1 : count
            let arrayCount = arrayWithoutNull.isEmpty ? 1 : arrayWithoutNull.count
            let temp = arrayCount / count
            cell.percentageLabel.text = String(100 / temp) + "%"
        } else {
            cell.percentageLabel.text =  "0 %"

        }
//        headerView.netPromoterValueLabel.text = "\(meterValue)"
//        headerView.speedometerView.arcAngle = CGFloat(meterValue)
        
        return cell
    }
}
