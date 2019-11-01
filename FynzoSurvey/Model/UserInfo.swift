//
//  UserInfo.swift
//  FynzoSurvey
//
//  Created by satish phogat on 14/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserInfo {
    
    var id = ""
    var baseUserId = ""
    var firstName = ""
    var lastName = ""
    var image = ""
    var email = ""
    var password = ""
    var countryCode = ""
    var isVerified = ""
    var createTime = ""
    var updateTime = ""
    var signup = ""
    var showPassword = false
    var name = ""
    var confirmPassword = ""
    var showConfirmPassword = false
    var company = ""
    var phone = ""
    var plan = Plan()
    
    
    init(json: JSON = JSON.null) {
        id          = json[Fynzo.ApiKey.id].stringValue
        baseUserId       = json[Fynzo.ApiKey.baseUserId].stringValue
        firstName         = json[Fynzo.ApiKey.firstName].stringValue
        lastName   = json[Fynzo.ApiKey.lastName].stringValue
        name = (firstName + " " + lastName).trim()
        image       = json[Fynzo.ApiKey.image].stringValue
        email         = json[Fynzo.ApiKey.email].stringValue
        password          = json[Fynzo.ApiKey.password].stringValue
        countryCode          = json[Fynzo.ApiKey.country_code].stringValue
        isVerified          = json[Fynzo.ApiKey.isVerified].stringValue
        createTime          = json[Fynzo.ApiKey.createTime].stringValue
        updateTime          = json[Fynzo.ApiKey.updateTime].stringValue
        signup          = json[Fynzo.ApiKey.signup].stringValue
        id          = json[Fynzo.ApiKey.id].stringValue
        plan          = Plan.init(json: json["active_plan"])
    }
    
    static func models(from jsonArray: [JSON]) -> [UserInfo] {
        var models: [UserInfo] = []
        for json in jsonArray {
            models.append(UserInfo(json: json))
        }
        return models
    }
}
