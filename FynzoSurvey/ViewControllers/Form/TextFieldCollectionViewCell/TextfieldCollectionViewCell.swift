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
    
}

extension TextfieldCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TextfieldTableViewCell.self)
        
        return cell
    }
}

extension TextfieldCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}



