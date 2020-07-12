//
//  ChatListVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/01.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatListVC: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!
    
    var roomList = Array<Room>()
    var myInfo = MyInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roomList = myInfo.roomList
        
        self.chatRoomTableView.delegate = self
        self.chatRoomTableView.dataSource = self
        self.chatRoomTableView.register(ChatListCell.createNib(), forCellReuseIdentifier: ChatListCell.reuse_id)
        self.chatRoomTableView.reloadData()
    }
    
}
extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.reuse_id, for: indexPath) as! ChatListCell
        guard indexPath.row < self.roomList.count  else {
            print("Error, ChatListVc, roomList over range")
            return cell
        }
        let room = self.roomList[indexPath.row]
        
        cell.roomTitleLabel.text = room.title
        cell.newMessgeLabel.text = room.roomNewMessage
        cell.dateLabel.text = room.newDate
        if room.roomImageUrl == nil {
            cell.roomImageView.image = UIImage(named: "basic_profile")
        } else {
            ///////
        }
        
        if room.headCount > 1 {
            let text = cell.roomTitleLabel.text != nil ? cell.roomTitleLabel.text! : " "
            cell.roomTitleLabel.text = text + " +\(room.headCount)"
        }
        
        return cell
    }
}

