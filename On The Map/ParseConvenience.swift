//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/16/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // refactor getStudentLocation
    
    static func getStudentLocation(completion: @escaping (_ students: [Student]?, _ error: RequestError?, _ errorDescription: String?) -> Void) {
        
        let getStudentLocationURL = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        
        var request = URLRequest(url: getStudentLocationURL)
        
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: ParseClient.ParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.ParameterKeys.ApiKey)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                completion(nil, .failedRequest, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, .noDataReturned, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(nil, .badResponse, nil)
                return
            }

            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            } catch {
                completion(nil, .parsingFailed, nil)
                return
            }
            
            let isStatusCode2XX = (statusCode<300) && (199<statusCode)
            
            if isStatusCode2XX {
                
                guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
                    return
                }
                
                var students: [Student] = []
                
                for result in results {
                    
                    let location = Location(dictionary: result)
                    
                    if location.coordinate != nil {
                        
                        let student = Student(dictionary: result, location: location)
                        
                        let firsNameHasEmptyString = student.firstName == nil || student.firstName == ""
                        
                        let lastNameHasEmptyString = student.lastName == nil || student.lastName == ""

                        if !firsNameHasEmptyString || !lastNameHasEmptyString {
                            
                            students.append(student)
                            
                        } else {
                            
                            // Handle no name student error here
                        }
                        
                    } else {
                        
                        // Handle no location student error here
                        
                    }
                }
                
                completion(students, nil, nil)
                
            } else {
                
                guard let errorMessage = parsedResult["error"] as? String else {
                    return
                }
                
                completion(nil, .other, errorMessage)
            }
            
        }
        task.resume()
    }
}
