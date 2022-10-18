////
////  allChatUserModel.swift
////  Moozy_App
////
////  Created by Ali Abdullah on 29/04/2022.
////
//
import Foundation
import SwiftyJSON

class SenderId : NSObject, Codable{
    var _id : String!
    var name : String!
    var user_image : String!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        _id = json["_id"].stringValue
        name = json["name"].stringValue
        user_image = json["user_image"].stringValue

    }
}
//
class ReceiverId : NSObject, Codable{
    var _id : String!
    var name : String!
    var user_image : String!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        _id = json["_id"].stringValue
        name = json["name"].stringValue
        user_image = json["user_image"].stringValue

    }
}

struct MessageResponseData: Decodable{
    var msgData: chat_data!
}
struct MessageRe: Decodable{
   var  senderId : String!
    var name : String!
    var receiverId : String!
}
struct userOnlineStatus : Decodable{
    var status : Int!
    var userId : String!
}
struct UpdateMessage: Decodable{
   var  senderId : String!
    var createdAT : String!
    var receiver_id : String!
    var message : String!
    var messageId : String!

}
//

struct MessageResonse: Decodable{
    var msgData: msgData?
    var selectedUserData: String?
    var userId: String?
}

struct msgData: Decodable{
    var bookmarkedChat: String?
    var chatType: Int?
    var commentId: String?
    var createdAt: String?
    var isGroup: Int?
    var message: String?
    var messageType: Int?
    var receiptStatus: Int?
    var receiverId: String?
    var receiverImage : String?
    var senderId: String?
    var senderImage : String?
    var senderName : String?
}
//
//
class chatModelss: NSObject, Codable{

    var message : String!
    var messageType : Int!
    var chatType : Int!
    var status : Int!
    var isSeen : Int!
    var isDevared : Int!
    var isGroup : Int!
    var bookmarked : Int!
    var receiptStatus : Int!
    var hide : Int!
    var _id : String!
    var senderId: String!
    var receiverId: String!
    var commentId: String!
    var projectId : String!
    var createdAt : String!
    var updatedAt : String!
    var isDeleted : Int!
    var __v : Int!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }

        commentId = json["commentId"].stringValue
        message = json["message"].stringValue
        messageType = json["messageType"].intValue
        chatType = json["chatType"].intValue
        status = json["status"].intValue
        isSeen = json["isSeen"].intValue
        isDevared = json["isDevared"].intValue
        isGroup = json["isGroup"].intValue
        bookmarked = json["bookmarked"].intValue
        receiptStatus = json["receiptStatus"].intValue
        hide = json["hide"].intValue
        _id = json["_id"].stringValue
        projectId = json["projectId"].stringValue
        senderId = json["senderId"].stringValue
        receiverId = json["receiverId"].stringValue
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        isDeleted = json["isDeleted"].intValue
        __v = json["__v"].intValue
    }
}
