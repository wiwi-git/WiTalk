//
//  ChatListCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/01.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    static let reuse_id = "cell_chat_list"

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var newMessgeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roomImageView.layer.cornerRadius = 10
        self.roomImageView.layer.masksToBounds = true
        self.roomImageView.tintColor = .green_profile
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.roomImageView.image = nil
        self.roomTitleLabel.text = nil
        self.dateLabel.text = nil
        self.newCountLabel.text = nil
        self.newMessgeLabel.text = nil
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class func createNib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
}
