//
//  FriendCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    static let reuse_id = "cell_friend_list"
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusMsgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.tintColor = .green_profile
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.nameLabel.text = nil
        self.statusMsgLabel.text = nil
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
    class func createNib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    class var identifier: String {
        return String(describing: self)
    }
}
