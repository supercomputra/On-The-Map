//
//  MainTabBarController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 6/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewTabBar:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_mapview-deselected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_mapview-selected"))
        
        let listViewTabBar:UITabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon_listview-selected").withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected"))
        
        self.tabBar.items![0] = mapViewTabBar
        self.tabBar.items![1] = listViewTabBar

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
