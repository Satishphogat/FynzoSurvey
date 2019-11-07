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
    var completion: ((Questionnaire) -> Void)?
}

extension CardCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(questionnaire.question.scale) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardInnerCollectionViewCell.self)
        
        cell.label.text = String(indexPath.item + 1)
        cell.backgroundColor = indexPath.item == questionnaire.question.selectedScale ? .white : .clear
        cell.label.textColor = indexPath.item == questionnaire.question.selectedScale ? .black : .white
        completion?(questionnaire)

        
        return cell
    }
}

extension CardCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //questionary.questions = questionary.questions.map({$0.isSelected = false})
        questionnaire.question.selectedScale = indexPath.item
        collectionView.reloadData()
        completion?(questionnaire)
    }
}

extension CardCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell = Float(questionnaire.question.scale) ?? 0.0
        
        return CGSize(width: (collectionView.frame.size.width) / CGFloat.init(numberOfCell), height: 50)
    }
}


