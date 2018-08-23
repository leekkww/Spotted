//
//  FriendDetailViewController.swift
//  Spotted
//
//  Created by Joanne Lee on 8/21/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct FriendImage {
    var id: Int
    var name: String
}

class FriendDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var TableView: UITableView!
    
    var imageCount = 0
    var spots = [FriendImage]()

    var detailFriend: Friend? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailFriend = detailFriend {
            let myName = UserInfo.userName
            let friendName: String = detailFriend.name
            
            let db = Firestore.firestore()
            let docRef = db.collection("photo-data").document("\(myName)-\(friendName)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.imageCount = (document.data()!["count"] as? Int)!

                    for i in 0..<self.imageCount {
                        self.spots.append(FriendImage(id: i, name: friendName))
                    }
                    self.TableView.reloadData()
                } else {
                    print("Document does not exist")
                }
            }
            title = friendName
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPhoto", for: indexPath) as! FriendDetailViewCell
        
        let friendImage: FriendImage
        friendImage = spots[indexPath.row]
        
        cell.friendImage = friendImage

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 100)
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
