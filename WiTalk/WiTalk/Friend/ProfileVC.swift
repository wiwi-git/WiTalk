//
//  ProfileVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/06.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    static let sb_id = "sb_id_profile"
    enum ButtonTag: Int {
        case close = 10
        case chat
        case edit
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    var isEditMode = false
    var userInfo:Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.text = nil
        self.statusTextField.text = nil
        
        closeButton.tag = ButtonTag.close.rawValue
        chatButton.tag = ButtonTag.chat.rawValue
        editButton.tag = ButtonTag.edit.rawValue
        
        closeButton.addTarget(self, action: #selector(pushUpButton(_:)), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(pushUpButton(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(pushUpButton(_:)), for: .touchUpInside)
        
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.image = UIImage(named: "basic_profile")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isEditMode = false
        self.nameTextField.isEnabled = false
        self.statusTextField.isEnabled = false
        
        if let user = self.userInfo {
            self.nameTextField.text = user.name
            self.statusTextField.text = user.statusMsg
            
            if user.profileImageUrl != nil {
                //profileImageView.image
            }
        }
    }
    
    @objc func pushUpButton(_ button:UIButton) {
        if let selected = ButtonTag(rawValue: button.tag) {
            switch selected {
            case .close: self.dismiss(animated: false, completion: nil)
            case .chat: self.chatButtonAction()
            case .edit: self.editButtonAction()
            }
        }
    }
    
    func chatButtonAction() {
        
    }
    
    func editButtonAction() {
        self.isEditMode = !self.isEditMode
        if isEditMode {
            
        } else {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
