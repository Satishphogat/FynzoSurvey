//
//  FormViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class FormViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: FirstCollectionViewCell.self)
            collectionView.register(cellType: StarCollectionViewCell.self)
            collectionView.register(cellType: CheckboxCollectionViewCell.self)
            collectionView.register(cellType: SquareCollectionViewCell.self)
            collectionView.register(cellType: CardCollectionViewCell.self)
            collectionView.register(cellType: TextfieldCollectionViewCell.self)
            collectionView.register(cellType: DropDownCollectionViewCell.self)
            collectionView.register(cellType: SubmitCollectionViewCell.self)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    
    var form = Form()
    var questionnairies: [[Questionnaire]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveToLandscape()
        getFormsApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Fynzo Survey", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        
    }
    
    @objc func leftButtonAction() {
        customizedAlert(withTitle: "Exit Feedback", message: "Are you sure you want to exit feedback", buttonTitles: ["CANCEL", "OK"]) { (index) in
            if index == 1 {
                self.moveToPortrait()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func moveToLandscape() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    private func moveToPortrait() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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
        let form = Form(json: json[Fynzo.ApiKey.surveyForm])
        //manageBackGroundData(form)

        let questionnaire = Questionnaire.models(from: json[Fynzo.ApiKey.questionnaire].arrayValue)
        let screens = Set(questionnaire.map({$0.screenNo})).sortedNumerically(.orderedAscending)
        questionnairies.removeFirst()
        
        for screen in screens.sortedNumerically(.orderedAscending) {  // number of screen
            let screenTypeArray = questionnaire.filter({$0.screenNo == screen})
            questionnairies.append(screenTypeArray)
        }
        
        var isNpsQuestionary = [Questionnaire]()  // filter stars cell
        for questionary in questionnairies {
            isNpsQuestionary.append(contentsOf: questionary.filter({$0.question.isNps == "0"}))
        }
        
        var quesetionariesForStars = [Questionnaire]()
        
        for questionary in isNpsQuestionary { // added stars to single array
            let intQuestionary = quesetionariesForStars.map({Int($0.questingNo)})
            if !intQuestionary.contains(Int(questionary.questingNo)) {
                quesetionariesForStars.append(questionary)
            }
        }
        
        isNpsQuestionary = quesetionariesForStars
        
        var updatedQuestionaries = [[Questionnaire]]()
        var isNpsAdded = false
        for questionary in questionnairies {
            var updatedQuestionary = [Questionnaire]()
            for index in 0..<questionary.count {  // for stars
                if questionary[index].questionTypeId == "5" && questionary[index].question.isNps == "0" {
                    // checked if specific star object added
                    if updatedQuestionaries.count >= 2 &&    !(updatedQuestionaries[1].filter({$0.questingNo == questionary[index].questingNo && $0.screenNo == questionary[index].screenNo})).isEmpty {
                        print(questionary[index])
                    } else if !isNpsAdded {
                        updatedQuestionary = updatedQuestionary + isNpsQuestionary
                        isNpsAdded = true
                        break
                    } else if isNpsAdded {
                        updatedQuestionary.append(questionary[index])
                    }
                        
                    
//                    if updatedQuestionary.contains(where: {$0.questingNo == questionary[index].questingNo && $0.screenNo == questionary[index].screenNo}) {
//
//                    } else
                    
                } else {
                    updatedQuestionary.append(questionary[index])
                }
            }
            updatedQuestionaries.append(updatedQuestionary)
        }
        
        questionnairies = updatedQuestionaries.filter({!$0.isEmpty})
        questionnairies.append([Questionnaire()]) // for submit screen
        
        collectionView.reloadData()
    }
    
    private func manageBackGroundData(_ form: Form) {
        if let url = URL(string: AppConfiguration.baseUrl + form.backgroundImage) {
            backgroundImageView.kf.setImage(with: url)
        }
        
        if let url = URL(string: AppConfiguration.baseUrl + form.logo) {
            logoImageView.kf.setImage(with: url)
        }
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
    
    @objc func submitButtonAction() {
    
    }
}

public extension Collection where Element: StringProtocol {
    func sortedNumerically(_ result: ComparisonResult) -> [Element] {
        return sorted { $0.compare($1, options: .numeric) == result }
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
        } else if questionary.last?.questionTypeId == "5" && ((questionary.last?.question ?? Question()).isNps == "0") {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: StarCollectionViewCell.self)
            
            cell.label.text = questionary.count == 1 ? questionary.first?.questingText : questionary.filter({$0.questionTypeId == "0"}).first?.questingText
            cell.questionaries = questionary.filter({$0.questionTypeId == "5" && $0.question.isNps == "0"})
            
            cell.tableView.reloadData()
            
            return cell
        } else if questionary.last?.questionTypeId == "3" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckboxCollectionViewCell.self)
            
            cell.titleLabel.text = questionnairies[indexPath.item].first?.questingText
            cell.questionary = questionary.filter({$0.questionTypeId == "3"}).first ?? Questionnaire()
            cell.collectionView.reloadData()
            
            return cell
        } else if questionary.last?.questionTypeId == "2" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SquareCollectionViewCell.self)
            
            cell.titleLabel.text = questionnairies[indexPath.item].first?.questingText
            cell.questionary = questionary.filter({$0.questionTypeId == "2"}).first ?? Questionnaire()
            cell.collectionView.reloadData()

            return cell
        } else if questionary.last?.questionTypeId == "4" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DropDownCollectionViewCell.self)
            
            cell.questionaries = questionary
            cell.label.text = questionary.first?.questingText
            cell.tableView.reloadData()
            
            return cell
        }
        else if questionary.last?.questionTypeId == "5" && ((questionary.last?.question ?? Question()).isNps == "1") {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCollectionViewCell.self)
            
            cell.questionnaire = questionary.first!
            cell.collectionView.reloadData()
            
            return cell
        } else if questionary.last?.questionTypeId == "1" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TextfieldCollectionViewCell.self)
            
            cell.questionnaries = questionary.filter({$0.questionTypeId == "1"})
            cell.tableView.reloadData()
            
            return cell
        } else if indexPath.item == questionnairies.count - 1 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SubmitCollectionViewCell.self)
            
            cell.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
            
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
