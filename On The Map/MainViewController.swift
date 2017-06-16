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
import SafariServices



class MainViewController: UIViewController {
    
    var logOutBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard var viewControllers = self.tabBarController?.viewControllers else {
            return
        }
        
        title = "On The Map"
        
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
        
        let logOutBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logOut))
        let font = UIFont.boldSystemFont(ofSize: 15.0)
        logOutBarButtonItem.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: Udacity.Color.blue], for:UIControlState.normal)
        logOutBarButton = logOutBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(add))
        addBarButtonItem.tintColor = Udacity.Color.blue
        let refreshBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))
        refreshBarButtonItem.tintColor = Udacity.Color.blue
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, refreshBarButtonItem]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func logOut() {
        dismiss(animated: true) {
            print("View get dismissed")
            Udacity.deleteSession()
            UserDefaults.standard.set(false, forKey: "isAuthenticated")
        }
    }
    
    func add() {
        presentPostingViewController()
    }
    
    func refresh() {
        print("Refresh button tapped")
        DataSource.getStudents()
    }
    
    func getAnnotations(_ completion: @escaping (_ completion: [MKPointAnnotation])-> Void) {
        
        var annotations = [MKPointAnnotation]()
        
        DataSource.getStudents { (students: [Student]) in
            
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
                    annotation.subtitle = "https://zulwiyozaputra.com"
                }
                
                annotations.append(annotation)
            }
            completion(annotations)
        }
    }
    
    // Presenting next view
    func presentPostingViewController() -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    
    func presentURLInSafariViewController(stringURL: String) {
        
        guard let url = URL(string: stringURL) else {
            return
        }
        
        if url.scheme != nil {
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(safariViewController, animated: true, completion: nil)
        } else {
            if let schemedURL = URL(string: "http://" + stringURL) {
                let safariViewController = SFSafariViewController(url: schemedURL, entersReaderIfAvailable: true)
                self.present(safariViewController, animated: true, completion: nil)
            } else {
                presentErrorAlertController("Sorry", alertMessage: "The page you try to visit has no valid URL")
            }
        }
    }

    
}
