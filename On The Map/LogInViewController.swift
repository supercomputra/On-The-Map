//
//  LogInViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit

class LogInViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var thirdQuarterView: UIView!
//    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    // Variables
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let backgroundView = UIView()
    
    var appDelegate: AppDelegate!
    var email: String?
    var password: String?
    var validAccount: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        logInButton.layer.cornerRadius = 5.0
        logInButton.clipsToBounds = true
        
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self


    }

    @objc private func logIn() {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            presentErrorAlertController("", alertMessage: "Username and Password you entered are wrong")
        } else {
            
            email = emailTextField.text!
            password = passwordTextField.text!
            
            
            
            
            self.state(state: .loading, activityIndicator: self.activityIndicator, background: self.backgroundView)
            
            Udacity.postSession(username: email!, password: password!) { (error: RequestError?, errorDescription: String?) in
                if error == nil {
                    performUIUpdatesOnMain {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                    self.completeLogin(withLogin: true)
                } else {
                    if errorDescription == nil {
                        performUIUpdatesOnMain {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                            self.displayError("Error \(error.debugDescription) occurs")
                        }
                        
                    } else {
                        performUIUpdatesOnMain {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                            self.displayError(errorDescription!)
                        }
                    }
                }
            }
        }
        
        
    }
    
    @objc private func signUp() {
        let url = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        self.presentURLInSafariViewController(stringURL: url)
    }
    
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

    // Displaying error message
    func displayError(_ error: String) {
        performUIUpdatesOnMain {
            self.presentErrorAlertController("Error", alertMessage: error)
        }
    }
    
    
}

// Facebook
// TODO: FACEBOOK LOGIN
/*
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
*/
