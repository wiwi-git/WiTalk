//
//  PeopleViewController.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SDWebImage

class PeopleViewController: UIViewController {
    static let sb_id = "sb_id_peoplevc"
    static let sb_id_tabbar = "sb_id_peoplevc_tabbar"
    
    var friendArray : [UserModel] = []
    var myInfo:UserModel?
    
    @IBOutlet weak var tableview : UITableView!
    
    @IBOutlet weak var topLabelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(PeopleViewCell.createNib(), forCellReuseIdentifier: PeopleViewCell.reuse_id)
        
        
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.friendArray.removeAll()
            
            let myUid = Auth.auth().currentUser?.uid
            
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel()
                userModel.name = dic["name"] as? String
                userModel.profileImageUrl = dic["profileImageUrl"] as? String
                userModel.uid = dic["uid"] as? String
                userModel.status = dic["status"] as? String
                
                
                //userModel.setValuesForKeys()
                if userModel.uid == nil {
                    continue
                }
                
                if userModel.uid! == myUid! {
                    self.myInfo = userModel
                    print("내 아이디야")
                    continue
                } else {
                    self.friendArray.append(userModel)
                }
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableview.reloadData()
    }
    
 
}
extension PeopleViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.friendArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.backgroundColor = UIColor.clear
        title.font = UIFont.systemFont(ofSize: 10)
        title.textColor = UIColor.lightGray
        
        switch section {
        case 0:
            title.text = "my"
            return title
        case 1:
            title.text = "firend"
            return title
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: PeopleViewCell.reuse_id, for :indexPath) as! PeopleViewCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = self.myInfo?.name
            if let url = self.myInfo?.profileImageUrl {
                cell.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "basic_profile"))
                cell.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "basic_profile"), options: [.refreshCached], completed: nil)
            } else {
                cell.profileImageView.image = UIImage(named: "basic_profile")
            }
            cell.statusMsgLabel.text = self.myInfo?.status
        } else {
            guard self.friendArray.count > indexPath.row else {
                print("Error FriendVC.cellForRowAt. section 1- over range")
                return cell
            }
            let friend = self.friendArray[indexPath.row]
            cell.nameLabel.text = friend.name
            cell.statusMsgLabel.text = friend.status
            
            if let url = friend.profileImageUrl {
                cell.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "basic_profile"))
            } else {
                cell.profileImageView.image = UIImage(named: "basic_profile")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! PeopleViewCell
            let storyboard = self.storyboard
            let vc = storyboard?.instantiateViewController(withIdentifier: ProfileViewController.sb_id) as! ProfileViewController
            vc.modalPresentationStyle = .popover
            
            vc.previousImage = cell.profileImageView.image
            vc.previousMessage = cell.statusMsgLabel.text
            vc.userName = cell.nameLabel.text
            
            self.present(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "ChatBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "sb_id_chatvc") as? ChatViewController
            vc?.destinationUid = self.friendArray[indexPath.row].uid
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
