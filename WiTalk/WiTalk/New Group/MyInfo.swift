//
//  MyInfo.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import Foundation

class MyInfo {
    static var shared = MyInfo()
    private init() {
        self.my = Person(name: "", email: "")
    }
    var my:Person
    var roomList = Array<Room>()
    var friendList = Array<Person>()
    
    func infoClear() {
        self.my.name = ""
        self.my.email = ""
        self.my.profileImageUrl = nil
        self.roomList.removeAll()
        self.friendList.removeAll()
    }
}

class Room {
    init(id:String, title:String = "", headCount:Int = 1, imageUrl:String? = nil, newMsg:String? = nil, date:String? = nil) {
        self.id = id
        self.title = title
        self.headCount = headCount
        self.roomImageUrl = imageUrl
        self.roomNewMessage = newMsg
        self.newDate = date
    }
    
    var id:String
    var title:String
    var headCount:Int
    var roomImageUrl:String?
    var roomNewMessage:String?
    var newDate:String?
}

class Person {
    init(name:String,email:String, statusMsg:String = "" , imageUrl:String? = nil) {
        self.name = name
        self.email = email
        self.statusMsg = statusMsg
        self.profileImageUrl = imageUrl
    }
    var name:String
    var email:String
    var statusMsg:String
    var profileImageUrl:String?
}
