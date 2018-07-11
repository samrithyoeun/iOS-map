//
//  APIRequest.swift
//  Project
//
//  Created by Ricky_DO on 3/19/18.
//  Copyright © 2018 Pathmazing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIRequest {
    
    typealias RestResponse = ((_ response: JSON, _ responseCode: Int?, _ error: Error?) -> ())
    
    static func putRequest(endPoint: String, headers: [String: String] = [:], parameters: Parameters = [:], callback: @escaping RestResponse) {
        sendRequest(endPoint: endPoint, headers: headers, parameters: parameters, method: .put, callback: callback)
    }
    
    static func postRequest(endPoint: String, headers: [String: String] = [:], parameters: Parameters = [:], callback: @escaping RestResponse) {
        sendRequest(endPoint: endPoint, headers: headers, parameters: parameters, method: .post, callback: callback)
    }
    
    static func sendRequest(endPoint: String, headers: [String: String] = [:], parameters: Parameters = [:], method: HTTPMethod, callback: @escaping RestResponse) {
        let url = ServerEnvironment.host + endPoint
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseString(encoding: .utf8) { (response: DataResponse<String>) in
                handle(response: response, responseCode: response.response?.statusCode, callback: callback)
        }
    }
    
    static func uploadRequest(endPoint: String, headers: [String: String] = [:], data: Data, withName name: String, mimeType: String, callback: @escaping (Error?) -> ()) {
        let url = ServerEnvironment.host + endPoint
        let urlRequest = try! URLRequest(url: url, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartData: MultipartFormData) -> Void in
            multipartData.append(data, withName: name, fileName: "\(name).jpg", mimeType: mimeType)
        }, with: urlRequest, encodingCompletion: { (result: Alamofire.SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                callback(error)
            case .success:
                callback(nil)
            }
        })
    }
    
    static func get(endPoint: String, headers: [String: String] = [:], parameters: Parameters = [:], callback: @escaping RestResponse) {

        let url = ServerEnvironment.host + endPoint
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseString(encoding: .utf8) { (response: DataResponse<String>) in
                handle(response: response, responseCode: response.response?.statusCode, callback: callback)
        }
    }
    
    static func deleteRequest(endPoint: String, headers: [String: String] = [:], parameters: Parameters = [:], callback: @escaping RestResponse) {
        let url = ServerEnvironment.host + endPoint
        Alamofire.request(url, method: .delete, parameters: parameters, headers: headers)
            .validate()
            .responseString(encoding: .utf8) { (response: DataResponse<String>) in
                callback(JSON.null, response.response?.statusCode, nil)
        }
    }
    
    private static func handle(response: DataResponse<String>, responseCode: Int?, callback: RestResponse) {
        guard let resultValue = response.value else {
            callback(JSON.null, responseCode, response.error)
            return
        }
        let json = JSON(parseJSON: resultValue)
        
        callback(json, responseCode, response.error)
    }
}
