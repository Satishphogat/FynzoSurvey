//
//  FormViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON

class FormViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: FirstCollectionViewCell.self)
            collectionView.register(cellType: StarCollectionViewCell.self)
            collectionView.register(cellType: CheckboxCollectionViewCell.self)
            collectionView.register(cellType: SquareCollectionViewCell.self)
            collectionView.register(cellType: CardCollectionViewCell.self)
            collectionView.register(cellType: TextfieldCollectionViewCell.self)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var form = Form()
    var questionnairies: [[Questionnaire]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        getFormsApi()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func getFormsApi() {
        FynzoWebServices.shared.getQuestionnaire(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.userId: AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? "", Fynzo.ApiKey.surveyform_id: form.id]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSurveyFormsSuccess(json)
        }
    }
    
    private func handleSurveyFormsSuccess(_ json: JSON) {
        let questionnaire = Questionnaire.models(from: json[Fynzo.ApiKey.questionnaire].arrayValue)
        let screens = Set(questionnaire.map({$0.screenNo})).sorted()
        questionnairies.removeFirst()
        for screen in screens.sorted() {
            let screenTypeArray = questionnaire.filter({$0.screenNo == screen})
            questionnairies.append(screenTypeArray)
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func previousButtonAction() {
        let collectionBounds = collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - collectionBounds.size.width))
        moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func nextButtonAction() {
        let collectionBounds = collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : collectionView.contentOffset.y ,width : collectionView.frame.width,height : collectionView.frame.height)
        collectionView.scrollRectToVisible(frame, animated: true)
    }
}

extension FormViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionnairies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let questionary = questionnairies[indexPath.item]
        
        if questionary.isEmpty {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FirstCollectionViewCell.self)
            
            return cell
        }
        
        if questionary.last?.questionTypeId == "0" {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FirstCollectionViewCell.self)
            
            cell.topLabel.text = !questionary.isEmpty ? questionary[0].questingText : ""
            cell.bottomLabel.text = questionary.count >= 2 ? questionary[1].questingText : ""
        
        return cell
        } else if questionary.last?.questionTypeId == "5" && ((questionary.last?.questions.first ?? Question()).labels != Fynzo.LabelText.veryLikelyUnlikely) {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: StarCollectionViewCell.self)
            
            let questionArray = questionary.filter({$0.questionTypeId == "5"})
            cell.questionaries = questionArray
            
            return cell
        } else if questionary.last?.questionTypeId == "3" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckboxCollectionViewCell.self)
            
            cell.titleLabel.text = questionnairies[indexPath.item].first?.questingText
            cell.questionary = questionary.filter({$0.questionTypeId == "3"}).first ?? Questionnaire()
            
            return cell
        } else if questionary.last?.screenNo == "6" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SquareCollectionViewCell.self)
            
            return cell
        } else if questionary.last?.questionTypeId == "5" && ((questionary.last?.questions.first ?? Question()).labels == Fynzo.LabelText.veryLikelyUnlikely) {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCollectionViewCell.self)
            
            cell.questionnaire = questionary.filter({$0.questionTypeId == "5"}).first ?? Questionnaire() 
            
            return cell
        } else if questionary.last?.questionTypeId == "1" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TextfieldCollectionViewCell.self)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FirstCollectionViewCell.self)
            
            return cell
        }
    }
}

extension FormViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}


class FormBoldLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
        self.textColor = .white
        self.font = FynzoFont.bold(size: Fynzo.FontSize.extraLarge)
    }
}

class FormLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
        self.textColor = .white
        self.font = FynzoFont.medium(size: Fynzo.FontSize.extraLarge)
    }
}

class FormButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set other operations after super.init, if required
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init if required
        setTitleColor(.white, for: .normal)
        titleLabel?.font = FynzoFont.medium(size: Fynzo.FontSize.extraLarge)
        tintColor = .white
    }
    
}
