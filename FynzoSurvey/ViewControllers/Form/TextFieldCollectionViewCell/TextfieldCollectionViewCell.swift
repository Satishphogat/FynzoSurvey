//
//  TextfieldCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//


import UIKit

class TextfieldCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: TextfieldTableViewCell.self)
        }
    }
    var questionnaries = [Questionnaire]()
    var completion: (([Questionnaire]) -> Void)?
}

extension TextfieldCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TextfieldTableViewCell.self)
        cell.label.text = questionnaries[indexPath.row].questingText
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        
        return cell
    }
}

extension TextfieldCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension TextfieldCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        questionnaries[textField.tag].answer = textField.text ?? ""
        if textField.tag == questionnaries.count - 1 {
          completion?(questionnaries)
        }
    }
}



