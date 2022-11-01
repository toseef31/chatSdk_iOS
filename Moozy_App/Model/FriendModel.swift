//
//  FriendModel.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 19/09/2022.
//

import Foundation

import SwiftyJSON

class Friend_Model : NSObject, Codable {
    
    var status : Int?
    var data : [Frind_Data] = []
    var message : String?

    init(fromJson json: JSON!)  {
        
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        
        if userDataJson != JSON.null{
            for msg in userDataJson.arrayValue{
                print(msg)
                data.append(Frind_Data(fromJson: msg))
            }
           
        }
        
        message = json["message"].stringValue
        status = json["status"].intValue
       
    }

}


class Frind_Data :  NSObject, Codable  {
    
    var message : String!
    var messageType : Int!
    var unread : Int!
    var createdAt : String!
    var messageCounter : Int!
    var _id : String!
    var name : String!
    var profile_image : String!
    var onlineStatus : Int!
    var ismute : Int!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        
        message = json["message"].stringValue
        messageType = json["messageType"].intValue
        unread = json["unread"].intValue
        createdAt = json["createdAt"].stringValue
        messageCounter = json["messageCounter"].intValue
        _id = json["_id"].stringValue
        name = json["name"].stringValue
        profile_image = json["profile_image"].stringValue
        onlineStatus = json["onlineStatus"].intValue
        ismute = json["ismute"].intValue
      
}
}
