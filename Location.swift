//
//  Location.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/14/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import MapKit

struct Location {
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    init(latitude: Double, longitude: Double, mapString: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
    }
}
