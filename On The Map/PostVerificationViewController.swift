//
//  PostVerificationViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import MapKit

class PostVerificationViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let backgroundView = UIView()
    
    var mediaURL: URL? = nil
    
    @IBOutlet weak var finishButton: UIButton!
    
    static var placemark: CLPlacemark? = nil

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back-arrow"), style: .plain, target: self, action: #selector(back))
        backBarButtonItem.tintColor = Udacity.Color.blue
        self.navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
        
        self.mapView.showAnnotations([MKPlacemark(placemark: PostVerificationViewController.placemark!)], animated: true)
        finishButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromDataDelegate() {
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func finish() {
        
        self.state(state: .loading, activityIndicator: activityIndicator, background: backgroundView)
        print("finish button is tapped")
        let uniqueKey = UserDefaults.standard.value(forKey: "uniqueKey") as! String
        Parse.getStudentLocation(uniqueKey: uniqueKey) { (student: Student?, error: NSError?) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            
            var studentToPut = student!
            
            studentToPut.firstName = student!.firstName!
            studentToPut.lastName = student!.lastName
            studentToPut.uniqueKey = student!.uniqueKey
            studentToPut.mediaURL = self.mediaURL!
            
            if let placemark = PostVerificationViewController.placemark {
                let city = placemark.locality!
                let state = placemark.administrativeArea!
                
                studentToPut.location!.mapString = "\(city) , \(state)"
                
                let location = placemark.location!
                let coordinate = location.coordinate
                studentToPut.location!.latitude = Double(coordinate.latitude)
                studentToPut.location!.longitude = Double(coordinate.longitude)
            }
            
            if error == nil {
                Parse.putStudentLocation(student: studentToPut, completion: { (error: NSError?) in
                    if error == nil {
                        print("success put student information")
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        print(error.debugDescription)
                    }
                })
                
            } else {
                
                Parse.postStudentLocation(student: studentToPut, completion: { (error: NSError?) in
                    if error == nil {
                        print("success put student information")
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                        print(error.debugDescription)
                    }
                })
                
            }

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
