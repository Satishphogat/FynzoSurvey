//

import Foundation
import SwiftyJSON
import Alamofire

public typealias JSONArray = [[String: Any]]
public typealias JSONDictionary = [String: Any]
public typealias Action = () -> Void

typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessBlock = (JSON) -> Void
typealias ErrorBlock = (NSError) -> Void

extension Notification.Name {
    
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum FynzoAPIManager {
    
    static func POST(showHud: Bool,
                     showHudText: String,
                     endPoint: String,
                     parameters: JSONDictionary = [:],
                     imageData: Data = Data(),
                     imageKey: String = "",
                     headers: JSONDictionary = [:],
                     success : @escaping SuccessBlock,
                     failure : @escaping ErrorBlock) {
        
        request(showHud: showHud, showHudText: showHudText, URLString: endPoint, httpMethod: .post, parameters: parameters, imageData: imageData,
                imageKey: imageKey, headers: headers, success: success, failure: failure)
    }
    
    static func GET(showHud: Bool,
                    showHudText: String,
                    endPoint: String,
                    parameters: JSONDictionary = [:],
                    headers: JSONDictionary = [:],
                    success : @escaping SuccessBlock,
                    failure : @escaping ErrorBlock) {
        
        request(showHud: showHud, showHudText: showHudText, URLString: endPoint, httpMethod: .get, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    static func PUT(showHud: Bool,
                    showHudText: String,
                    endPoint: String,
                    parameters: JSONDictionary = [:],
                    imageData: Data = Data(),
                    imageKey: String = "",
                    headers: JSONDictionary = [:],
                    success : @escaping SuccessBlock,
                    failure : @escaping ErrorBlock) {
        
        request(showHud: showHud, showHudText: showHudText, URLString: endPoint, httpMethod: .put, parameters: parameters, imageData: imageData,
                imageKey: imageKey, headers: headers, success: success, failure: failure)
    }
    
    static func DELETE(showHud: Bool,
                       showHudText: String,
                       endPoint: String,
                       parameters: JSONDictionary = [:],
                       headers: JSONDictionary = [:],
                       success : @escaping SuccessBlock,
                       failure : @escaping ErrorBlock) {
        
        request(showHud: showHud, showHudText: showHudText, URLString: endPoint, httpMethod: .delete, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    private static func request(showHud: Bool,
                                showHudText: String,
                                URLString: String,
                                httpMethod: HTTPMethod,
                                parameters: JSONDictionary = [:],
                                imageData: Data = Data(),
                                imageKey: String = "",
                                headers: JSONDictionary = [:],
                                success : @escaping SuccessBlock,
                                failure : @escaping ErrorBlock) {
        var additionalHeaders: HTTPHeaders?
        additionalHeaders = headers as? HTTPHeaders
        
        if imageKey != "" {
            guard let URL = try? URLRequest(url: URLString, method: httpMethod, headers: additionalHeaders) else {return}
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                multipartFormData.append(imageData, withName: imageKey, fileName: "file.png", mimeType: "image/png")
            }, with: URL, encodingCompletion: { (encodingResult) in
                parseEncodingResult(encodingResult, success: success, failure: failure)
            })
        } else {
            Alamofire.request(URLString, method: httpMethod,
                              parameters: parameters,
                              encoding: (httpMethod == .post) || (httpMethod == .put) ? JSONEncoding.default : URLEncoding.queryString,
                              headers: additionalHeaders).authenticate(user: "admin", password: "1234").responseJSON { (response: DataResponse<Any>) in
                                parseResponse(response, success: success, failure: failure)
            }
        }
        
    }
    
    private static func parseEncodingResult(_ result: SessionManager.MultipartFormDataEncodingResult,
                                            loader: Bool = true,
                                            success : @escaping SuccessBlock,
                                            failure : @escaping ErrorBlock) {
        switch result {
        case .success(let upload, _, _):
            upload.responseJSON { (response: DataResponse<Any>) in
                parseResponse(response, success: success, failure: failure)
            }
        case .failure(let error):
            failure(error as NSError)
        }
    }
    
    private static func parseResponse(_ response: DataResponse<Any>,
                                      success : @escaping SuccessBlock,
                                      failure : @escaping ErrorBlock) {
        switch response.result {
        // TODO: need refactor
        case .success(let value):
            let error = JSON(value)["error"].dictionaryValue
            if error.keys.contains("message") {
                let message = JSON(value)["error"]["message"].stringValue
                let err = NSError(code: 403, localizedDescription: message)
                failure(err)
            } else {
                if let value1 = value as? NSDictionary {
                    if let result = value1["data"] as? [Any], !result.isEmpty {
                        success(JSON(result))
                    } else {
                        var temp = value1["data"] as? [String: Any] ?? [:]
                        temp["msg"] = value1["msg"] as? String ?? ""
                        temp["status"] = value1["status"] as? Bool ?? false
                        success(JSON(temp))
                    }
                }
            }
        case .failure(let error):
            
            if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                print("Server Error: " + str)
            }
            
            let err = (error as NSError)
            if err.code == NSURLErrorNotConnectedToInternet || err.code == NSURLErrorInternationalRoamingOff {
                // Handle Internet Not available UI
                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                let internetNotAvailableError = NSError(code: NSURLErrorNotConnectedToInternet, localizedDescription: "")
                failure(internetNotAvailableError)
            } else {
                failure(error as NSError)
            }
        }
    }
}
