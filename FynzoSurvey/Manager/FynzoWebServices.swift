//
//  FlaerWebServices.swift
//  Flaer
//
//  Created by Pushpraj Chaudhary on 17/07/18.
//  Copyright © 2018 Crownstack. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias CompletionBlock = (JSON, NSError?) -> Void

class FynzoWebServices: UIViewController {
    
    static let shared = FynzoWebServices()
    var controller = UIViewController()
    
    enum EndPoint: String {
        case authToken          = "basic-auth"
        case signUp          = "auth/register"
        case login          = "login"
        case changePassword          = "auth/resetPassword"
        case forgotPassword          = "auth/resetPasswordRequest"
        case surveyForms     = "webservices/surveyforms"
        case surveyForm     = "webservices/surveyform"
        case getCategory = "webservices/categories"
        case importSurvey = "webservices/surveyform_copy"
        case categoryTemplates = "webservices/category_templates"

        var latestUrl: String {
            return "\(AppConfiguration.baseUrl)\(self.rawValue)"
        }
    }
}

extension NSError {
    
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension FynzoWebServices {
    
    func signUp(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        postRequest(showHud: showHud, showHudText: showHudText, shouldErrorRequired: shouldErrorRequired, endPoint: EndPoint.signUp.latestUrl, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func login(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, parameters: JSONDictionary, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: showHud, showHudText: showHudText, shouldErrorRequired: shouldErrorRequired, endPoint: EndPoint.login.latestUrl, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func surveyForms(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, parameters: JSONDictionary, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: showHud, showHudText: showHudText, shouldErrorRequired: shouldErrorRequired, endPoint: AppConfiguration.appUrl + EndPoint.surveyForms.rawValue, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func getQuestionnaire(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, parameters: JSONDictionary, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: showHud, showHudText: showHudText, shouldErrorRequired: shouldErrorRequired, endPoint: AppConfiguration.appUrl + EndPoint.surveyForm.rawValue, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func getCategories(controller: UIViewController, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: true, showHudText: "", shouldErrorRequired: false, endPoint: AppConfiguration.appUrl + EndPoint.getCategory.rawValue, controller: controller, parameters: [:], headers: [:], completion: completion)
    }
    
    func importSurvey(parameters: JSONDictionary ,controller: UIViewController, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: true, showHudText: "", shouldErrorRequired: false, endPoint: AppConfiguration.appUrl + EndPoint.importSurvey.rawValue, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func getCategoryTemplate(controller: UIViewController, isSocialLogin: Bool = false, completion: @escaping CompletionBlock) {
        
        postRequest(showHud: true, showHudText: "", shouldErrorRequired: false, endPoint: AppConfiguration.appUrl + EndPoint.categoryTemplates.rawValue, controller: controller, parameters: [:], headers: [:], completion: completion)
    }
    
    func forgotPassword(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        postRequest(showHud: showHud, showHudText: showHudText, shouldErrorRequired: shouldErrorRequired, endPoint: EndPoint.forgotPassword.latestUrl, controller: controller, parameters: parameters, headers: [:], completion: completion)
    }
    
    func postRequest(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, endPoint: String, controller: UIViewController, parameters: JSONDictionary, imageData: Data = Data(), imageKey: String = "", headers: JSONDictionary, completion: @escaping CompletionBlock) {
        showIndicator(controller, showHud)
        FynzoAPIManager.POST(showHud: showHud, showHudText: showHudText, endPoint: endPoint, parameters: parameters, imageData: imageData, imageKey: imageKey, headers: headers, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            self.removeIndicator()
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func putRequest(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, endPoint: String, controller: UIViewController, parameters: JSONDictionary, imageData: Data = Data(), imageKey: String = "", headers: JSONDictionary, completion: @escaping CompletionBlock) {
        showIndicator(controller, showHud)
        FynzoAPIManager.PUT(showHud: showHud, showHudText: showHudText, endPoint: endPoint, parameters: parameters, imageData: imageData, imageKey: imageKey, headers: headers, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            self.removeIndicator()
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func getRequest(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, pageNumber: Int = 1, controller: UIViewController, endPoint: String, parameters: JSONDictionary, headers: JSONDictionary, completion: @escaping CompletionBlock) {
        showIndicator(controller, showHud)
        FynzoAPIManager.GET(showHud: showHud, showHudText: showHudText, endPoint: endPoint, parameters: parameters, headers: headers, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            self.removeIndicator()
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func deleteRequest(showHud: Bool, showHudText: String, shouldErrorRequired: Bool = false, controller: UIViewController, endPoint: String, parameters: JSONDictionary, headers: JSONDictionary, completion: @escaping CompletionBlock) {
        showIndicator(controller, showHud)
        FynzoAPIManager.DELETE(showHud: showHud, showHudText: showHudText, endPoint: endPoint, parameters: parameters, headers: headers, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            self.removeIndicator()
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func handlecompletionResponse(_ json: JSON, shouldErrorRequired: Bool = false, completion: @escaping CompletionBlock ) {
        removeIndicator()
        completion(json, nil)
    }
    
    func showIndicator(_ controller: UIViewController, _ showHud: Bool, _ pageNumber: Int = 1) {
        self.controller = controller
            GIFLoading.shared.showWithActivityIndicator("Loading", activitycolor: .white, labelfontcolor: .white, labelfontsize: 15, activityStyle: .whiteLarge)
    }
    
    func removeIndicator() {
        GIFLoading.shared.hide()
    }
    
    func handleFailureBlock(error: NSError) {
        removeIndicator()
        if error.code == -1009 {
            controller.noInternetConnection()
        } else if error.code == 401 {
            UserManager.shared.moveToLogin()
        } else {
            customizedAlert(message: error.localizedDescription, afterDelay: 0.5)
        }
    }
}
