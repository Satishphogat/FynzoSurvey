//
//  HomeViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 10/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import SwiftyJSON
import ALCameraViewController
import LocalAuthentication

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: HomeTableViewCell.self)
        }
    }
    @IBOutlet weak var lastUpdateTime: UILabel! {
        didSet {
            let updatedTime = AppUserDefaults.value(forKey: .homeRefreshTime, fallBackValue: "") as? String ?? ""
            if !updatedTime.isEmpty {
                lastUpdateTime.text = "Last Updated " + updatedTime
            } else {
                lastUpdateTime.text = ""
            }
        }
    }
    @IBOutlet weak var localDataLabel: UILabel! {
        didSet {
            if let updatedTime = AppUserDefaults.value(forKey: .form, fallBackValue: "") as? [[String: Any]] {
                localDataLabel.text = "\(updatedTime.count) stored locally"
            } else {
                localDataLabel.text = "0 stored locally"
            }
        }
    }
    @IBOutlet weak var localFormImageView: UIImageView! {
        didSet {
            localFormImageView.image = #imageLiteral(resourceName: "referesh").imageWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
    }
    @IBOutlet weak var uploadDataImageView: UIImageView! {
        didSet {
            uploadDataImageView.image = #imageLiteral(resourceName: "uploadLoacal").imageWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
    }
    @IBOutlet weak var bgView: UIView!
    
    var isDemoSurvey = false
    var forms = [Form]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFormsApi()
        addFloatingButton()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Fynzo Survey", leftBarImage: #imageLiteral(resourceName: "ic_menu"), leftSelector: #selector(leftButtonAction))
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func leftButtonAction() {
        if isDemoSurvey {
            navigationController?.popViewController(animated: true)
        } else {
            openMenu()
        }
    }
    
    @objc func pullToRefresh() {
        getFormsApi()
        refreshControl.endRefreshing()
    }
    
    private func getFormsApi() {
        let id = isDemoSurvey ? "1" : AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? ""
        FynzoWebServices.shared.surveyForms(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.userId: id]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSurveyFormsSuccess(json)
        }
    }
    
    private func handleSurveyFormsSuccess(_ json: JSON) {
        AppUserDefaults.save(value: Date().getDateString("dd-MMM-yy, hh:mm a"), forKey: .homeRefreshTime)
        lastUpdateTime.text = "Last Updated " + Date().getDateString("dd-MMM-yy, hh:mm a")
        forms = Form.models(from: json.arrayValue)
        if forms.isEmpty {
            customizedAlert(message: "No Survey found")
        }
        tableView.reloadData()
    }
    
    func openPicker(_ sender: UIButton) {
        var croppingParameters: CroppingParameters {
            return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 60, height: 60))
        }
        let actionSheet = KPActionSheet(items: [
            KPItem(title: Fynzo.ButtonTitle.openWithOutLock, titleColor: Fynzo.ColorCode.black, onTap: {
                self.openForm(sender.tag)
            }),
            KPItem(title: Fynzo.ButtonTitle.openWithLock, titleColor: Fynzo.ColorCode.black, onTap: {
                self.openWithLock(sender.tag)
            }),
            KPItem(title: Fynzo.ButtonTitle.shareUrl, titleColor: Fynzo.ColorCode.black, onTap: {
                self.openShareScreen(sender.tag)
            }),
            KPItem(title: Fynzo.ButtonTitle.responseReport, titleColor: Fynzo.ColorCode.black, onTap: {
                self.openReportScreen(sender.tag)
            }),
            KPItem(title: Fynzo.ButtonTitle.edit, titleColor: Fynzo.ColorCode.black, onTap: {
            }),
            ])
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func openWithLock(_ index: Int) {
        authenticationWithTouchID(true, index)
    }
    
    private func openForm(_ index: Int) {
        let controller = FormViewController.instantiate(fromAppStoryboard: .Home)
        controller.form = forms[index]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func openShareScreen(_ index: Int) {
        let controller = ShareViewController.instantiate(fromAppStoryboard: .Home)
        controller.form = forms[index]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func openReportScreen(_ index: Int) {
        let controller = ReportViewController.instantiate(fromAppStoryboard: .Home)
        controller.form = forms[index]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func addFloatingButton() {
        let actionButton = JJFloatingActionButton()
        
        actionButton.addItem(title: "Create New Survey", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
            
        }
        
        actionButton.addItem(title: "Import Survey From Templates", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
            let controller = ImportTemplateSurveyViewController.instantiate(fromAppStoryboard: .Home)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        actionButton.display(inView: bgView)
        bgView.addSubview(actionButton)
    }
    
    @objc func startButtonAction(_ sender: UIButton) {
        let savedData = UserDefaults.standard.value(forKey: "Auth" + self.forms[sender.tag].id) as? Bool ?? false
        
        if isDemoSurvey {
            openForm(sender.tag)
        } else if savedData {
            authenticationWithTouchID(false, sender.tag)
        } else {
            openPicker(sender)
        }
    }
    
    @IBAction func updateSurveyButtonAction(_ sender: UIButton) {
        getFormsApi()
    }

    @IBAction func uploadLocalDataButtonAction(_ sender: UIButton) {
        if var updatedTime = AppUserDefaults.value(forKey: .form, fallBackValue: "") as? [[String: Any]] {
            localDataLabel.text = "\(updatedTime.count) stored locally"
            for index in 0..<updatedTime.count {
                FynzoWebServices.shared.submitForm(controller: self, parameters: updatedTime[index]) { [weak self](json, error) in
                    guard let `self` = self else { return }
                    
                    AppUserDefaults.removeValue(forKey: .form)
                    self.localDataLabel.text = "0 stored locally"
                }
            }
        }
    }
 }

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeTableViewCell.self)
        
        cell.label.text = forms[indexPath.row].name
        cell.startButton.tag = indexPath.row
        cell.startButton.addTarget(self, action: #selector(startButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension HomeViewController {
    
    func authenticationWithTouchID(_ isSaveSurvey: Bool, _ index: Int) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Enter Passcode"
        
        var authError: NSError?
        let reasonString = "To secure this survey with your passcode"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    if isSaveSurvey {
                        UserDefaults.standard.set(true, forKey: "Auth" + self.forms[index].id)
                    }
                    self.openForm(index)
                }
            }
        } else {
            customizedAlert(message: "Your device does not support Touch Id.")
        }
    }
}
