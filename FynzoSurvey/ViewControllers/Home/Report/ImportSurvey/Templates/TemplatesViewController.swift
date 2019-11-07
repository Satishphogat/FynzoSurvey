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
                self.importSurvey(self.selectedForms[sender.tag])
            }),
            KPItem(title: Fynzo.ButtonTitle.preview, titleColor: Fynzo.ColorCode.black, onTap: {
                self.preview(self.selectedForms[sender.tag])
            }),
            ])
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func importSurvey(_ form: Form) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Form Name"
            textField.text = form.name
        }
        let impoprtAction = UIAlertAction(title: "Import", style: .default, handler: { alert -> Void in
            let nametxt = alertController.textFields![0] as UITextField
            if (nametxt.text ?? "").isEmpty {
                self.customizedAlert(message: "Please Enter Form Name")
            } else {
                self.importApi(form, surveyName: nametxt.text ?? "")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(impoprtAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func importApi(_ form: Form, surveyName: String) {
        let dict = [
            "from_surveyform_id": form.id,
            "to_userid": AppUserDefaults.value(forKey: .id, fallBackValue: "") as? String ?? "",
            "to_form_name": surveyName
        ]
        
        FynzoWebServices.shared.importSurvey(parameters: dict, controller: self) { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            
            self.customizedAlert(withTitle: "Success", message: "Imported success", iconImage: #imageLiteral(resourceName: "ic_success"), buttonTitles: ["OK"], afterDelay: 0.5, completion: { (_) in
                UserManager.shared.moveToHomeViewController()
            })
        }
    }
    
    private func preview(_ form: Form) {
        let controller = FormViewController.instantiate(fromAppStoryboard: .Home)
        controller.form = form
        navigationController?.pushViewController(controller, animated: true)
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
        cell.startButton.tag = indexPath.row
        
        return cell
    }
}

extension TemplatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


