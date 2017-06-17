//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/16/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

extension Parse {
    
    // refactor getStudentLocation
    
    static func getStudentLocation(uniqueKey: String, completion: @escaping(_ student: Student?,_ error: NSError?) -> Void) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        print(url!)
        request.addValue(Parse.Constants.ApplicationID, forHTTPHeaderField: Parse.ParameterKeys.ApplicationID)
        request.addValue(Parse.Constants.ApiKey, forHTTPHeaderField: Parse.ParameterKeys.ApiKey)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            
            
            var result: AnyObject! = nil
            do {
                result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                sendError("Could not parse the data as JSON: '\(data!)'")
            }

            
            guard let results = result!["results"] as? [String : AnyObject] else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            print(results)
        }
        task.resume()
    }
    
    /*
    
    // This is a convenience method for get a student location
    
    static func getStudentLocation(uniqueKey: String, completion: @escaping (_ student: Student?, _ error: NSError?) -> Void) {
        
        let dictionary = ["where": ["uniqueKey":"\(uniqueKey)"]] as [String: AnyObject]
        
        Parse.taskForGETMethod(parameters: nil, queryDictionary: dictionary) { (data: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let result = data!["results"] as? [String : AnyObject] else {
                sendError("No data was returned by the request!")
                return
            }
            
            var returnedStudent: Student!
            
            let location = Location(dictionary: result)
            let student = Student(dictionary: result, location: location)
            
            returnedStudent = student
            completion(returnedStudent, nil)
            
        }
        
    }
    */
    
    static func getStudentsLocation(completion: @escaping (_ students: [Student]?, _ error: NSError?) -> Void) {
        
        let parameters = ["limit": "200"] as [String: AnyObject]
        
        Parse.taskForGETMethod(parameters: parameters, queryDictionary: nil) { (data: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let results = data!["results"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
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
            
            DataSource.students = students
            
            completion(students, nil)

        }
    }
}
