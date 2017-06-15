//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    enum PostSessionError: Error {
        case requestFailed
        case statusCodeIsNot2XX
        case returnedDataIsNil
        case parsingJSON
    }
    
    // Get request Token
    typealias errorHandler = (_ inner: () throws -> Bool) -> ()
    
    private func postSession(username: String, password: String, completion: @escaping errorHandler) {
        
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
                // Handle error here
                completion() { throw PostSessionError.requestFailed }
                return
            }
            
            // Did we get a successfull 200 response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                // Handle error here
                return
            }
            
            // Was there any data returned?
            guard let data = decryptedData else {
                // Handle error here
                return
            }
            
            
            // Parse the data
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            } catch {
                // Handle Error Here
                return
            }
            
            if statusCode != 200 {
                
                guard let errorMessage = parsedResult["error"] as? String else {
                    // Handle Error Here
                    return
                }
                
                // Handle Error Here
                
            } else {
                
                guard let accountData = parsedResult["account"] as? [String: AnyObject] else {
                    // Handle Error Here
                    return
                }

                guard let isRegistered = accountData["registered"] as? Bool else {
                    // Handle Error Here
                    return
                }
                
                if isRegistered {
                    // Complete The Login here
                } else {
                    // Handle Error Here
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
