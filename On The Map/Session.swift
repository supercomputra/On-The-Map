//
//  Session.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

class SessionManager: NSObject {
    
    static var session: Session? = nil
    
    struct Session {
        var id: String
        var expiration: String
        var key: String
        
        init(id: String, key: String, expiration: String) {
            self.id = id
            self.key = key
            self.expiration = expiration
        }
    }
    
}
