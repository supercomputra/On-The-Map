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
    let mapString: String
    let mediaURL: URL
    let latitude: Float
    let longitude: Float
    
    init(objectID: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Int, longitude: Int) {
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = URL(string: mediaURL)!
        self.latitude = Float(latitude)
        self.longitude = Float(longitude)
        
    }
}
