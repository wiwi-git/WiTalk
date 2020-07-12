//
//  MyPageListItemCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/03.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MyPageListItemCell: UITableViewCell {
    static let reuse_id = "cell_id_mypage_item"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImageView.layer.cornerRadius = 10
        self.iconImageView.layer.masksToBounds = true
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
