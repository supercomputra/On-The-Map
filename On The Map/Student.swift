//
//  Student.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/14/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

struct Student {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: URL?
    var location: Location?
    
    
    init(objectId: String, uniqueKey: String?, firstName: String?, lastName: String?, mediaURL: String?, location: Location?) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        if let url = URL(string: mediaURL ?? "") {
            self.mediaURL = url
        } else {
            self.mediaURL = nil
        }
        
        self.location = location
    }
    
    init(dictionary: [String: AnyObject], location: Location) {
        self.objectId = getValue(from: dictionary, for: "objectId") as! String?
        self.firstName = getValue(from: dictionary, for: "firstName") as! String?
        self.lastName = getValue(from: dictionary, for: "lastName") as! String?
        self.uniqueKey = getValue(from: dictionary, for: "uniqueKey") as! String?
        if let url = URL(string: getValue(from: dictionary, for: "mediaURL") as! String? ?? "") {
            self.mediaURL = url
        } else {
            self.mediaURL = nil
        }
        
        self.location = location
        
    }
    
    private func getValue(from dictionary: [String: AnyObject], for key: String) -> AnyObject? {
        if let value = dictionary[key] {
            return value
        } else {
            return nil
        }
    }
}
