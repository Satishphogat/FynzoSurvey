//
//  SettingViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 10/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: SettingTableViewCell.self)
        }
    }
    
    var sections = [Fynzo.LabelText.account, Fynzo.LabelText.plan, Fynzo.LabelText.app, Fynzo.LabelText.uploadSetting]
    
    var placeholderArray = [[Fynzo.LabelText.Email], [Fynzo.LabelText.name, Fynzo.LabelText.startDate, Fynzo.LabelText.endDate], [Fynzo.LabelText.version], [Fynzo.LabelText.autoUpload]]
    
    var userInfo = UserInfo()
    var versionNumber = ""
    
    var dataArray = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDetailApi()
        versionNumber = (SwifterSwift.appVersion ?? "") + "." + (SwifterSwift.appBuild ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Setting", leftBarImage: #imageLiteral(resourceName: "ic_menu"), leftSelector: #selector(leftButtonAction))
        
    }
    
    @objc func leftButtonAction() {
        openMenu()
    }
    
    private func getUserDetailApi() {
        FynzoWebServices.shared.settings(showHud: dataArray.isEmpty, controller: self, parameters: ["user_id": AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? ""]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSignUpSuccess(json)
        }
    }
    
    private func handleSignUpSuccess(_ json: JSON) {
        let isAutoUpload = AppUserDefaults.value(forKey: .isAutoUpload, fallBackValue: false) as? Bool ?? false
        userInfo = UserInfo(json: json)
        dataArray = [[userInfo.email], [userInfo.plan.name, userInfo.plan.startDate.getCustomizedDate(), userInfo.plan.endDate.getCustomizedDate()], [versionNumber], ["\(isAutoUpload)"]]
        AppUserDefaults.save(value: dataArray, forKey: .settings)
        tableView.reloadData()
    }
    
    @objc private func switchClicked() {
        let isAutoUpload = AppUserDefaults.value(forKey: .isAutoUpload, fallBackValue: false) as? Bool ?? false
        AppUserDefaults.save(value: !isAutoUpload, forKey: .isAutoUpload)
        dataArray[3] = ["\(!isAutoUpload)"]
        tableView.reloadData()
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeholderArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingTableViewCell.self)
        
        cell.titleLabel.text = placeholderArray[indexPath.section][indexPath.row]
        cell.separator.isHidden = !(indexPath.row ==  placeholderArray[indexPath.section].count - 1)
        cell.mySwitch.isHidden = true
        cell.subTitleLabel.isHidden = false
        
        if dataArray.isEmpty {
            return cell
        }
        if placeholderArray[indexPath.section][indexPath.row] == Fynzo.LabelText.autoUpload {
            cell.mySwitch.isHidden = false
            cell.subTitleLabel.isHidden = true
            cell.mySwitch.isOn = dataArray[indexPath.section][indexPath.row] == "true"
            cell.mySwitch.addTarget(self, action: #selector(switchClicked), for: .valueChanged)
        }
        cell.subTitleLabel.text = dataArray[indexPath.section][indexPath.row]

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
