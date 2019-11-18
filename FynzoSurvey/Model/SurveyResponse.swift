//
//  SurveyResponse.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 05/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SurveyResponse {
    
    var allResponses = [Category]()
    
    init(json: JSON = JSON.null) {
        allResponses = Category.models(from: json["all_responses"].arrayValue)
    }
}

struct GraphReportResponse {
    
    var surverResponse = SurveyResponse()
    var surveyForms = [Form]()
    var questions = [String: Any]()
    
    init(json: JSON = JSON.null) {
        surverResponse = SurveyResponse(json: json["surveyrespones"])
        surveyForms = Form.models(from: json["surveyforms"].arrayValue)
        questions = json["qquestions"].dictionaryValue
    }
}

struct GraphDetailView {
    
    var questionText = ""
    var questions = [Question]()
}
