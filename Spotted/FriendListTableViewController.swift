//
//  FriendListTableViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit

struct Headline {
    var id : Int
    var title : String
    var text : String
    var image : String
    
}

class FriendListTableViewController : UITableViewController {
    var headlines = [
        Headline(id: 1, title: "Lorem Ipsum", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", image: "Apple"),
        Headline(id: 2, title: "Aenean condimentum", text: "Ut eget massa erat. Morbi mauris diam, vulputate at luctus non.", image: "Banana"),
        Headline(id: 3, title: "In ac ante sapien", text: "Aliquam egestas ultricies dapibus. Nam molestie nunc.", image: "Cantaloupe"),
        ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = headlines[indexPath.row].title
        
        return cell
    }
}
