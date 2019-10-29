//
//  TemplatesViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 27/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import ALCameraViewController
import SwiftyJSON

class TemplatesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: HomeTableViewCell.self)
        }
    }
    
    var category = Category()
    var selectedForms = [Form]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoryTemplates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Templates", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getCategoryTemplates() {
        FynzoWebServices.shared.getCategoryTemplate(controller: self) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handlegetCategoryTemplatesSuccess(json)
            
        }
    }
    
    private func handlegetCategoryTemplatesSuccess(_ json: JSON) {
        let categoryTemplates = Category.models(from: json.arrayValue)
        let selectedCategoryList = categoryTemplates.filter({$0.categoryId == category.id})
        getFormsApi(selectedCategoryList)
    }
    
    private func getFormsApi(_ categories: [Category]) {
        FynzoWebServices.shared.surveyForms(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.userId: AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? ""]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSurveyFormsSuccess(json, categories)
        }
    }
    
    private func handleSurveyFormsSuccess(_ json: JSON, _ categories: [Category]) {
       let forms = Form.models(from: json.arrayValue)
        var selectedForm = [Form]()
        for category in categories {
            selectedForm += forms.filter({$0.copiedFrom == category.surveyFormId})
        }
       selectedForms = selectedForm.unique(map: {$0.copiedFrom})
        tableView.reloadData()
    }
    
    func openPicker(_ sender: UIButton) {
        var croppingParameters: CroppingParameters {
            return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 60, height: 60))
        }
        let actionSheet = KPActionSheet(items: [
            KPItem(title: Fynzo.ButtonTitle.importForm, titleColor: Fynzo.ColorCode.black, onTap: {
                
            }),
            KPItem(title: Fynzo.ButtonTitle.preview, titleColor: Fynzo.ColorCode.black, onTap: {
            }),
            ])
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @objc func startButtonAction(_ sender: UIButton) {
        openPicker(sender)
    }
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

extension TemplatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeTableViewCell.self)
        
        cell.startButton.addTarget(self, action: #selector(startButtonAction(_:)), for: .touchUpInside)
        cell.label.text = selectedForms[indexPath.row].name
        
        return cell
    }
}

extension TemplatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ResponseDetailViewController.instantiate(fromAppStoryboard: .Home)
        navigationController?.pushViewController(controller, animated: true)
    }
}


