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
    
    let loginManager = UdacityClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// Table View Delegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Student's Cell", for: indexPath)
        cell.textLabel?.text = "Student Label"
        cell.detailTextLabel?.text = "Student detail"
        return cell
    }
}

// Table View Data Source
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
