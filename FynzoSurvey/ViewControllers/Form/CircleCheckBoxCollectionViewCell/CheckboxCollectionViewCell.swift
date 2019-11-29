//
//  CheckboxCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//


import UIKit

class CheckboxCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: CheckBoxInnerCollectionViewCell.self)
        }
    }
    
    var questionary = Questionnaire()
    var completion: ((Questionnaire) -> Void)?
}

extension CheckboxCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionary.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckBoxInnerCollectionViewCell.self)
        
        let question = questionary.questions[indexPath.item]
        cell.title.text = question.choice
        cell.imageView.image = question.isSelected ? Fynzo.Image.radioFilled.imageWithColor(color: .white) : Fynzo.Image.radioEmpty.imageWithColor(color: .white)
            
            return cell
    }
}

extension CheckboxCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //questionary.questions = questionary.questions.map({$0.isSelected = false})
        questionary.questions[indexPath.item].isSelected = true
        collectionView.reloadData()
        completion?(questionary)
    }
}

extension CheckboxCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 100) / 2, height: 50)
    }
    
}

