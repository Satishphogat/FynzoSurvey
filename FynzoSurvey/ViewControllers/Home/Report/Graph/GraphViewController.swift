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

    var graphArray = [String: [String]]()
    
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
        return graphArray.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 372
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GraphHeaderView.instanceFromNib()
        
        guard let graphObj = graphArray["\(Array(graphArray.keys)[section])"] else { return UIView()}

        let count = Array(Set(graphObj.filter({$0 != "<null>"}))).count
        if count == 0 {
            return UIView()
        }
        let percentage = Double(100 / count)
        var segments = [Segment]()
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.blue, UIColor.green]
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
        
        headerView.titleLabel.text = Array(graphArray.keys)[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GraphTableViewCell.self)
        let graphObj = graphArray["\(Array(graphArray.keys)[indexPath.section])"]
        
        if indexPath.section == 3 {
            cell.titleLabel.isHidden = false
            cell.starView.isHidden = true

        } else {
            cell.starView.isHidden = false
            cell.titleLabel.isHidden = true
            cell.starView.rating = Double(indexPath.row + 1)
            if let graphObj = graphObj {
                let value = graphObj.filter({$0 == String(indexPath.row + 1)}).isEmpty ? "null" : String(graphObj.filter({$0 == String(indexPath.row + 1)}).count)
                cell.valueLabel.text = value
                if cell.valueLabel.text != "null" {
                    let numberOfValues = graphObj.filter({$0 != "<null>"}).count / (Int(value ) ?? 0)
                    cell.percentageLabel.text = String(Double(100 / numberOfValues)) + "%"
                } else {
                    cell.percentageLabel.text = "0.00%"
                }
            }
        }
        
       return cell
    }
}
