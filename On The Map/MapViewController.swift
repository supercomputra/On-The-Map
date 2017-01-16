//
//  MapViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    // Outlets
    
    // Actions
    
    @IBAction func logOutButtonItem(_ sender: Any) {
        
        deleteSession()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func deleteSession() -> Void {
        
        // Createing request
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        // Adding delete method into request
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil { // Handle error…
                return
            }
            
            print(data!)
            
            let range = Range(uncheckedBounds: (5, 0))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(newData!)
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
