//
//  MyPageMyCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/03.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MyPageMyCell: UITableViewCell {
    static let reuse_id = "cell_id_mypage_my"
    @IBOutlet weak var myInfoView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
