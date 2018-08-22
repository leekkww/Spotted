//
//  FriendListTableViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/20/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Friend {
    var id: Int
    //var profpic : String // name of profpic?
    var name : String
    
}

class FriendListTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    @IBOutlet var tableView: UITableView!

    var friendos = [Friend]()

    var filteredFriends = [Friend]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFriends = friendos.filter({( friend : Friend) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search Friendos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Load friend data
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("joleek")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.friendos = (document.data()!["friends"] as! [String]).map({
                    Friend(id:0,name:$0)
                })
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredFriends.count
        }
        return friendos.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent friendos"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        
        let friendo: Friend
        if isFiltering() {
            friendo = filteredFriends[indexPath.row]
        } else {
            friendo = friendos[indexPath.row]
        }
        
        cell.textLabel!.text = friendo.name
        //cell.detailTextLabel!.text = candy.category
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let friend = friendos[indexPath.row]
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailCandy = friend
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
}
