//
//  MyInfo.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel:NSObject {
    var name:String?
    var profileImageUrl:String?
    var uid:String?
}

class ChatModel: Mappable {
    public var users :Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
    public var comments :Dictionary<String,Comment> = [:] //채팅방의 대화내용
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    public class Comment :Mappable{
        public var uid : String?
        public var message : String?
        public required init?(map: Map) {
            
        }
        public  func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
        }
    }
    
}

class MyInfo {
    static var shared = MyInfo()
    private init() {
        self.my = Person(uniqueId: "", name: "")
    }
    var my:Person
    var roomList = Array<Room>()
    var friendList = Array<Person>()
    
    func infoClear() {
        self.my.name = ""
        self.my.profileImageUrl = nil
        self.roomList.removeAll()
        self.friendList.removeAll()
    }
}

class Room {
    init(id:String, kind:Int, title:String = "", headCount:Int = 1, imageUrl:String? = nil, newMsg:String? = nil, date:String? = nil) {
        self.id = id
        self.kind = kind
        self.title = title
        self.headCount = headCount
        self.roomImageUrl = imageUrl
        self.roomNewMessage = newMsg
        self.newDate = date
    }
    var id:String
    var kind:Int
    var title:String
    var headCount:Int
    var roomImageUrl:String?
    var roomNewMessage:String?
    var newDate:String?
}

class Person {
    init(uniqueId:String,name:String, imageUrl:String? = nil, statusMsg:String = "") {
        self.uniqueId = uniqueId
        self.name = name
        self.statusMsg = statusMsg
        self.profileImageUrl = imageUrl
    }
    var uniqueId:String
    var name:String
    var statusMsg:String
    var profileImageUrl:String?
}
