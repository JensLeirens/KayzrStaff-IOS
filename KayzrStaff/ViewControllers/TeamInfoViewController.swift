//
//  TeamInfoViewController.swift
//  KayzrStaff
//
//  Created by Jens Leirens on 05/12/2017.
//  Copyright © 2017 Jens Leirens. All rights reserved.
//

import UIKit
import KayzrStaff_Shared

class TeamInfoViewController : UITableViewController {
    @IBOutlet weak var teamTable : UITableView!
    
    private var userTask: URLSessionTask?
    var team : [User] = []
    
    override func viewDidLoad() {
        userTask?.cancel()
        userTask = KayzrStaffAPI.getAllUsers() {
            self.team = $0!
            self.teamTable.reloadData()
        }
        userTask!.resume()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamInfoCell
        cell.user = team[indexPath.row]
        return cell
    }
    
    
}

