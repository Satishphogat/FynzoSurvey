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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section + 1). " + questionResponse[section].questionText
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ResponseDetailTableViewCell.self)
        cell.titleLabel.text = questionResponse[indexPath.section].questionText
        
        return cell
    }
}

extension ResponseDetailViewController: UITableViewDelegate {
    
}
