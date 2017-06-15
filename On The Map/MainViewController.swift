//
//  MainViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    
    
    var logOutBarButton = UIBarButtonItem()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let barButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        logOutBarButton = barButtonItem
    }
    
    func logOut() {
        self.dismiss(animated: true) {
            print("View get dismissed")
            UdacityClient.deleteSession()
            UserDefaults.standard.set(false, forKey: "isAuthenticated")
        }
    }
}
