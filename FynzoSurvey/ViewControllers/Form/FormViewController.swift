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
import RealmSwift
import Alamofire

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
    @IBOutlet weak var nextArrowButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var previousArrowButton: UIButton!

    var form = Form()
    var questionnairies: [[Questionnaire]] = [[]]
    var isTemplet = false
    
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
        var id = AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? ""
        if id.isEmpty {
            id = "18"
        }
        FynzoWebServices.shared.getQuestionnaire(showHud: true, showHudText: "", controller: self, parameters: [Fynzo.ApiKey.userId: id, Fynzo.ApiKey.surveyform_id: form.id]) { [weak self](json, error) in
            guard let `self` = self else { return }
            
            self.handleSurveyFormsSuccess(json)
        }
    }
    
    private func handleSurveyFormsSuccess(_ json: JSON) {
        let form = Form(json: json[Fynzo.ApiKey.surveyForm])
        //manageBackGroundData(form)

        if let url = URL(string: AppConfiguration.appUrl + form.logo) {
            logoImageView.kf.setImage(with: url)
        }
        if let url = URL(string: AppConfiguration.appUrl + form.backgroundImage) {
            backgroundImageView.kf.setImage(with: url)
        }
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
        view.endEditing(true)
        let collectionBounds = collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - collectionBounds.size.width))
        moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func nextButtonAction() {
        view.endEditing(true)
        moveForword()
    }
    
    private func moveForword() {
        let collectionBounds = collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        DispatchQueue.main.async {
            let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
            self.collectionView.scrollRectToVisible(frame, animated: false)
        }
    }
    
    @objc func submitButtonAction() {
        view.endEditing(true)
        
        formSubmitApi()
    }
    
    private func formSubmitApi() {
        //star cell
        var parameter = ["surveyform_id": form.id,"start_time": form.createTime,"device_id":UIDevice.current.identifierForVendor?.uuidString ?? ""] as [String : Any]

        var dict = [String: Any]()
        if questionnairies.contains(where: { $0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "0")}) {
            let obj = questionnairies.filter({ $0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "0")} )
            let keys = obj.first?.map({$0.id}) ?? []
            let values = obj.first?.map({$0.selectedStars}) ?? []
            for index in 0..<keys.count {
                dict["\(keys[index])"] = "\(values[index])"
            }
        }
        // circle checkbox
        if questionnairies.contains(where: {$0.last?.questionTypeId == "3"}) {
            let obj = questionnairies.filter({$0.last?.questionTypeId == "3"} )
            
            let keys = obj.first?.map({$0.id}) ?? []
            let values = (obj.first?.map({$0.questions.filter({$0.isSelected})}).first ?? [Question]()).map({$0.id})
            for index in 0..<keys.count {
                dict["\(keys[index])"] = values.isEmpty ? "" : values[index]//
            }
        }
        // square checkbox
        if questionnairies.contains(where: {$0.last?.questionTypeId == "2"}) {
            let obj = questionnairies.filter({ $0.last?.questionTypeId == "2"} )
            
            let keys = obj.first?.map({$0.id}) ?? []
            let values = (((obj.first?.map({$0.questions.filter({$0.isSelected})}) ?? [])?.first) ?? []).map({$0.id})  // array of id of selected questions
            for index in 0..<keys.count {
                dict["\(keys[index])"] = values//
            }
        }
        
        // dropdown checkbox
        if questionnairies.contains(where: {$0.last?.questionTypeId == "4"}) {
            let obj = questionnairies.filter({ $0.last?.questionTypeId == "4"} )
            
            let keys = obj.first?.map({$0.id}) ?? []
            let values = obj.first?.map({$0.questions.filter({$0.isSelected})}) ?? []
            for index in 0..<keys.count {
                dict["\(keys[index])"] = "\(values[index])"
            }
        }
        // card checkbox

        if questionnairies.contains(where: { $0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "1")}) {
            let obj = questionnairies.filter({ $0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "1")} )
            
            let keys = obj.first?.map({$0.id}) ?? []
            let values = obj.first?.map({$0.question.selectedScale}) ?? []
            for index in 0..<keys.count {
                dict["\(keys[index])"] = "\(values[index] ?? 0)"
            }
            
        }
        
        // textfield checkbox
        if questionnairies.contains(where: {$0.last?.questionTypeId == "1"}) {
            let obj = questionnairies.filter({ $0.last?.questionTypeId == "1"} )
            
            let keys = obj.first?.map({$0.id}) ?? []
            let values = obj.first?.map({$0.answer.capitalized}) ?? []
            for index in 0..<keys.count {
                dict["\(keys[index])"] = "\(values[index])"
            }
        }
        
        parameter["answer"] = dict
        
        
        if !Connectivity.isConnectedToInternet {
            if var arrayOfSavedForms = AppUserDefaults.value(forKey: AppUserDefaults.Key.form, fallBackValue: false) as? [[String: Any]] {
                arrayOfSavedForms.append(parameter)
                AppUserDefaults.save(value: arrayOfSavedForms, forKey: AppUserDefaults.Key.form)
            } else {
                AppUserDefaults.save(value: [parameter], forKey: AppUserDefaults.Key.form)
            }
            moveToThankPage(.offline)
        } else {
            submitFormApi(parameter)
        }
    }
    
    private func moveToThankPage(_ thankType: ThankType) {
        let controller = ThankYouViewController.instantiate(fromAppStoryboard: .Home)
        controller.thankType = thankType
        controller.logoImageUrl = form.logo
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func submitFormApi(_ parameter: [String: Any]) {
        FynzoWebServices.shared.submitForm(controller: self, parameters: parameter) { [weak self] (json, error) in
            guard let `self` = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if (AppUserDefaults.value(forKey: .id, fallBackValue: false) as? String ?? "").isEmpty {
                    self.moveToThankPage(.demo)
                } else {
                    self.moveToThankPage(.loggedIn)
                }
            })
        }
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
        
//        previousButton.isHidden = indexPath.item == 0
//        previousArrowButton.isHidden = indexPath.item == 0
//        nextButton.isHidden = indexPath.item == questionnairies.count - 1
//        nextArrowButton.isHidden = indexPath.item == questionnairies.count - 1

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
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "0")})
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: StarCollectionViewCell.self)
            
            cell.label.text = questionary.count == 1 ? questionary.first?.questingText : questionary.filter({$0.questionTypeId == "0"}).first?.questingText
            cell.questionaries = questionary.filter({$0.questionTypeId == "5" && $0.question.isNps == "0"})
            cell.completion = { questionaries in
                if let index = index {
                    self.questionnairies[index] = questionaries
                    self.moveForword()
                }
            }
            //cell.tableView.reloadData()
            
            return cell
        } else if questionary.last?.questionTypeId == "3" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CheckboxCollectionViewCell.self)
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "3"})
            cell.titleLabel.text = questionnairies[indexPath.item].first?.questingText
            cell.questionary = questionary.filter({$0.questionTypeId == "3"}).first ?? Questionnaire()
            cell.collectionView.reloadData()
            cell.completion = { questionaries in
                if let index = index {
                    self.questionnairies[index] = [questionaries]
                    self.moveForword()
                }
            }
            
            return cell
        } else if questionary.last?.questionTypeId == "2" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SquareCollectionViewCell.self)
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "2"})

            cell.titleLabel.text = questionnairies[indexPath.item].first?.questingText
            cell.questionary = questionary.filter({$0.questionTypeId == "2"}).first ?? Questionnaire()
            //cell.collectionView.reloadData()
            cell.completion = { questionaries in
                if let index = index {
                    self.questionnairies[index] = [questionaries]
                }
            }

            return cell
        } else if questionary.last?.questionTypeId == "4" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DropDownCollectionViewCell.self)
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "4"})

            cell.questionaries = questionary
            cell.label.text = questionary.first?.questingText
            //cell.tableView.reloadData()
            cell.completion = { questionaries in
                if let index = index {
                    self.questionnairies[index] = questionaries
                    self.moveForword()
                }
            }
            
            return cell
        }
        else if questionary.last?.questionTypeId == "5" && ((questionary.last?.question ?? Question()).isNps == "1") {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCollectionViewCell.self)
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "5" && (($0.last?.question ?? Question()).isNps == "1")})

            cell.questionnaire = questionary.first!
            //cell.collectionView.reloadData()
            cell.completion = { questionaries in
                if let index = index {
                self.questionnairies[index] = [questionaries]
                    self.moveForword()
                }
            }
            
            return cell
        } else if questionary.last?.questionTypeId == "1" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TextfieldCollectionViewCell.self)
            let index = questionnairies.firstIndex(where: {$0.last?.questionTypeId == "1"})

            cell.questionnaries = questionary.filter({$0.questionTypeId == "1"})
            cell.completion = { questionaries in
                if let index = index {
                    self.questionnairies[index] = questionaries
                    self.moveForword()
                }
            }
            //cell.tableView.reloadData()
            
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

extension FormViewController {
    // set collection view cell in center
    func centerCell () {
        let centerPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.frame.midX, y: 100)
        if let path = collectionView.indexPathForItem(at: centerPoint) {
            collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
    //Set collectionView.delegate = self then add below funcs
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCell()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        centerCell()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCell()
        }
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

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

