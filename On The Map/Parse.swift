//
//  Parse.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

class Parse: NSObject {
    
    static var session = URLSession.shared
    
    var requestedToken: String? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    @discardableResult static func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let url = self.parseURLFromParameters(parameters: parameters, pathExtension: method)
        
        let request = NSMutableURLRequest(url: url)
        
        request.addValue(Parse.Constants.ApplicationID, forHTTPHeaderField: Parse.ParameterKeys.ApplicationID)
        request.addValue(Parse.Constants.ApiKey, forHTTPHeaderField: Parse.ParameterKeys.ApiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)

        }
        
        task.resume()
        
        return task
        
    }
    
    // POST
    
    // MARK: PUT/POST
    
    @discardableResult static func taskForWriteMethod(method: String, httpMethod: Write, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        var request = URLRequest(url: self.parseURLFromParameters(parameters: nil, pathExtension: method))
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: ParameterKeys.ApiKey)
        request.addValue(Constants.JSONApplication, forHTTPHeaderField: ParameterKeys.ContentType)
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
 
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }

    
    // Substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private static func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }

    // Create a URL from parameters
    private static func parseURLFromParameters(parameters: [String:AnyObject]?, pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = self.Constants.ApiScheme
        components.host = self.Constants.ApiHost
        components.path = self.Constants.ApiPath + "/" + (pathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        guard let parameters = parameters else {
            return components.url!
        }
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

}
