//
//  FriendListTableViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

struct Friend {
    var id: Int
    //var profpic : String // name of profpic?
    var name : String
    
}

class FriendListTableViewController : UITableViewController {
    
    var friendos = [
        Friend(id: 1, name: "Joan"),
        Friend(id: 2, name: "Mike"),
        Friend(id: 3, name: "Slov"),
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendos.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your friendos"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        
        cell.textLabel?.text = friendos[indexPath.row].name
        
        return cell
    }
}
