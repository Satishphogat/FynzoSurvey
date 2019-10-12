//
//  SquareCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//



import UIKit

class SquareCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: CheckBoxInnerCollectionViewCell.self)
        }
    }
}

extension SquareCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckBoxInnerCollectionViewCell.self)
        
        cell.titleButton.setImage(UIImage.init(named: "empty_square_checkbox"), for: .normal)
        
        return cell
    }
}

extension SquareCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 50)
    }
    
}


