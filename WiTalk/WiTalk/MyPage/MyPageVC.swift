//
//  MyPageVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/03.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController {
    struct ListItem {
        let icon:UIImage
        let name:String
    }
    
    let itemList:Array<ListItem> = [
        ListItem(icon: UIImage(named: "notification")!, name: "공지사항"),
        ListItem(icon: UIImage(named: "build")!, name: "무엇을 넣을까"),
        ListItem(icon: UIImage(named: "logout")!, name: "로그아웃")
    ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}
extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return itemList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMyCell.reuse_id, for: indexPath) as! MyPageMyCell
            let my = MyInfo.shared
            cell.emailLabel.text = my.my.email
            cell.nameLabel.text = my.my.name
            
            if let url = my.my.profileImageUrl {
                //cell.profileImageView.image =
            } else {
                cell.profileImageView.image = UIImage(named: "basic_profile")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageListItemCell.reuse_id, for: indexPath) as! MyPageListItemCell
            guard self.itemList.count > indexPath.row else {
                print("Error, MypageVC cellForRowAt itemList, index over")
                return cell
            }
            let item = self.itemList[indexPath.row]
            cell.itemNameLabel.text = item.name
            cell.iconImageView.image = item.icon
            return cell
        }
    }
}
