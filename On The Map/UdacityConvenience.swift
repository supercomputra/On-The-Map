//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

enum RequestError: Error {
    case failedRequest
    case badResponse
    case noDataReturned
    case parsingFailed
    case noSessionDataReturned
    case noAccountDataReturned
    case noAccountRegistered
    case other
}

extension Udacity {
    
    // TODO: Refactor postSession using TaskForPostMethod
    
    static func postSession(username: String, password: String, completion: @escaping (_ error: RequestError?, _ errorDescription: String?) -> Void) {
        
        let postSessionURL = URL(string: "https://www.udacity.com/api/session")!
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        var request = URLRequest(url: postSessionURL)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: Udacity.Header.Accept)
        request.addValue("application/json", forHTTPHeaderField: Udacity.Header.ContentType)
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let decryptedData = data?.subdata(in: range)
            
            guard (error == nil) else {
                print(error.debugDescription)
                completion(.failedRequest, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.badResponse, nil)
                return
            }
            
            guard let data = decryptedData else {
                completion(.noDataReturned, nil)
                return
            }
            
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            } catch {
                completion(.parsingFailed, nil)
                return
            }
            
            let isStatusCode2XX = (statusCode<300) && (199<statusCode)
            
            if isStatusCode2XX {
                
                guard let sessionData = parsedResult["session"] as? [String: AnyObject], let expiration = sessionData["expiration"] as? String, let id = sessionData["id"] as? String else {
                    completion(.noSessionDataReturned, nil)
                    return
                }
                
                guard let accountData = parsedResult["account"] as? [String: AnyObject], let key = accountData["key"] as? String else {
                    completion(.noAccountDataReturned, nil)
                    return
                }
                
                
                let session = SessionManager.Session(id: id, key: key, expiration: expiration)
                
                SessionManager.session = session
                let uniqueKey = session.key
                UserDefaults.standard.set(uniqueKey, forKey: "uniqueKey")
                
                completion(nil, nil)
                
                
            } else {
                
                guard let errorDescription = parsedResult["error"] as? String else {
                    return
                }
                
                completion(.other, errorDescription)
                
            }
            
        }
        
        task.resume()
    }
    
    
    // TODO: Refactor deleteSession using TaskForPostMethod

    static func deleteSession(completion: @escaping () -> Void) {
        
        let sessionURL = URL(string: "https://www.udacity.com/api/session")!
        let request = NSMutableURLRequest(url: sessionURL)
        request.httpMethod = "DELETE"

        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print(error!)
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let _ = data?.subdata(in: range)
            
            
            completion()
            
            
        }
        task.resume()
        
        
        
    }
    
}
