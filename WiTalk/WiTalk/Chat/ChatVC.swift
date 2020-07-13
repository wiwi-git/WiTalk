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
    
    var testMsg = [
        "fdsjkfjksdjkfjsdljflkjsdlkjfklsdjfksdf",
        "jfklsdjflksdjkfj klsdj fksdkfjsldjfklsdjkfljdslkfjklsdj lkfjsdlkjfkldsjkfljsdklfjlksdjklfjskl djflksjdklfklsd jklfjsdlk jfklsjdklfjl",
        "skjdfksdkljflksjdf",
        "fdjkjfkldf",
        "abcd"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.senderReuseId)
        self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCellIds.receiverReuseId)
        
        self.textView.text = ""
        self.textingAreaView.layer.borderWidth = 1
    }

}
extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCellIds.senderReuseId, for: indexPath) as? ChatCell {
            cell.textView.text = testMsg[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
}
