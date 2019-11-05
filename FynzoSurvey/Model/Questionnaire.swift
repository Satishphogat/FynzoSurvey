//
//  UserInfo.swift
//  FynzoSurvey
//
//  Created by satish phogat on 14/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Questionnaire {
    var id = ""
    var surveyFormId = ""
    var screenNo = ""
    var questingNo = ""
    var questingText = ""
    var isCompulsory = ""
    var questionTypeId = ""
    var groupingParentQqid = ""
    var clubbingParentQqid = ""
    var status = ""
    var createTime = ""
    var updateTime = ""
    var questions = [Question]()
    var dequesting = ""
    var questionText = ""
    var question = Question()
    var selectedStars = 0
    
    init(json: JSON = JSON.null) {
        id          = json[Fynzo.ApiKey.id].stringValue
        surveyFormId       = json[Fynzo.ApiKey.surveyFormId].stringValue
        screenNo = json[Fynzo.ApiKey.screenNo].stringValue
        questingNo   = json[Fynzo.ApiKey.questionNo].stringValue
        questingText       = json[Fynzo.ApiKey.questionText].stringValue
        isCompulsory         = json[Fynzo.ApiKey.isCompulsory].stringValue
        questionTypeId          = json[Fynzo.ApiKey.questionTypeId].stringValue
        groupingParentQqid          = json[Fynzo.ApiKey.groupingParentQqid].stringValue
        clubbingParentQqid          = json[Fynzo.ApiKey.clubbingParentQqid].stringValue
        status          = json[Fynzo.ApiKey.status].stringValue
        createTime = json[Fynzo.ApiKey.createTime].stringValue
        updateTime          = json[Fynzo.ApiKey.updateTime].stringValue
        questions          = Question.models(from: json[Fynzo.ApiKey.question].arrayValue)
        dequesting          = json[Fynzo.ApiKey.dquestion].stringValue
        questingText          = json[Fynzo.ApiKey.questionText].stringValue
        question          = Question(json: json[Fynzo.ApiKey.question])

    }
    
    static func models(from jsonArray: [JSON]) -> [Questionnaire] {
        var models: [Questionnaire] = []
        for json in jsonArray {
            models.append(Questionnaire(json: json))
        }
        return models
    }
}
