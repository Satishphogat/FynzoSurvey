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
    var completion: ((Questionnaire) -> Void)?
    
    override func endEditing(_ force: Bool) -> Bool {
        return true
    }
}

extension SquareCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionary.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckBoxInnerCollectionViewCell.self)
        
        let question = questionary.questions[indexPath.item]
        
        cell.title.text = question.choice
        cell.imageView.image = question.isSelected ? Fynzo.Image.filledCheckbox.imageWithColor(color: .white) : Fynzo.Image.emptyCheckbox.imageWithColor(color: .white)
        
        return cell
    }
}

extension SquareCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        questionary.questions[indexPath.item].isSelected = !questionary.questions[indexPath.item].isSelected
        collectionView.reloadData()
        completion?(questionary)
    }
}

extension SquareCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 50)
    }
    
}


