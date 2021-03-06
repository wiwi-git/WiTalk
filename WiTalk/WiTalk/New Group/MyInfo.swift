//
//  MyInfo.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import Foundation
import ObjectMapper

class UserDefaultsKey:NSObject {
    static let isDeactivateTouchID:String = "key_isDeactivateTouchId"
}

class UserModel:NSObject {
    var name:String?
    var profileImageUrl:String?
    var uid:String?
    var pushToken:String?
    var status:String?
}

class ChatModel: Mappable {
    public var users :Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
    public var comments :Dictionary<String,Comment> = [:] //채팅방의 대화내용
    public var data = Data()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
        data <- map["data"]
    }
    
    public class Comment :Mappable{
        public var uid : String?
        public var message : String?
        public var timestamp : Int?
        
        init() {
            
        }
        public required init?(map: Map) {
            
        }
        public  func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
            timestamp <- map["timestamp"]
        }
    }
    
    class Data : Mappable {
        init() { }
        
        required init?(map: Map) { }
        
        var title : String?
        var text : String?
        
        func mapping(map: Map) {
            title <- map["title"]
            text <- map["text"]
            
        }
    }
    
}


