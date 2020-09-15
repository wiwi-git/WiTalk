//
//  MyPageViewController.swift
//  WiTalk
//
//  Created by 위대연 on 2020/09/15.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyPageViewController: UIViewController {
    @IBOutlet weak var logoutButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoutButton.layer.borderWidth = 1
        self.logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        self.logoutButton.layer.cornerRadius = 20
        self.logoutButton.layer.masksToBounds = true
        self.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch let err {
            print("err \(err.localizedDescription)")
        }
    }
}
