//
//  AlertViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/17/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentErrorAlertController(_ alertTitle: String?, alertMessage: String?) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            let destructive = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
            alert.addAction(destructive)
            
            guard alertTitle != nil else {
                if alertMessage != nil {
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    alert.title = "Error"
                    alert.message = "Something Went Wrong"
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
