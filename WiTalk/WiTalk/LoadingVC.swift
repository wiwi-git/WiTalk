//
//  LoadingVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    private var loaded = false {
        didSet {
            if loaded { showMainPage() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(2)
        inputTestInfo()
        self.loaded = true
    }
    
    func inputTestInfo() {
        let my = MyInfo.shared
        //내정보
        my.my.name = "위대연"
        my.my.email = "wiwi@wiwi.website"
        my.my.profileImageUrl = nil
        my.my.statusMsg = "자살마렵다."
        
        //친구정보
        var friendList = Array<Person>()
        for i in 0 ... 9 {
            friendList.append(Person(name: "김\(i)돌", email: "email@wiwi.website", statusMsg: "\(i) \(i) 하다", imageUrl: nil))
        }
        my.friendList = friendList
        
        
        var roomList = Array<Room>()
        for i in 0 ... 9 {
            roomList.append(Room(id: "\(i)", title: "chat\(i)방", headCount: i, imageUrl: nil, newMsg: "new - sjfkjkldjslkfjdkslj    dd", date: "am 10:11"))
        }
        my.roomList = roomList
        
    }

    func showMainPage() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sb_tabbarcontroller") {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}
