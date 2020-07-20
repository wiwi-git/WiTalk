//
//  ChatVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/10.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
class ChatVC: UIViewController {
    static let sb_id = "sb_id_chat_room"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textingAreaView:UIView!
    
    var destinationUserModel : UserModel?
    var uid : String?
    var chatRoomUid : String?
    var comments:[ChatModel.Comment] = []
    
    public var destinationUid :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.senderReuseId)
        //self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.receiverReuseId)
        self.tableView.register(UINib(nibName: "ChatMyBubble", bundle: nil), forCellReuseIdentifier: ChatMyBubble.cell_id)
        self.tableView.register(UINib(nibName: "ChatYourBubble", bundle: nil), forCellReuseIdentifier: ChatYourBubble.cell_id)
        
        self.textView.text = ""
        self.textingAreaView.layer.addBorder([UIRectEdge.top], color: .blue_chat_bubble, width: 1)
        self.textingAreaView.layer.masksToBounds = true
        
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10
        
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
//        if let info = self.roomInfo {
//            self.navigationItem.title = info.title
//        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.tableView.scrollToRow(at: IndexPath(row: self.testData.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func createRoom(){
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
            uid!: true,
            destinationUid! :true
            ]
        ]
        
        
        if(chatRoomUid == nil){
            // 방 생성 코드
            self.sendButton.isEnabled = false
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo) { (error, ref) in
                if error == nil {
                    self.checkChatRoom()
                }
            }
        } else {
            let value :Dictionary<String,Any> = [
                    "uid" : uid!,
                    "message" : textView.text!
                ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }
    
    @objc func checkChatRoom(){
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: { (datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                if let chatRoomDic = item.value as? [String:Any] {
                    let chatModel = ChatModel(JSON: chatRoomDic)
                    if chatModel?.users[self.destinationUid!] == true {
                        self.chatRoomUid = item.key
                        self.sendButton.isEnabled = true
                        self.getDestinationInfo()
                    }
                }
            }
        })
    }
    func getDestinationInfo(){
        
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
            self.destinationUserModel = UserModel()
            //self.destinationUserModel?.setValuesForKeys(datasnapshot.value as! [String:Any])
            let dic = datasnapshot.value as! [String:Any]
            
            self.destinationUserModel?.name = dic["name"] as? String
            self.destinationUserModel?.profileImageUrl = dic["profileImageUrl"] as? String
            self.destinationUserModel?.uid = dic["uid"] as? String
            
            self.getMessageList()
            
        })
    }
    func getMessageList() {
        
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value) { (snapshot) in
            self.comments.removeAll()
            
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:Any])
                self.comments.append(comment!)
            }
            self.tableView.reloadData()
            
        }
    }
    
}
extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCellIds.senderReuseId, for: indexPath) as? ChatCell {
        let item = comments[indexPath.row]
        if item.uid == uid {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChatMyBubble.cell_id, for: indexPath) as? ChatMyBubble {
                
                cell.textView.text = item.message
                cell.bottomLabel.text = "00:00"
                //cell.bottomLabel.isHidden = item.timeHidden
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChatYourBubble.cell_id, for: indexPath) as? ChatYourBubble {
                cell.topLabel.text =  destinationUserModel?.name
                cell.textView.text = item.message
                cell.bottomLabel.text = "00:00"
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
