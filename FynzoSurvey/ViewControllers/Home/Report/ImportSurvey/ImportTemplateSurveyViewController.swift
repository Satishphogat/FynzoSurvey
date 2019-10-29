//
//  ImportTemplateSurveyViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 27/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import Kingfisher

class ImportTemplateSurveyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ImportTamplateSurveyTableViewCell.self)
        }
    }
    
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Templates", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        tableView.reloadData()
    }
    
    @objc func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getCategories() {
        FynzoWebServices.shared.getCategories(controller: self) { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            
            self.categoryList = Category.models(from: json.arrayValue)
            self.tableView.reloadData()
        }
    }
}

extension ImportTemplateSurveyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ImportTamplateSurveyTableViewCell.self)
        let category = categoryList[indexPath.row]
        cell.label.text = category.name
        if let url = URL(string: AppConfiguration.appUrl + category.icon) {
            cell.cellImageView.kf.setImage(with: url)
        }
        
        return cell
    }
}

extension ImportTemplateSurveyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TemplatesViewController.instantiate(fromAppStoryboard: .Home)
        controller.category = categoryList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}


