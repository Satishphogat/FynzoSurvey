//
//  SettingViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 10/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: SettingTableViewCell.self)
        }
    }
    
    var sections = [Fynzo.LabelText.account, Fynzo.LabelText.plan, Fynzo.LabelText.app, Fynzo.LabelText.uploadSetting]
    
    var dataArray = [[Fynzo.LabelText.Email], [Fynzo.LabelText.name, Fynzo.LabelText.startDate, Fynzo.LabelText.endDate], [Fynzo.LabelText.version], [Fynzo.LabelText.autoUpload]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Setting", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        
    }
    
    @objc func leftButtonAction() {
        openMenu()
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingTableViewCell.self)
        
        cell.titleLabel.text = dataArray[indexPath.section][indexPath.row]
        cell.separator.isHidden = !(indexPath.row ==  dataArray[indexPath.section].count - 1)
        
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        returnedView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.text = sections[section]
        label.textColor = AppDelegate.shared.appThemeColor
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
