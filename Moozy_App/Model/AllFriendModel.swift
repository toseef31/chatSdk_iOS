//
//  AllFriendModel.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 27/09/2022.
//


import Foundation

import SwiftyJSON

class AllFriend_Model : NSObject, Codable {
    
    var status : Int?
    var data : [AllFrind_Data] = []
    var message : String?

    init(fromJson json: JSON!)  {
        
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        
        if userDataJson != JSON.null{
            for msg in userDataJson.arrayValue{
                print(msg)
                data.append(AllFrind_Data(fromJson: msg))
            }
           
        }
        
        message = json["message"].stringValue
        status = json["status"].intValue
       
    }

}


class AllFrind_Data :  NSObject, Codable  {
   
    var _id : String!
    var profile_image : String!
    var onlineStatus : Int!
    var name : String!
    
  
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        _id = json["_id"].stringValue
        name = json["name"].stringValue
        profile_image = json["profile_image"].stringValue
        onlineStatus = json["onlineStatus"].intValue
        

}
}
