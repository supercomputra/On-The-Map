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
    
//    static func getStudentLocation1(completion: @escaping (_ student: Student?, _ error: RequestError?, _ errorDescription: String?) -> Void) {
//        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
//        let url = URL(string: urlString)
//        let request = NSMutableURLRequest(url: url!)
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error
//                return
//            }
//            
//        }
//        task.resume()
//    }
    
    static func getStudentLocation(uniqueKey: String, completion: @escaping (_ student: Student?, _ error: NSError?) -> Void) {
        let whereValue = ["uniqueKey": uniqueKey] as AnyObject
        let parameters = ["where": whereValue]
        
        Parse.taskForGETMethod(parameters: parameters) { (data: AnyObject?, error: NSError?) in
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
    
    static func getStudentsLocation(completion: @escaping (_ students: [Student]?, _ error: NSError?) -> Void) {
        
        let parameters = ["limit": "200"] as [String: AnyObject]
        
        Parse.taskForGETMethod(parameters: parameters) { (data: AnyObject?, error: NSError?) in
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
