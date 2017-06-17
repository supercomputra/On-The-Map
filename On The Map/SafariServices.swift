//
//  SafariServices.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/17/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import SafariServices

extension UIViewController {
    func presentURLInSafariViewController(stringURL: String) {
        
        guard let url = URL(string: stringURL) else {
            return
        }
        
        if url.scheme != nil {
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(safariViewController, animated: true, completion: nil)
        } else {
            if let schemedURL = URL(string: "http://" + stringURL) {
                let safariViewController = SFSafariViewController(url: schemedURL, entersReaderIfAvailable: true)
                self.present(safariViewController, animated: true, completion: nil)
            } else {
                presentErrorAlertController("Sorry", alertMessage: "The page you try to visit has no valid URL")
            }
        }
    }
}
