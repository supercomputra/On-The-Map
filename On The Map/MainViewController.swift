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
    
    let logOutBarButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(self.logOutBarButton, animated: true)
    }
    
    func logOut() {
        print(logOut())
    }
}
