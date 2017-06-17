//
//  LoadingViewManager.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/17/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func activityIndicator(activityIndicator: UIActivityIndicatorView, animate: Bool, on view: UIView) {
        if animate {
            let centerX = self.view.bounds.size.width/2
            let centerY = self.view.bounds.size.height/2
            activityIndicator.center = CGPoint(x: centerX, y: centerY)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
        } else {
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()
        }
    }
}
