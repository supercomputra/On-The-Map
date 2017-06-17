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
    
    

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    
    @IBOutlet weak var findLocatinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocatinButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation() {
        // Check if location textfield is empty or not.
        if (locationTextField.text?.isEmpty)! {
            presentErrorAlertController("Couldn't Find Location", alertMessage: "Please fill the text fields")
            return
        }
        
        //Add the placemark on the location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            //Check for errors
            if let error = error {
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: ("Error: " + error.localizedDescription))
            } else if (placemarks?.isEmpty)! {
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: "Please fill out with valid location")
            } else {
                
                self.getPlacemark(stringMap: self.locationTextField.text!, { (placemark: CLPlacemark?, error: Error?) in
                    guard error == nil else {
                        self.presentErrorAlertController("Couldn't Find Location", alertMessage: "Location not found")
                        return
                    }
                    if placemark != nil {
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyBoard.instantiateViewController(withIdentifier: "PostVerificationViewController") as! PostVerificationViewController
        self.navigationController?.pushViewController(addViewController, animated: true)
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
