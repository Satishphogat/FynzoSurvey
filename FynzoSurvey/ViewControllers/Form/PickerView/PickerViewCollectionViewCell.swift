//
//  PickerViewCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 29/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class PickerViewCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: PickerViiewTableViewCell.self)
        }
    }
    
    var questionnaries = [Questionnaire]() {
        didSet {
            titleLable.text = questionnaries.first?.questingText
        }
    }
    var completion: (([Questionnaire]) -> Void)?
}

extension PickerViewCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PickerViiewTableViewCell.self)
        
        return cell
    }
}
