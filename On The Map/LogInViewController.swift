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

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
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
    
    // Actions

    @IBAction func logInButton(_ sender: Any) {
        if usernameTexField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(alertTitle: "", alertMessage: "Username and Password you entered are wrong")
        }
        
        username = usernameTexField.text!
        password = passwordTextField.text!
        
        postSession()
        
        
    }
    
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
    
    // Get request Token
    private func postSession() -> Void {
        
        presentActivityIndicator(start: true)
        
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        let body = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}"
        
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ error: String) {
                performUIUpdatesOnMain {
                    self.showAlert(alertTitle: "Error", alertMessage: error)
                }
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let securedData = data?.subdata(in: range)
            
            
            // Was there any error?
            guard (error == nil) else {
                displayError("There was an error")
                return
            }
            
            // Did we get a successfull 200 response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            // Was there any data returned?
            guard let data = securedData else {
                displayError("No data was returned by the request")
                return
            }
            
            
            // Parse the data
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            } catch {
                displayError(String(describing: error))
                return
            }
            
            if statusCode != 200 {
                
                guard let errorMessage = parsedResult["error"] as? String else {
                    displayError(String(describing: error))
                    return
                }
                
                performUIUpdatesOnMain {
                    self.presentActivityIndicator(start: false)
                }
                
                displayError(errorMessage)
                
            } else {
                
                print("\(parsedResult!)")
                
                print("Taking accountData")
                
                guard let accountData = parsedResult["account"] as? [String: AnyObject] else {
                    displayError(String(describing: error))
                    return
                }
                
                print(accountData)
                
                
                print("Taking registrationStatus")
                guard let registrationStatus = accountData["registered"] as? Bool else {
                    displayError(String(describing: error))
                    return
                }
                
                print(registrationStatus)
                
                if registrationStatus {
                    self.validAccount = true
                } else {
                    displayError("Username and password invalid")
                }
                
                performUIUpdatesOnMain {
                    self.presentActivityIndicator(start: false)
                }
                
                
                if self.validAccount {
                    self.completeLogin()
                }
                
            }
 
        }
        
        task.resume()
        
    }
    
    
    // Complete Login
    private func completeLogin() -> Void {
        
        print("login success")
        
        performUIUpdatesOnMain {
            self.presentNextView()
        }
        
    }
    
    // Presenting next view
    private func presentNextView() -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeTabBarController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! UITabBarController
        self.present(homeTabBarController, animated: true, completion: nil)
    }
    
    // Presenting UI alert view
    private func showAlert(alertTitle: String, alertMessage: String) -> Void {
        let alert = UIAlertController(title: alertTitle, message: displayError(errorMessage: alertMessage), preferredStyle: UIAlertControllerStyle.alert)
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
    private func displayError(errorMessage: String) -> String {
        return errorMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the AppDelegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        setUIEnabled(true)
        
        facebookLoginButton = FBSDKLoginButton()
        // Optional: Place the button in the center of your view.
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            
        }
        
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
