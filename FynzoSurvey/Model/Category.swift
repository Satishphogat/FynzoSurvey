
//
//  File.swift
//  FynzoSurvey
//
//  Created by satish phogat on 29/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {
    
    var id = ""
    var name = ""
    var parentId = ""
    var icon = ""
    var isDeleted = false
    var surveyFormId = ""
    var categoryId = ""
    var status = ""
    var createTime = ""
    var updateTime = ""
    var startedOn = ""
    var rawResponse = ""

    init(json: JSON = JSON.null) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        parentId = json["parent_id"].stringValue
        icon = json["icon"].stringValue
        isDeleted = json["isDeleted"].boolValue
        surveyFormId = json["survey_form_id"].stringValue
        categoryId = json["category_id"].stringValue
        status = json["status"].stringValue
        createTime = json["createTime"].stringValue
        startedOn = json["started_on"].stringValue
        rawResponse = json["raw_response"].stringValue
    }
    
    static func models(from jsonArray: [JSON]) -> [Category] {
        var models: [Category] = []
        for json in jsonArray {
            models.append(Category(json: json))
        }
        
        return models
    }
}
