//
//  Question.swift
//  FynzoSurvey
//
//  Created by satish phogat on 16/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import SwiftyJSON

struct Question {
    var id = ""
    var questionnaireQuestionId = ""
    var choice = ""
    var updateTime = ""
    var createTime = ""
    var status = ""
    var labels = ""
    var scale = ""
    var isNps = ""
    var isSelected = false
    var selectedScale = -1
    var detailResponseAnswer = ""
    var detailResponseAnswerArray = [String]()
    var questionText = ""
    var screenNo = 0
    var questingNo = 0
    var questionTypeId = ""
    var questions = [Question]()
    
    init(json: JSON = JSON.null) {
        id          = json[Fynzo.ApiKey.id].stringValue
        questionnaireQuestionId       = json[Fynzo.ApiKey.questionnaireQuestionId].stringValue
        choice         = json[Fynzo.ApiKey.choice].stringValue
        status          = json[Fynzo.ApiKey.status].stringValue
        createTime = json[Fynzo.ApiKey.createTime].stringValue
        updateTime          = json[Fynzo.ApiKey.updateTime].stringValue
        labels = json[Fynzo.ApiKey.updateTime].stringValue
        scale = json[Fynzo.ApiKey.scale].stringValue
        isNps = json[Fynzo.ApiKey.isNps].stringValue
        questionText = json["question_text"].stringValue
        screenNo = Int(json[Fynzo.ApiKey.screenNo].stringValue) ?? 0
        questingNo   = Int(json[Fynzo.ApiKey.questionNo].stringValue) ?? 0
        questionTypeId          = json[Fynzo.ApiKey.questionTypeId].stringValue
        questions          = Question.models(from: json["question"].arrayValue)
    }
    
    static func models(from jsonArray: [JSON]) -> [Question] {
        var models: [Question] = []
        for json in jsonArray {
            models.append(Question(json: json))
        }
        return models
    }
}
