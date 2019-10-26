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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: HomeTableViewCell.self)
        }
    }
    
    var dataArray = [Fynzo.LabelText.Email, Fynzo.LabelText.name, Fynzo.LabelText.startDate, Fynzo.LabelText.endDate, Fynzo.LabelText.version, Fynzo.LabelText.autoUpload]
    
    var forms = [Form]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFormsApi()
        addFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Fynzo Survey", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func leftButtonAction() {
        openMenu()
    }
    
    private func getFormsApi() {
        FynzoWebServices.shared.surveyForms(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.userId: AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? ""]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSurveyFormsSuccess(json)
        }
    }
    
    private func handleSurveyFormsSuccess(_ json: JSON) {
        forms = Form.models(from: json.arrayValue)
        tableView.reloadData()
    }
    
    private func addFloatingButton() {
        let actionButton = JJFloatingActionButton()
        
        actionButton.addItem(title: "Create New Survey", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        
        actionButton.addItem(title: "Import Survey From Templates", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        
        actionButton.display(inView: self.view)
        view.addSubview(actionButton)
    }
    
    @objc func startButtonAction(_ sender: UIButton) {
        let index = sender.tag
        
        let controller = FormViewController.instantiate(fromAppStoryboard: .Home)
        controller.form = forms[index]
        navigationController?.pushViewController(controller, animated: true)
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
