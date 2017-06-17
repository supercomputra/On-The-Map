//
//  ConfigureUI.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit

enum State {
    case normal
    case loading
}

extension UIViewController {
    
    func state(state: State, activityIndicator: UIActivityIndicatorView, background: UIView) {
        switch state {
        case .loading:
            self.view.isUserInteractionEnabled = false
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            background.frame = frame
            background.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.40)
            self.view.addSubview(background)
            self.activityIndicator(activityIndicator: activityIndicator, animate: true, on: background)
            

        default:
            background.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            self.activityIndicator(activityIndicator: activityIndicator, animate: false, on: background)
            
        }
    }
}
