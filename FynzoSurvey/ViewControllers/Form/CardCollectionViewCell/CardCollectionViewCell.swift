//
//  CardCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//



import UIKit

class CardCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: CardInnerCollectionViewCell.self)
        }
    }
    
    var questionnaire = Questionnaire()
    
}

extension CardCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(questionnaire.question.scale) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardInnerCollectionViewCell.self)
        
        cell.titleButton.setTitle(String(indexPath.item), for: .normal)
        
        return cell
    }
}

extension CardCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell = Float(questionnaire.question.scale) ?? 0.0
        
        return CGSize(width: (collectionView.frame.size.width) / CGFloat.init(numberOfCell), height: 50)
    }
}


