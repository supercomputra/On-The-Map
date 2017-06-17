//
//  InitialViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/17/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uniqueKey = UserDefaults.standard.value(forKey: "uniqueKey") as? String {
            print("logging in with \(uniqueKey)")
            presentMainView(animate: true)
        } else {
            presentLoginView(animate: true)
        }
    }
    
    // Presenting Main view
    func presentMainView(animate: Bool) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeTabBarController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
        if animate {
            self.present(homeTabBarController, animated: true, completion: nil)
        } else {
            self.present(homeTabBarController, animated: false, completion: nil)
        }
    }
    
    // Presenting Login view
    func presentLoginView(animate: Bool) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LogInViewController
        if animate {
            self.present(logInViewController, animated: true, completion: nil)
        } else {
            self.present(logInViewController, animated: false, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
