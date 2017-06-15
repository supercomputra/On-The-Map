//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

enum PostSessionError: Error {
    case requestFailed
    case badResponse
    case noDataReturned
    case parsingFailed
    case noSessionDataReturned
    case noAccountDataReturned
    case noAccountRegistered
    case other
}

extension UdacityClient {
    
    func postSession(username: String, password: String, completion: @escaping (_ error: PostSessionError?, _ errorDescription: String?, _ dictionary: [String: String]?) -> Void) {
        
        var sessionDictionary = [String: String]()
        
        let sessionURL = URL(string: "https://www.udacity.com/api/session")!
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let request = NSMutableURLRequest(url: sessionURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let decryptedData = data?.subdata(in: range)
            
            
            // Was there any error?
            guard (error == nil) else {
                completion(.requestFailed, nil, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.badResponse, nil, nil)
                return
            }
            
            guard let data = decryptedData else {
                completion(.noDataReturned, nil, nil)
                return
            }
            
            
            // Parse the data
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                print(parsedResult)
            } catch {
                completion(.parsingFailed, nil, nil)
                return
            }
            
            if statusCode != 200 {
                
                guard let errorMessage = parsedResult["error"] as? String else {
                    return
                }
                
                completion(.other, errorMessage, nil)
                
            } else {
                
                
                guard let sessionData = parsedResult["session"] as? [String: AnyObject], let expiration = sessionData["expiration"] as? String, let id = sessionData["id"] as? String else {
                    completion(.noSessionDataReturned, nil, nil)
                    return
                }
                
                guard let accountData = parsedResult["account"] as? [String: AnyObject], let key = accountData["key"] as? String else {
                    completion(.noAccountDataReturned, nil, nil)
                    return
                }
                
                sessionDictionary["expiration"] = expiration
                sessionDictionary["id"] = id
                sessionDictionary["key"] = key
                
                completion(nil, nil, sessionDictionary)
                
            }
            
        }
        
        task.resume()
    }
    
}
