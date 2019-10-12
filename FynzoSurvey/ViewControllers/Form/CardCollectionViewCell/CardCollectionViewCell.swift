//
//  CardCollectionViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//



import UIKit

class CardCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: CardInnerCollectionViewCell.self)
        }
    }
    
    let numberOfCell: CGFloat = 10
}

extension CardCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardInnerCollectionViewCell.self)
                
        return cell
    }
}

extension CardCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width - 20) / 10, height: 50)
    }
}


