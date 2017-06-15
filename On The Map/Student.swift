//
//  Student.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/14/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

struct Student {
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mediaURL: URL
    let location: Location
    
    
    init(objectID: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) {
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = URL(string: mediaURL)!
        self.location = Location(latitude: latitude, longitude: longitude, mapString: mapString)
    }
}
