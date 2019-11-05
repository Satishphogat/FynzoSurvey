//
//  StarCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var label: UILabel! 
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: StarTableViewCell.self)
        }
    }
    
    var questionaries = [Questionnaire]()
    var completion: (() -> Void)?
}

extension StarCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: StarTableViewCell.self)
        
        cell.label.text = questionaries.count  == 1 ? "" : questionaries[indexPath.row].questingText
        cell.ratingView.didFinishTouchingCosmos = { rating in
            self.questionaries[indexPath.row].selectedStars = Int(rating)
            if (self.questionaries.filter({$0.selectedStars == 0})).isEmpty {
                self.completion?()
            }
        }
        
        return cell
    }
}

extension StarCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

