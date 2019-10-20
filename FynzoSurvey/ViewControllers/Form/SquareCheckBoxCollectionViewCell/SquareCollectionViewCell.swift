//
//  SquareCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//



import UIKit

class SquareCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: CheckBoxInnerCollectionViewCell.self)
        }
    }
    
    var questionary = Questionnaire()
}

extension SquareCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionary.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckBoxInnerCollectionViewCell.self)
        
        let question = questionary.questions[indexPath.item]
        
        cell.titleButton.setTitle(question.choice, for: .normal)
        
        return cell
    }
}

extension SquareCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 50)
    }
    
}


