//
//  ChatRoomViewController.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomsViewController: UIViewController {
    var uid : String!
    var chatRooms:[ChatModel]! = []
    var destinationUsers : [String] = []
    
    @IBOutlet weak var tableview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        
        self.uid = Auth.auth().currentUser?.uid
        
        self.getChatRoomList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getChatRoomList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getChatRoomList() {
        print("getChatRoomList")
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/" + uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
            
            self.chatRooms.removeAll()
            print("children.count? \(dataSnapshot.children.allObjects.count)")
            
            for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                if let chatroomdic = item.value as? [String:Any] {
                    let chatmodel = ChatModel(JSON: chatroomdic)
                    self.chatRooms.append(chatmodel!)
                }
            }
            
            print("chatrooms.count \(self.chatRooms.count)")
            self.tableview.reloadData()
            
        }//observeSingleEvent
    }
    
 

}
extension ChatRoomsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        var destinationUid:String?
        for item in chatRooms[indexPath.row].users {
            if item.key != self.uid {
                destinationUid = item.key
                self.destinationUsers.append(destinationUid!)
            }
        }
        
        Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: .value) { (dataSnapshot) in
            
            let item = dataSnapshot.value as! [String:Any]
            
            cell.label_title.text = item["name"] as? String
            
            cell.imageview.layer.cornerRadius = cell.imageview.frame.width/2
            cell.imageview.layer.masksToBounds = true
            /*
            let url = URL(string: item["profileImageUrl"] as! String)
            URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    cell.imageview.image = UIImage(data: data!)
                }
            }.resume()
            */
            cell.imageview.image = #imageLiteral(resourceName: "basic_profile")
            
            let lastMessageKey = self.chatRooms[indexPath.row].comments.keys.sorted {$0 > $1}
            cell.label_lastmessage.text = self.chatRooms[indexPath.row].comments[lastMessageKey[0]]?.message
            let unixTime = self.chatRooms[indexPath.row].comments[lastMessageKey[0]]?.timestamp
            cell.label_tiemstamp.text = unixTime?.toDayTime
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationUid = self.destinationUsers[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "sb_id_chatvc") as! ChatViewController
        vc.destinationUid = destinationUid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

class CustomCell : UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label_lastmessage: UILabel!
    @IBOutlet weak var label_title : UILabel!
    @IBOutlet weak var label_tiemstamp: UILabel!
}
