//
//  MapViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MainViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        
        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_mapview-deselected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_mapview-selected"))
        self.tabBarItem = customTabBarItem
        
        self.navigationItem.setLeftBarButton(self.logOutBarButton, animated: true)
        getAnnotations { (annotations: [MKPointAnnotation]) in
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(annotations)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)
                app.open(url!, completionHandler: nil)
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let url = URL(string: ((annotationView.annotation?.subtitle)!)!)
            app.open(url!, options: [ : ], completionHandler: nil)
        }
    }

}
