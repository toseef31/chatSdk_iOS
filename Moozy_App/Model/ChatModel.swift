//
//  ChatModel.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 19/09/2022.
//

import Foundation
import SwiftyJSON

class chat_Model : NSObject, Codable {
    
    var status : Int?
    var data : [chat_data] = []
    var message : String?

    init(fromJson json: JSON!)  {
        
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        
        if userDataJson != JSON.null{
            
            for msg in userDataJson.arrayValue{
                data.append(chat_data(fromJson: msg))
            }
           
        }
        message = json["message"].stringValue
        status = json["status"].intValue
       
    }

}


class chat_data: NSObject, Codable {
    
    var _id : String!
    var message : String!
    var messageType : Int!
    var chatType : Int!
    var status : Int!
    var seen : Int!
   // var deletedBy : [String]!
//    var bookmarked : [String]!
    var receipt_status : Int!
   // var file_size : String!
    var isread : Int!
    var senderId : SenderId!
    var receiverId : String!
    var projectId : String!
    var repliedTo : RepliedTo!
    var createdAt : String!
   // var reaction : [String]!
    var updatedAt : String!
    var __v : Int!
    var isProgress: Bool!
    
    
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
    
        _id = json["_id"].stringValue
        message = json["message"].stringValue
        messageType = json["messageType"].intValue
        chatType = json["chatType"].intValue
        status = json["status"].intValue
        seen = json["seen"].intValue
        receipt_status = json["receipt_status"].intValue
        isread = json["isread"].intValue
        
        let senderIddataJson = json["senderId"]
        if senderIddataJson != JSON.null{
            senderId = SenderId(fromJson: senderIddataJson)
        }
        
         receiverId = json["receiverId"].stringValue
            projectId = json["projectId"].stringValue
        
        let CommentIdDataJson = json["repliedTo"]
        if CommentIdDataJson != JSON.null {
            repliedTo = RepliedTo(fromJson: CommentIdDataJson)
        }
        
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        __v = json["__v"].intValue
         isProgress = false
      
        
        
    }
}



//Replide TO Model
class RepliedTo : NSObject, Codable{
    var _id : String!
    var message : String!
    var messageType : Int!
    var senderId : Sender_Id!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        _id = json["_id"].stringValue
        message = json["message"].stringValue
        messageType = json["messageType"].intValue
        
        let CommentIdDataJson = json["senderId"]
        if CommentIdDataJson != JSON.null{
            senderId = Sender_Id(fromJson: CommentIdDataJson)
        }

    }
}


    //SenderId...
class Sender_Id : NSObject, Codable{
    var _id : String!
    var profile_image : String!
    var name : String!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        _id = json["_id"].stringValue
        profile_image = json["profile_image"].stringValue
        name = json["name"].stringValue
        
    }
}




