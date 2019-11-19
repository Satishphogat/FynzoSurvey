//
//  UserInfo.swift
//  FynzoSurvey
//
//  Created by satish phogat on 14/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Form: Object {
    var id = ""
    var uniqueKey = ""
    var ownerId = ""
    var name = ""
    var descriptionn = ""
    var logo = ""
    var backgroundImage = ""
    var saveLocation = ""
    var onlySingleResponse = ""
    var isLandscape = ""
    var status = ""
    var isTemplate = ""
    var copiedFrom = ""
    var createTime = ""
    var updateTime = ""
    
    init(json: JSON = JSON.null) {
        id          = json[Fynzo.ApiKey.id].stringValue
        uniqueKey       = json[Fynzo.ApiKey.uniqueKey].stringValue
        ownerId         = json[Fynzo.ApiKey.firstName].stringValue
        name   = json[Fynzo.ApiKey.name].stringValue
        descriptionn       = json[Fynzo.ApiKey.description].stringValue
        logo         = json[Fynzo.ApiKey.logo].stringValue
        backgroundImage          = json[Fynzo.ApiKey.backgroundImage].stringValue
        saveLocation          = json[Fynzo.ApiKey.saveLocation].stringValue
        onlySingleResponse          = json[Fynzo.ApiKey.onlySingleResponse].stringValue
        isLandscape          = json[Fynzo.ApiKey.isLandscape].stringValue
        createTime = json[Fynzo.ApiKey.createTime].stringValue
        updateTime          = json[Fynzo.ApiKey.updateTime].stringValue
        status          = json[Fynzo.ApiKey.status].stringValue
        copiedFrom          = json[Fynzo.ApiKey.copiedFrom].stringValue
    }
    
    override required init() {
        super.init()
    }
    
    static func models(from jsonArray: [JSON]) -> [Form] {
        var models: [Form] = []
        for json in jsonArray {
            models.append(Form(json: json))
        }
        return models
    }
}
