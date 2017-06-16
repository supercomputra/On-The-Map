//
//  DataSource.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/16/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import MapKit

class DataSource: NSObject {
    static var students = [Student]()
    
    static func getStudents(_ completion: @escaping (_ students: [Student]) -> Void) {
        ParseClient.getStudentLocation { (students: [Student]?, error: RequestError?, errorDescription: String?) in
            guard students != nil else {
                return
            }
            
            DataSource.students = students!
            
            completion(students!)
        }
    }
    
    static func getStudents() {
        ParseClient.getStudentLocation { (students: [Student]?, error: RequestError?, errorDescription: String?) in
            guard students != nil else {
                return
            }
            
            DataSource.students = students!
        }
    }
}
