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
    }
    
    static func models(from jsonArray: [JSON]) -> [Question] {
        var models: [Question] = []
        for json in jsonArray {
            models.append(Question(json: json))
        }
        return models
    }
}
