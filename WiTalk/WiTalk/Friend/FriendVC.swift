//
//  FriendVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//
//깃 테스트 
import UIKit

class FriendVC: UIViewController {

    @IBOutlet weak var friendTableView: UITableView!
    
    var friendList = Array<Person>()
    var myInfo = MyInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendList = myInfo.friendList
        self.friendTableView.delegate = self
        self.friendTableView.dataSource = self
        self.friendTableView.register(FriendCell.createNib(), forCellReuseIdentifier: FriendCell.reuse_id)
        
    }
    
}
extension FriendVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.friendList.count
        }
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0: return "my"
//        case 1: return "friend"
//        default: return nil
//        }
//    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuse_id, for: indexPath) as! FriendCell
        if indexPath.section == 0 {
            cell.nameLabel.text = self.myInfo.my.name
            cell.statusMsgLabel.text = self.myInfo.my.statusMsg
            if self.myInfo.my.profileImageUrl != nil {
                // imageView에 이미지 url로 연결시킬거 좋은 오픈소스가 있었는데 이름이 기억안나네 sd_web이였나
            } else {
                cell.profileImageView.image = UIImage(named: "basic_profile")
            }
            
        } else {
            guard self.friendList.count > indexPath.row else {
                print("Error FriendVC.cellForRowAt. section 1- over range")
                return cell
            }
            let friend = self.friendList[indexPath.row]
            cell.nameLabel.text = friend.name
            cell.statusMsgLabel.text = friend.statusMsg
            if friend.profileImageUrl != nil {
                // imageView에 이미지 url로 연결시킬거
            } else {
                cell.profileImageView.image = UIImage(named: "basic_profile")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.sb_id) as? ProfileVC {
                vc.modalPresentationStyle = .popover
                vc.userInfo = myInfo.my
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            guard indexPath.row < self.friendList.count else {
                print("ERROR, friendVC - didSelectRowAt index over")
                return
            }
            let userinfo = self.friendList[indexPath.row]
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.sb_id) as? ProfileVC {
                vc.modalPresentationStyle = .popover
                vc.userInfo = userinfo
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
