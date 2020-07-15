//
//  ChatMyBuble.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/16.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatMyBubble: UITableViewCell {
    static let cell_id = "cell_id_my_bubble"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
