//
//  ResponseViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

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
        let controller = ResponseDetailViewController.instantiate(fromAppStoryboard: .Home)
        controller.graphResponse = graphReport
        controller.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

