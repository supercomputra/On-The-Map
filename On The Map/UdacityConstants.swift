//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 2/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

extension Udacity {

    struct Constants {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JsonApplication = "application/json"
    }
    
    struct Color {
        static let blue = UIColor(red: 21/255, green: 164/255, blue: 222/255, alpha: 1.0)
        static let purple = UIColor(red: 151/255, green: 499/255, blue: 233/255, alpha: 1.0)
        static let magenta = UIColor(red: 251/255, green: 57/255, blue: 112/255, alpha: 1.0)
        static let green = UIColor(red: 25/255, green: 195/255, blue: 192/255, alpha: 1.0)

    }
    
    struct Component {
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Method {
        static let StudentLocation = "/classes/StudentLocation"
        static let Session = "/session"
    }
    
    struct ParameterKeys {
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let UniqueKey = "uniqueKey"
        
    }
    
    struct Header {
        static let ContentType = "Content-Type"
        static let Accept = "Accept"
    }
    
    struct ResponseKeys {
        static let account = "account"
        static let key = "key"
        static let session = "session"
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let status = "status"
        static let error = "error"
    }

}
