//
//  UdacityClient.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // Shared session
    var session = URLSession.shared
    
    // TODO: Configuration Object
    // var config = UdacityConfig()
    
    // Authentication State
    var requestedToken: String? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    
    override init() {
        super.init()
    }
    
    // Task for GET
    
    @discardableResult func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.Accept)
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.ContentType)
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let securedData = data?.subdata(in: range)
            
            // GUARD: Was there any data returned? */
            guard let data = securedData else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        task.resume()
        
        return task
    }
    
    // Task for POST
    
    @discardableResult func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters!, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.Accept)
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let securedData = data?.subdata(in: range)
            
            // GUARD: Was there any data returned?
            guard let data = securedData else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        // Start the request
        task.resume()
        
        return task
    }

    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
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
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Component.ApiScheme
        components.host = UdacityClient.Component.ApiHost
        components.path = UdacityClient.Component.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

    
}
