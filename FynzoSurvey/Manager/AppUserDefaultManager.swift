//
//  AppUserDefaultManager.swift
//  Lussot
//
//  Created by Pushpraj Chaudhary on 05/09/18.
//  Copyright © 2018 Crownstack. All rights reserved.
//

import Foundation

class AppUserDefaults {
    
    enum Key: String {
        case email
        case authToken
        case session
        case userId
        case fullName
        case image
        case phone
    }
}

extension AppUserDefaults {
    
    static func value<T>(forKey key: Key, fallBackValue: T, file: String = #file, line: Int = #line, function: String = #function) -> Any {
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return fallBackValue
        }
        
        return value
    }
    
    static func save(value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}
