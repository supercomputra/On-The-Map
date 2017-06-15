//
//  LogInViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LogInViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var usernameTexField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var thirdQuarterView: UIView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    // Variables
    
    var appDelegate: AppDelegate!
    var username: String?
    var password: String?
    var validAccount: Bool = false
    let loginManager = UdacityClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        setUIEnabled(true)
        
        /*
        
        facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        if (FBSDKAccessToken.current() != nil) {
         // User is logged in, do work such as go to next view controller.
        }
        */
    }
    
    // Actions

    @IBAction func logInButton(_ sender: Any) {
        if usernameTexField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(alertTitle: "", alertMessage: "Username and Password you entered are wrong")
        }
        
        username = usernameTexField.text!
        password = passwordTextField.text!
        
        presentActivityIndicator(start: true)
        
        loginManager.postSession(username: username!, password: password!) { (error: PostSessionError?, errorDescription: String?, sessionDictionary: [String: String]?) in
            
            if error == nil {
                self.completeLogin()
            } else {
                if errorDescription == nil {
                    self.displayError("Error \(error.debugDescription) occurs")
                } else {
                    self.displayError(errorDescription!)
                }
            }
        }
    }
    
    
    
    // Complete Login
    private func completeLogin() -> Void {
        performUIUpdatesOnMain {
            self.presentActivityIndicator(start: false)
            self.presentNextView()
        }
    }
    
    // Presenting next view
    func presentNextView() -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeTabBarController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! UITabBarController
        self.present(homeTabBarController, animated: true, completion: nil)
    }
    
    // Presenting UI alert view
    private func showAlert(alertTitle: String, alertMessage: String) -> Void {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let destructive = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(destructive)
        present(alert, animated: true, completion: nil)
    }
    
    // Presenting activity Indicator
    private func presentActivityIndicator(start: Bool) -> Void {
        let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(ok)
        
        let activityIndicatorView = UIActivityIndicatorView(frame: alert.view.bounds)
        activityIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.color = UIColor.darkGray
        alert.view.addSubview(activityIndicatorView)
        activityIndicatorView.isUserInteractionEnabled = false
        if start == true {
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Displaying error message
    func displayError(_ error: String) {
        performUIUpdatesOnMain {
            self.presentActivityIndicator(start: false)
            self.showAlert(alertTitle: "Error", alertMessage: error)
        }
    }
    
    
}

// Facebook

extension LogInViewController: FBSDKLoginButtonDelegate {
    
    // LOGIN AND LOGOUT SETUP FOR FACEBOOK
    
    // Handling for if login complete
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("logged in")
        performUIUpdatesOnMain {
            self.presentNextView()
        }
    }
    
    // Handling for if login complete
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }

    
}

private extension LogInViewController {
    
    func setUIEnabled(_ enabled: Bool) -> Void {
        usernameTexField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        logInButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        
        // Muting login button color
        
        if enabled {
            logInButton.alpha = 1.0
        } else {
            logInButton.alpha = 0.5
        }
        
    }
    
}
