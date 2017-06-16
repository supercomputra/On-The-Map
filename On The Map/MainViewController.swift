//
//  MainViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MainViewController: UIViewController {
    
    var students = [Student]()
    
    var logOutBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard var viewControllers = self.tabBarController?.viewControllers else {
            return
        }
        
        let mapViewTabBar:UITabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon_mapview-selected").withRenderingMode(.alwaysTemplate), selectedImage: #imageLiteral(resourceName: "icon_mapview-deselected").withRenderingMode(.alwaysOriginal))
        mapViewTabBar.title = nil
        mapViewTabBar.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        let listViewTabBar:UITabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon_listview-selected").withRenderingMode(.alwaysTemplate), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected").withRenderingMode(.alwaysOriginal))
        listViewTabBar.title = nil
        listViewTabBar.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        let mapViewController = viewControllers[0]
        let tableViewController = viewControllers[1]
        
        mapViewController.tabBarItem = mapViewTabBar
        tableViewController.tabBarItem = listViewTabBar
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
        
        let barButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logOut))
        barButtonItem.tintColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        logOutBarButton = barButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func logOut() {
        dismiss(animated: true) {
            print("View get dismissed")
            UdacityClient.deleteSession()
            UserDefaults.standard.set(false, forKey: "isAuthenticated")
        }
    }
    
    func getStudents(_ completion: @escaping (_ students: [Student]) -> Void) {
        ParseClient.getStudentLocation { (students: [Student]?, error: RequestError?, errorDescription: String?) in
            guard students != nil else {
                return
            }
            completion(students!)
        }
    }
    
    func getAnnotations(_ completion: @escaping (_ completion: [MKPointAnnotation])-> Void) {
        
        var annotations = [MKPointAnnotation]()
        
        getStudents { (students: [Student]) in
            
            for student in students {
                let annotation = MKPointAnnotation()
                if let coordinate = student.location?.coordinate {
                    annotation.coordinate = coordinate
                } else {
                    annotation.coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
                }
                annotation.title = "\(student.firstName ?? "") \(student.lastName ?? "")"
                
                if let mediaURL = student.mediaURL {
                    let stringURL = String(describing: mediaURL)
                    annotation.subtitle = stringURL
                } else {
                    annotation.subtitle = "Unknown Media URL"
                }
                
                annotations.append(annotation)
            }
            completion(annotations)
        }
    }

    
}
