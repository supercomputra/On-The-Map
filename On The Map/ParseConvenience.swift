//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/16/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

extension Parse {
    
    // This is a convenience method for get a student location
    
    static func getStudentLocation(uniqueKey: String, completion: @escaping (_ student: Student?, _ error: NSError?) -> Void) {
        
        let parameters = [ParameterKeys.Where: "{\"\(ParameterKeys.UniqueKey)\":\"" + "\(uniqueKey)" + "\"}" as AnyObject]
        
        Parse.taskForGETMethod(method: Method.StudentLocation, parameters: parameters) { (data: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let result = data!["results"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
                return
            }
            
            let studentDictionary = result[0]
            let location = Location(dictionary: studentDictionary)
            let student = Student(dictionary: studentDictionary, location: location)
            
            completion(student, nil)
            
        }
        
    }
    
    
    static func getStudentsLocation(completion: @escaping (_ students: [Student]?, _ error: NSError?) -> Void) {
        
        let parameters = ["limit": "200"] as [String: AnyObject]
        
        Parse.taskForGETMethod(method: Method.StudentLocation, parameters: parameters) { (data: AnyObject?, error: NSError?) in
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
    
    // This is a convenience method for get a student location
    
    static func putStudentLocation(student: Student, completion: @escaping (_ error: NSError?) -> Void) {
            let method = Method.StudentLocation + "/" + student.objectId!
        
        let jsonBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName ?? "")\", \"lastName\": \"\(student.lastName ?? "")\",\"mapString\": \"\(String(describing: student.location!.mapString!))\", \"mediaURL\": \"\(String(describing: student.mediaURL!))\",\"latitude\": \(String(describing: student.location!.latitude!)), \"longitude\": \(student.location!.longitude!)}"
        
        Parse.taskForWriteMethod(method: method, httpMethod: .PUT, jsonBody: jsonBody) { (result: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard result!["updatedAt"] != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
            completion(nil)
        }
        
    }
}
