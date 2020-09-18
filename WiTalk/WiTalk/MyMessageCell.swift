//
//  MyMessageCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {
    @IBOutlet weak var label_timeStamp: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleImageView.tintColor = .my_chat_bubble
    }
}
