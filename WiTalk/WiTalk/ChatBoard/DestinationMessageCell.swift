//
//  DestinationMessageCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class DestinationMessageCell: UITableViewCell {
    @IBOutlet weak var label_timeStamp: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleImageView.tintColor = .you_chat_bubble
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
