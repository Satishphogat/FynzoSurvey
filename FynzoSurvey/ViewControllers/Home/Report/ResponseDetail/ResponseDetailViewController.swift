//
//  ResponseDetailViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class ResponseDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ResponseDetailTableViewCell.self)
        }
    }
    
    var questionResponse = [Question]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Response", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        navigationController?.navigationBar.isHidden = false
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
        }
        cell.starView.isHidden = !cell.titleLabel.isHidden
        cell.titleLabel.text = question.detailResponseAnswer == "<null>" ? "skipped" : question.detailResponseAnswer
        
        return cell
    }
}

extension ResponseDetailViewController: UITableViewDelegate {
    
}
