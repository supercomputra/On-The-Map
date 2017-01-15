//
//  LogInViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var usernameTexField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // Variables
    
    var appDelegate: AppDelegate!
    var username: String?
    var password: String?
    
    // Actions

    @IBAction func logInButton(_ sender: Any) {
        if usernameTexField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(alertTitle: "", alertMessage: "Username and Password you entered are wrong")
        }
        
        requestToken()
        
        
    }
    
    // Get request Token
    private func requestToken() -> Void {
        
        let methodParameters: [String: AnyObject] = [
            :
        ]
        let url = appDelegate.UdacityURLFromParameters(methodParameters)
        let request = NSMutableURLRequest(url: url)
        let body = "{\"udacity\": {\"\": \"account@domain.com\", \"password\": \"********\"}}"
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            <#code#>
        }
        
        
    }
    
    
    // Complete Login
    private func completeLogin() -> Void {
        
        presentActivityIndicator()
        
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
    private func presentActivityIndicator() -> Void {
        let alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(ok)
        
        let activityIndicatorView = UIActivityIndicatorView(frame: alert.view.bounds)
        activityIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.color = UIColor.darkGray
        alert.view.addSubview(activityIndicatorView)
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
        self.present(alert, animated: true, completion: nil)
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
