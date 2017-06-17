//
//  PostVerificationViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import MapKit

class PostVerificationViewController: PostingViewController {
    
    @IBOutlet weak var finishButton: UIButton!
    
    static var placemark: CLPlacemark? = nil

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showAnnotations([MKPlacemark(placemark: PostVerificationViewController.placemark!)], animated: true)
        finishButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finish() {
        print("finish button is tapped")
        let uniqueKey = UserDefaults.standard.value(forKey: "uniqueKey") as! String
        Parse.getStudentLocation(uniqueKey: uniqueKey) { (student: Student?, error: NSError?) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            
            guard student != nil else {
                print("no student returned")
                return
            }
            
            var studentToPut = student!
            
            studentToPut.firstName = student!.firstName!
            studentToPut.lastName = student!.lastName
            studentToPut.uniqueKey = student!.uniqueKey
            studentToPut.mediaURL = URL(string: "https://zulwiyozaputra.com")
            if let placemark = PostVerificationViewController.placemark {
                let city = placemark.locality!
                let state = placemark.administrativeArea!
                
                studentToPut.location!.mapString = "\(city) , \(state)"
                
                let location = placemark.location!
                let coordinate = location.coordinate
                studentToPut.location!.latitude = Double(coordinate.latitude)
                studentToPut.location!.longitude = Double(coordinate.longitude)
                
                Parse.putStudentLocation(student: studentToPut, completion: { (error: NSError?) in
                    if error == nil {
                        print("success put student information")
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
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
