//
//  PostViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let backgroundView = UIView()
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaURLTextField.delegate = self
        locationTextField.delegate = self
        
        findLocationButton.layer.cornerRadius = 5.0
        findLocationButton.clipsToBounds = true
        
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back-arrow"), style: .plain, target: self, action: #selector(back))
        backBarButtonItem.tintColor = Udacity.Color.blue
        self.navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
        
        findLocationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLocation() {
        // Check if location textfield is empty or not.
        if (locationTextField.text?.isEmpty)! {
            presentErrorAlertController("Couldn't Find Location", alertMessage: "Please fill the text fields")
            return
        }
        
        if (mediaURLTextField.text?.isEmpty)! || mediaURLTextField.text == "http://" || mediaURLTextField.text == "https://" {
            presentErrorAlertController("Couldn't Find URL", alertMessage: "Please fill the text fields")
            return
        }
        
        //Add the placemark on the location
        let geoCoder = CLGeocoder()
        
        self.state(state: .loading, activityIndicator: activityIndicator, background: backgroundView)
        
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            //Check for errors
            if let error = error {
                self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: ("Error: " + error.localizedDescription))
            } else if (placemarks?.isEmpty)! {
                self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: "Please fill out with valid location")
            } else {
                
                self.getPlacemark(stringMap: self.locationTextField.text!, { (placemark: CLPlacemark?, error: Error?) in
                    guard error == nil else {
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        self.presentErrorAlertController("Couldn't Find Location", alertMessage: "Location not found")
                        return
                    }
                    if placemark != nil {
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        PostVerificationViewController.placemark = placemark!
                        self.presentPostVerificationViewController()
                    }
                })
            }
        }

    }
    
    func getPlacemark(stringMap: String, _ completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> Void) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(stringMap) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let placemark = placemarks!.first else {
                print("No placemark")
                return
            }
            
            completion(placemark, nil)
        }
    }
    
    func presentPostVerificationViewController() -> Void {
        let storyBoard = UIStoryboard(name: "Posting", bundle: nil)
        let postVerificationViewController = storyBoard.instantiateViewController(withIdentifier: "PostVerificationViewController") as! PostVerificationViewController
        if let stringURL = self.mediaURLTextField.text {
            let mediaURL = URL(string: stringURL)
            postVerificationViewController.mediaURL = mediaURL
            self.navigationController?.pushViewController(postVerificationViewController, animated: true)
        } else {
            let mediaURL = URL(string: "https://zulwiyozaputra.com")
            postVerificationViewController.mediaURL = mediaURL
            self.navigationController?.pushViewController(postVerificationViewController, animated: true)
        }
        
    }

}

extension PostViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mediaURLTextField {
            if !(textField.text?.contains("http://"))! && !(textField.text?.contains("https://"))! {
                textField.text = "http://"
            }
        }
    }
}

