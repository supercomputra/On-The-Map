//
//  TableViewController.swift
//  On The Map
//
//  Created by Zulwiyoza Putra on 1/15/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import UIKit

class TableViewController: MainViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(self.logOutBarButton, animated: true)
        getStudents { (students: [Student]) in
            self.students = students
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }

}

// Table View Delegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Student's Cell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = (student.firstName!) + " " + (student.lastName!)
        cell.detailTextLabel?.textColor = Udacity.Color.green
        
        if let mediaURL = student.mediaURL {
            let stringURL = String(describing: mediaURL)
            cell.detailTextLabel?.text = stringURL
        } else {
            cell.detailTextLabel?.text = "Unknown Media URL"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        if let mediaURL = student.mediaURL {
            let stringURL = String(describing: mediaURL)
            self.openURLInSafariViewController(stringURL: stringURL)
        }
        
    }
}

// Table View Data Source
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
}
