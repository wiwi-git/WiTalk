//
//  ChatCell.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/10.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    enum cellId:String {
        case senderReuseId = "cell_id_chat_sender"
        case receiverReuseId = "cell_id_chat_receiver"
    }
    
    var bgView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var topLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var bottomLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var textView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let padding: CGFloat = 16
    let innerSpacing: CGFloat = 4
    let extraSpacing: CGFloat = 80
    let secondaryPadding: CGFloat = 8

    
    /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let id = reuseIdentifier {
            if id == CellIds.senderCellId {
                self.setupSendersCell()
            }else {
                self.setupReceiversCell()
            }
        }
    }
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let id = reuseIdentifier {
            switch id {
            case cellId.senderReuseId.rawValue: self.setupSenderCell()
            case cellId.receiverReuseId.rawValue: self.setupReceiverCell()
            default: print("Error, ChatCell init, unknown ID")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setupSenderCell() {
        self.contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            bgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: padding),
            bgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: padding)
        ])
        bgView.layer.cornerRadius = 8
        bgView.backgroundColor = UIColor(displayP3Red: 0, green: 122/255, blue: 255/255, alpha: 1)
        
        self.bgView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: innerSpacing),
            textView.leadingAnchor.constraint(equalTo: self.bgView.leadingAnchor, constant: innerSpacing),
            textView.trailingAnchor.constraint(equalTo: self.bgView.trailingAnchor, constant: innerSpacing)
        ])
        
        bgView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor,constant: extraSpacing).isActive = true//이거 진짜 이해가 안가는데?????
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.white
        textView.text = "가시리 가시리잇고 나난 버리고 가시리잇고 나난 위 증즐가 태평성대"
        textView.backgroundColor = UIColor.clear
        
        self.bgView.addSubview(bottomLabel)
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: -2),
            bottomLabel.leadingAnchor.constraint(equalTo: self.bgView.leadingAnchor, constant: secondaryPadding),
            bottomLabel.bottomAnchor.constraint(equalTo: self.bgView.bottomAnchor, constant: secondaryPadding),
            bottomLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -secondaryPadding)
        ])
        
        bottomLabel.font = UIFont.systemFont(ofSize: 10)
        bottomLabel.textColor = UIColor.white
        bottomLabel.textAlignment = .right
        bottomLabel.text = "12:00 AM"
    }
    
    func setupReceiverCell(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
