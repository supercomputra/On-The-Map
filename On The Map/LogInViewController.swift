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
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let backgroundView = UIView()
    
    var appDelegate: AppDelegate!
    var username: String?
    var password: String?
    var validAccount: Bool = false
    
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
        
        self.state(state: .loading, activityIndicator: activityIndicator, background: backgroundView)
        
        if usernameTexField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(alertTitle: "", alertMessage: "Username and Password you entered are wrong")
        }
        
        // TODO: TextField checker before login
        
        username = usernameTexField.text!
        password = passwordTextField.text!
        
        self.state(state: .loading, activityIndicator: self.activityIndicator, background: self.backgroundView)
        
        Udacity.postSession(username: username!, password: password!) { (error: RequestError?, errorDescription: String?) in
            if error == nil {
                self.completeLogin(withLogin: true)
            } else {
                if errorDescription == nil {
                    self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                    self.displayError("Error \(error.debugDescription) occurs")
                } else {
                    self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                    self.displayError(errorDescription!)
                }
            }
        }
    }
    
    // Get student data
    
    // Complete Login
    private func completeLogin(withLogin: Bool) -> Void {
        performUIUpdatesOnMain {
            if withLogin {
                self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                self.presentNextView(animate: true)
            } else {
                self.presentNextView(animate: false)
            }
            
        }
    }
    
    // Presenting next view
    func presentNextView(animate: Bool) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        if animate {
            self.present(mainTabBarController, animated: true, completion: nil)
        } else {
            self.present(mainTabBarController, animated: false, completion: nil)
        }
    }
    
    // Presenting UI alert view
    private func showAlert(alertTitle: String, alertMessage: String) -> Void {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let destructive = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(destructive)
        present(alert, animated: true, completion: nil)
    }
    
    
    // Displaying error message
    func displayError(_ error: String) {
        performUIUpdatesOnMain {
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
            self.presentNextView(animate: true)
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
