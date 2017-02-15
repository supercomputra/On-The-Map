//
//  ParseClient.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    var session = URLSession.shared
    
    var requestedToken: String? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    
    override init() {
        super.init()
    }
    
    
    
}
