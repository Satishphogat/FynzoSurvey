//
//  StarCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell, NibReusable {

    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: StarTableViewCell.self)
        }
    }
}

extension StarCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: StarTableViewCell.self)
        
        cell.ratingView.didFinishTouchingCosmos = { rating in
            
        }
        
        return cell
    }
}

extension StarCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

