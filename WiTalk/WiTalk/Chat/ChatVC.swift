//
//  ChatVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/10.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ChatVC: UITableViewController {
    var testMsg = ["fdsjkfjksdjkfjsdljflkjsdlkjfklsdjfksdf","jfklsdjflksdjkfjklsdjfksdkfjsldjfklsdjkfljdslkfjklsdjlkfjsdlkjfkldsjkfljsdklfjlksdjklfjskldjflksjdklfklsdjklfjsdlkjfklsjdklfjl","skjdfksdkljflksjdf","fdjkjfkldf","abcd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.cellId.senderReuseId.rawValue)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testMsg.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellId.senderReuseId.rawValue, for: indexPath) as! ChatCell
        cell.selectionStyle = .none
        cell.textView.text = testMsg[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
