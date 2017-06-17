//
//  MapViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: MainViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        
        executeWithDelay(timeInSecond: 1.0) { 
            self.state(state: .loading, activityIndicator: self.activityIndicator, background: self.backgroundView)
            
            self.getAnnotations { (annotations: [MKPointAnnotation]) in
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(annotations)
                    performUIUpdatesOnMain {
                        self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                    }
                }
            }
        }
    }
    
    override func refresh() {
        super.refresh()
        DataSource.getStudents {
            performUIUpdatesOnMain {
                self.mapView.reloadInputViews()
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        pinView?.detailCalloutAccessoryView?.tintColor = Udacity.Color.green
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = Udacity.Color.magenta
            
            let button = UIButton(type: .detailDisclosure)
            button.tintColor = Udacity.Color.green
            pinView!.rightCalloutAccessoryView = button
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let annotationSubtitle = view.annotation?.subtitle! {
                self.presentURLInSafariViewController(stringURL: annotationSubtitle)
            }
        }
    }

}
