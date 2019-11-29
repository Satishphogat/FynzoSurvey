//
//  FacebookManager.swift
//  BuildBorad
//
//  Created by Pushpraj Chaudhary on 21/04/18.
//  Copyright © 2018 Crownstack. All rights reserved.

import Foundation
import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare

class FacebookManger {
    
    static var shared = FacebookManger()
    var currentUser: Any?
    
    func userLogin(_ controller: UIViewController, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        if AccessToken.current != nil {
            getLoggedInUserdata(controller, success: success, failure: failure)
        } else {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile, .email, .userEvents], viewController: controller, completion: { [weak self] (loginResult) in
                guard let `self` = self else { return }
                switch loginResult {
                case .failed(let error):
                    failure(error)
                case .cancelled:
                    return
                case .success(_, _, let accessToken):
                    AccessToken.current = accessToken
                    self.getLoggedInUserdata(controller, success: success, failure: failure)
                }
            })
        }
    }
    
    func getLoggedInUserdata(_ controller: UIViewController, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        let data = ["fields": "id,email,name,first_name,last_name,gender,picture.type(large)"]
        let request = GraphRequest(graphPath: "me", parameters: data)
        request.start { [weak self] (_, result) in
            guard let `self` = self else { return }
            switch result {
            case .failed(let error):
                failure(error)
            case .success(let response):
                if let responseDict = response.dictionaryValue {
                    self.currentUser = responseDict
                    success(responseDict)
                }
            }
        }
    }
}
