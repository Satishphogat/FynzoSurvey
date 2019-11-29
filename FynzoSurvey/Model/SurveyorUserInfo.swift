//
//  SurveyorUserInfo.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 29/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SurveyorUserInfo {
    
    var device = DeviceSurveyor()
    var forms = [Form]()
    var userId = ""
    
    init(_ json: JSON = JSON.null) {
        device = DeviceSurveyor(json["device"])
        forms = Form.models(from: json["forms"].arrayValue)
        userId = json["account"]["user_id"].stringValue
    }
}

struct DeviceSurveyor {
    
    var id = ""
    var name = ""
    var phone = ""
    
    init(_ json: JSON = JSON.null) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
    }
}
