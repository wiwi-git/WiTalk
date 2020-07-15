//
//  ChatYourBubble.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/16.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatYourBubble: UITableViewCell {
    static let cell_id = "cell_id_your_bubble"
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
