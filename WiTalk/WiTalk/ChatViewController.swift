//
//  ChatViewController.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textingAreaView:UIView!
    
    var destinationUserModel :UserModel?
    var uid : String?
    var chatRoomUid : String?
    var comments:[ChatModel.Comment] = []
    
    public var destinationUid :String?
    var myName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        let email = (Auth.auth().currentUser?.email)!
        let emailSplit = email.split(separator: "@")
        let userId = String(emailSplit[0])
        myName = userId
        
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        
        //self.tableView.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        self.tableView.register(UINib(nibName: "MyMessageCell", bundle: nil), forCellReuseIdentifier: "MyMessageCell")
        //self.tableView.register(DestinationMessageCell.self, forCellReuseIdentifier: "DestinationMessageCell")
        self.tableView.register(UINib(nibName: "DestinationMessageCell", bundle: nil), forCellReuseIdentifier: "DestinationMessageCell")
        
        self.textView.text = ""
        self.textingAreaView.layer.addBorder([UIRectEdge.top], color: .systemBlue, width: 1)
        self.textingAreaView.layer.masksToBounds = true
        
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
        }
        if self.comments.count > 0 {
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (complete) in
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func dissmissKeyboard() {
        self.view.endEditing(true)
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
                    "message" : self.textView.text!,
                    "timestamp" : ServerValue.timestamp(),
                    "userName" : myName!
                ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value) { (err, ref) in
                self.textView.text = ""
            }
            
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
            self.destinationUserModel?.pushToken = dic["pushToken"] as? String
            
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
            if self.comments.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count - 1, section: 0), at: .bottom, animated: true)
            }
            
        }
    }
    /*
        func getMessageList(){
        databaseRef = Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments")
        observe = databaseRef?.observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            var readUserDic : Dictionary<String,AnyObject> = [:]
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let key = item.key as String
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                let comment_motify = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                comment_motify?.readUsers[self.uid!] = true
                readUserDic[key] = comment_motify?.toJSON() as! NSDictionary
                self.comments.append(comment!)
            }
            
            let nsDic = readUserDic as NSDictionary
            
            if(self.comments.last?.readUsers.keys == nil){
                return
            }
            
            if(!(self.comments.last?.readUsers.keys.contains(self.uid!))!){
                
            
            datasnapshot.ref.updateChildValues(nsDic as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                
                self.tableview.reloadData()
                
                if self.comments.count > 0{
                    self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
                    
                }
                
            })
            }else{
                self.tableview.reloadData()
                
                if self.comments.count > 0{
                    self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
                    
                }
            }

        })
        
    }*/
}
extension ChatViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.comments[indexPath.row].uid == uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            cell.messageLabel.text = self.comments[indexPath.row].message
            cell.messageLabel.numberOfLines = 0
            
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_timeStamp.text = time.toDayTime
            } else {
                cell.label_timeStamp.text = ""
            }
             
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            cell.nameLabel.text = destinationUserModel?.name
            cell.messageLabel.text = self.comments[indexPath.row].message
            cell.messageLabel.numberOfLines = 0;
            if let time = self.comments[indexPath.row].timestamp {
                cell.label_timeStamp.text = time.toDayTime
            } else {
                cell.label_timeStamp.text = ""
            }
            
            
//            let url = URL(string:(self.destinationUserModel?.profileImageUrl)!)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width/2
            cell.profileImageView.clipsToBounds = true
            /*
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }.resume()
            */
            cell.profileImageView.image = #imageLiteral(resourceName: "basic_profile")
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension Int {
    var toDayTime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "YYYY.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
    }
}
