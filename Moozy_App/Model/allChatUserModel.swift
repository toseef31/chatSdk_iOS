//
//  allChatUserModel.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 29/04/2022.
//

import Foundation
import SwiftyJSON


class AllChatUserModel : NSObject, Codable{
    
    var _id : String!
    var user_name : String!
    var qr_ring : String!
    var p_image : String!
    var ring_name : String!
    var ring_user_id : String!
    var ring_value : String!
    var is_default : Int!
    var ring_status : Int!
    var online_status : Int!
    var pStatus : Int!
    var callStatus : Int!
    var isGroup : Int!
    var seenStatus : Int!
    var readReceipts : Int!
    var lastActiveTime : String!
    var chatWithRefId : String!
    var onlineHideStatus : String!
    var stopAudioCall : String!
    var stopVideoCall : String!
    var user_id : String!
    var updatedByMsg : String!
    var friendReqId : String!
    var friendReqStatus : Int!
    var friendReqSenderId : String!
    var usCount : Int!
    var isSeenCount : Int!
    var latestMsg : LatestMsg!
    var mute : String!
    var hide : String!
    var block : String!
    var hideChat : String!
    var unreadUserStatus : String!
    var pinStatus : Int!
    var hiddenChat : Int!
    var selectedRingId : String!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        _id = json["_id"].stringValue
        user_name = json["user_name"].stringValue
        qr_ring = json["qr_ring"].stringValue
        p_image = json["p_image"].stringValue
        ring_name = json["ring_name"].stringValue
        
        ring_user_id = json["ring_user_id"].stringValue
        ring_value = json["ring_value"].stringValue
        is_default = json["is_default"].intValue
        ring_status = json["ring_status"].intValue
        online_status = json["online_status"].intValue
        pStatus = json["pStatus"].intValue
        callStatus = json["callStatus"].intValue
        isGroup = json["isGroup"].intValue
        seenStatus = json["readReceipts"].intValue
        readReceipts = json["readReceipts"].intValue
        lastActiveTime = json["lastActiveTime"].stringValue
        chatWithRefId = json["chatWithRefId"].stringValue
        onlineHideStatus = json["onlineHideStatus"].stringValue
        stopAudioCall = json["stopAudioCall"].stringValue
        stopVideoCall = json["stopVideoCall"].stringValue
        user_id = json["user_id"].stringValue
        updatedByMsg = json["updatedByMsg"].stringValue
        friendReqId = json["friendReqId"].stringValue
        friendReqStatus = json["friendReqStatus"].intValue
        friendReqSenderId = json["friendReqSenderId"].stringValue
        usCount = json["usCount"].intValue
        isSeenCount = json["isSeenCount"].intValue
        mute = json["mute"].stringValue
        hide = json["hide"].stringValue
        block = json["block"].stringValue
        hideChat = json["hideChat"].stringValue
        unreadUserStatus = json["unreadUserStatus"].stringValue
        pinStatus = json["pinStatus"].intValue
        hiddenChat = json["hiddenChat"].intValue
        selectedRingId = json["selectedRingId"].stringValue
        
        var resultJson = json["latestMsg"]
        if resultJson != JSON.null{
            latestMsg = LatestMsg(fromJson: resultJson)
        }
    }
}


class LatestMsg : NSObject, Codable{
    
    var _id : String!
    var message : String!
    var reactionMessage : String!
    var messageType : Int!
    var chatType : Int!
    var status : Int!
    var isSeen : Int!
    var isDevared : Int!
    
    var devaredBy : [String]!
    var singleMsgDevaredBy : [String]!
    var groupChatunReadList : [String]!
    
    var isGroup : Int!
    var bookmarked : Int!
    var reactionStatus : Int!
    var receiptStatus : Int!
    
    var fileSize : String!
    
    var isSeenCount : Int!
    var hide : Int!
    
    var reaction : [String]!
    
    var senderId : String!
    var receiverId : String!
    var projectId : String!
    var senderUserId : String!
    var receiverUserId : String!
    var createdAt : String!
    var updatedAt : String!
    var __v : Int!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        _id = json["_id"].stringValue
        message = json["message"].stringValue
        reactionMessage = json["reactionMessage"].stringValue
        messageType = json["messageType"].intValue
        chatType = json["chatType"].intValue
        status = json["status"].intValue
        isSeen = json["isSeen"].intValue
        isDevared = json["isDevared"].intValue
        
        isGroup = json["isGroup"].intValue
        bookmarked = json["bookmarked"].intValue
        reactionStatus = json["reactionStatus"].intValue
        receiptStatus = json["receiptStatus"].intValue
        
        fileSize = json["fileSize"].stringValue
        
        isSeenCount = json["isSeenCount"].intValue
        hide = json["hide"].intValue
        senderId = json["senderId"].stringValue
        receiverId = json["receiverId"].stringValue
        projectId = json["projectId"].stringValue
        senderUserId = json["senderUserId"].stringValue
        receiverUserId = json["receiverUserId"].stringValue
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        
        __v = json["__v"].intValue
        
    }
}

//TypingModel

//TypingResponse(selectFrienddata: Moozy_App.selectFrienddata(_id: "6285e4169db905bc38592c49", chatWithRefId: nil, latestMsg: nil), UserId: "6285e3f29db905bc38592c48"))

struct TypingResponse :Decodable{
    var selectFrienddata:selectFrienddata
    var UserId:String
}

struct selectFrienddata:Decodable {
    var _id:String
    var chatWithRefId : String!
    var latestMsg:latestMsg!
}

struct latestMsg:Codable {
    var _id: String
    var message : String
    var isDevared:Int!
    var senderId: String!
    var receiverId: String!
    var messageType :Int!
    var createdAt: String!
}

struct SelectionResponse:Decodable {
    var selectedUser:String
    var userId:String
}

//Context(codingPath: [_JSONKey(stringValue: "Index 0", intValue: 0), CodingKeys(stringValue: "msgData", intValue: nil), CodingKeys(stringValue: "senderId", intValue: nil)], debugDescription: "Expected to decode Dictionary<String, Any> but found a string/data instead.", underlyingError: nil))

class chatModel: NSObject, Codable{
    
    var message : String!
    var messageType : Int!
    var chatType : Int!
    var status : Int!
    var isSeen : Int!
    var isDevared : Int!
    var isGroup : Int!
    var bookmarked : Int!
//    var bookmarkedChat : [String]!
    var receiptStatus : Int!
    var hide : Int!
    var _id : String!
//    var senderId: String!
//    var receiverId: String!
    var senderId : SenderId!
    var receiverId : ReceiverId!
    var commentId: CommentId!
    var projectId : String!
    var createdAt : String!
    var updatedAt : String!
    var isDeleted : Int!
//    var deletedBy : [String]!
    var __v : Int!
//    bookmarkedChat
    var uploadedProgress: Double!
    var isProgress: Bool!
    var isSend: Int!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        let senderIddataJson = json["senderId"]
        if senderIddataJson != JSON.null{
            senderId = SenderId(fromJson: senderIddataJson)
        }
        
        let receiverIdDataJson = json["receiverId"]
        if receiverIdDataJson != JSON.null{
            receiverId = ReceiverId(fromJson: receiverIdDataJson)
        }
        
        let CommentIdDataJson = json["commentId"]
        if CommentIdDataJson != JSON.null{
            commentId = CommentId(fromJson: CommentIdDataJson)
        }
        
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
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        isDeleted = json["isDeleted"].intValue
        __v = json["__v"].intValue
    }
}

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


class CommentId: NSObject, Codable{
  
    var message : String!
    var _id : String!
    var messageType : Int!
    var chatType : Int!
    var status : Int!
    var isSeen : Int!
    var isDeleted : Int!
    var deletedBy : [String]!
    var isGroup : Int!
    var bookmarked : Int!
    var bookmarkedChat : [String]!
    var receiptStatus : Int!
    var hide : Int!
   
    var senderId : SenderId!
    var receiverId : String!
    var projectId : String!
    var createdAt : String!
    var updatedAt : String!
    var __v : Int!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        let senderIdDataJson = json["senderId"]
        if senderIdDataJson != JSON.null{
            senderId = SenderId(fromJson: senderIdDataJson)
        }
            message = json["message"].stringValue
            _id = json["_id"].stringValue
            messageType = json["messageType"].intValue
            chatType = json["chatType"].intValue
            status = json["status"].intValue
            isSeen = json["isSeen"].intValue
            isDeleted = json["isDeleted"].intValue
            isGroup = json["isGroup"].intValue
            bookmarked = json["bookmarked"].intValue
            receiptStatus = json["receiptStatus"].intValue
            hide = json["hide"].intValue
          
            receiverId = json["receiverId"].stringValue
            projectId = json["projectId"].stringValue
            createdAt = json["createdAt"].stringValue
            updatedAt = json["updatedAt"].stringValue
            __v = json["__v"].intValue
    }
}




class  MessageCount{
    var status : Int!
    var msgCount : Int!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        status = json["status"].intValue
        msgCount = json["msgCount"].intValue
    }
}

struct ChatMessageModel{
    var _id: Int?
    var user_id: String?
    var frind_id: String?
    var message: String?
    var message_Type: Int?
    var status: Int?
    var isSeen: Int?
    var isDevared: Int?
    var receiptStatus: Int?
    var createdDate: String?
    var hide: Int?
    var sender_id: String?
    var sender_name: String?
    var sender_image: String?
    var receiver_id: String?
    var receiver_name: String?
    var receiver_image: String?
}

struct MessageResponseData: Decodable{
    var msgData: chat_data!
//    var userId:String!
//    var selectFrienddata:String!
}
struct MessageRe: Decodable{
   var  sender_id : String!
    var name : String!
    var receiver_id : String!
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
//        let senderIddataJson = json["senderId"]
//        if senderIddataJson != JSON.null{
//            senderId = SenderId(fromJson: senderIddataJson)
//        }
//
//        let receiverIdDataJson = json["receiverId"]
//        if receiverIdDataJson != JSON.null{
//            receiverId = ReceiverId(fromJson: receiverIdDataJson)
//        }
        
//        let CommentIdDataJson = json["commentId"]
//        if CommentIdDataJson != JSON.null{
//            commentId = CommentId(fromJson: CommentIdDataJson)
//        }
        
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


//File Response Model..

