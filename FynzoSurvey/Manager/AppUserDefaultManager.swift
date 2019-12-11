//

import Foundation

class AppUserDefaults {
    
    enum Key: String {
        case email
        case authToken
        case session
        case id
        case fullName
        case image
        case phone
        case homeRefreshTime
        case form
        case isSurveyor
        case surveyorData
        case isAutoUpload
        case settings
        case formData
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
