//
//  ChatVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/10.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textingAreaView:UIView!
    struct TestForm {
        let name:String
        let msg:String
        let time:String
        var timeHidden = false
    }
    var testData:Array<TestForm> = [
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:00 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:00 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf  ", time: "12:00 am", timeHidden: false),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:01 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:01 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl  ", time: "12:01 am", timeHidden: false),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:02 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:02 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:03 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdsdfklslkd fklsj kdlfjkaljskldfjalks dkljfklsjdfjlksjkfl ", time: "12:03 am", timeHidden: false),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
        TestForm(name:"my", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
        TestForm(name:"you", msg: "sdjfjijl fjdlj iljf slijlilji ", time: "12:04 am", timeHidden: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.senderReuseId)
        //self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.receiverReuseId)
        self.tableView.register(UINib(nibName: "ChatMyBubble", bundle: nil), forCellReuseIdentifier: ChatMyBubble.cell_id)
        self.tableView.register(UINib(nibName: "ChatYourBubble", bundle: nil), forCellReuseIdentifier: ChatYourBubble.cell_id)
        
        self.textView.text = ""
        self.textingAreaView.layer.addBorder([UIRectEdge.top], color: .blue_chat_bubble, width: 1)
        self.textingAreaView.layer.masksToBounds = true
        
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10
    }

}
extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCellIds.senderReuseId, for: indexPath) as? ChatCell {
        let item = testData[indexPath.row]
        if item.name == "my" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChatMyBubble.cell_id, for: indexPath) as? ChatMyBubble {
                
                cell.textView.text = item.msg
                cell.bottomLabel.text = item.time
                //cell.bottomLabel.isHidden = item.timeHidden
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChatYourBubble.cell_id, for: indexPath) as? ChatYourBubble {
                cell.topLabel.text = item.name
                cell.textView.text = item.msg
                cell.bottomLabel.text = item.time
                //cell.bottomLabel.isHidden = item.timeHidden
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
}
