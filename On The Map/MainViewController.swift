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
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let backgroundView = UIView()
    
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
        self.navigationItem.setLeftBarButton(logOutBarButtonItem, animated: false)
        
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
        logOutDialogueBox {
            self.state(state: .loading, activityIndicator: self.activityIndicator, background: self.backgroundView)
            Udacity.deleteSession {
                UserDefaults.standard.removeObject(forKey: "uniqueKey")
                UserDefaults.standard.synchronize()
                performUIUpdatesOnMain {
                    self.state(state: .normal, activityIndicator: self.activityIndicator, background: self.backgroundView)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func add() {
        presentPostingViewController()
    }
    
    func refresh() {
        guard isConnectedToNetwork() else {
            presentErrorAlertController("Network Connection Error", alertMessage: "No network connection, please try again later")
            return
        }
    }
    
    func getAnnotations(_ completion: @escaping (_ completion: [MKPointAnnotation])-> Void) {
        
        guard isConnectedToNetwork() else {
            presentErrorAlertController("Network Connection Error", alertMessage: "No network connection, please try again later")
            return
        }
        
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
        let storyBoard = UIStoryboard(name: "Posting", bundle: nil)
        let addViewController = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    
    
}

extension MainViewController {
    func logOutDialogueBox(completion: (@escaping () -> Void)) {
        let alert = UIAlertController(title: "Log Out", message: "Are You Sure Want To Log Out?", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let logOut = UIAlertAction(title: "Log Out", style: .destructive) { (action: UIAlertAction) in
            completion()
        }
        alert.addAction(logOut)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
