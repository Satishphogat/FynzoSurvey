//
//  Plan.swift
//  FynzoSurvey
//
//  Created by satish phogat on 30/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Plan {
    var name = ""
    var startDate = ""
    var endDate = ""
    
    init(json: JSON = JSON.null) {
        name          = json["name"].stringValue
        startDate          = json["plan_startTime"].stringValue
        endDate          = json["plan_endTime"].stringValue
    }
    
    static func models(from jsonArray: [JSON]) -> [Plan] {
        var models: [Plan] = []
        for json in jsonArray {
            models.append(Plan(json: json))
        }
        return models
    }
}
