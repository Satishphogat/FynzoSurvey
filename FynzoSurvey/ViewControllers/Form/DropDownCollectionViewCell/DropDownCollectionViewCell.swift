//
//  DropDownCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 18/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class DropDownCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var label: UILabel! 

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: DropDownTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var questionaries = [Questionnaire]()
    var completion: (([Questionnaire]) -> Void)?
    
    @IBAction func openPicker(_ sender: UIButton) {
        PickerView.shared.showPicker(questionaries.first?.questions.map({$0.choice}) ?? [""]) { (item) in
            if item == nil {
                return
            }
            self.questionaries[sender.tag].question.choice = item as? String ?? ""
            self.questionaries[sender.tag].question.isSelected = !self.questionaries[sender.tag].question.isSelected
            self.completion?(self.questionaries)
            self.tableView.reloadData()
        }
    }
}

extension DropDownCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DropDownTableViewCell.self)
        
        if (questionaries.first?.questions.map({$0.choice}) ?? [""]).isEmpty {
            cell.button.setTitle(questionaries[indexPath.row].questingText, for: .normal)
        } else {
            cell.button.setTitle((questionaries.first?.questions.map({$0.choice}) ?? [""]).first, for: .normal)
        }
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
        
        return cell
    }
}

extension DropDownCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

