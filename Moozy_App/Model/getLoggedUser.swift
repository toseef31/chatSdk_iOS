//
//  sp.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 18/07/2022.
//

import Foundation
import SwiftyJSON

class getLogedModel : NSObject, Codable {

    var data : LogedUser!
    var imageFile : String!

      
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        if userDataJson != JSON.null{
            data = LogedUser(fromJson: userDataJson)
        }
        imageFile = json["imageFile"].stringValue
        
    }
}

class LogedUser : NSObject, Codable {

    var userId : String!
    var chatWithRefId : String!
    var name : String!
    var gender : String!
    var email : String!
    var user_image : String!
    var phone : String!
    var birth : String!
    var country : String!
    var userTitle : String!
    var userProfileUrl : String!
    var onlineStatus : Int!
    var seenStatus : Int!
    var readReceipts : Int!
    var isAdmin : Int!
    var emailConfirm : Int!
    var languageCode : String!
    var status : Int!
    var pStatus : Int!
    var isGroup : Int!
    var lastActiveTime : String!
    var callStatus : Int!
    var favourite : Int!
    var token : String!
    var fcm_id : String!
    var rememberMe : Int!
    var voiceCallReceive : Int!
    var videoCallReceive : Int!
    var secretKey : String!
    var qr_code : String!
    var ring : String!
    var ring_id : String!
    var r_read : Int!
    var about_url : String!
    var terms_url : String!
    var clearedUsersChat : [String] = []
    var clearedUsersGroupChat : [String] = []
    var blockedUsers : [String] = []
    var blockedGroups : [String] = []
    var hiddenUsers : [String] = []
    var hiddenGroups : [String] = []
    var mutedUsers : [String] = []
    var mutedGroups : [String] = []
    var hiddenO2OChatUsers : [String] = []
    var hiddenGroupChatUsers : [String] = []
    var _id : String!
    var projectId : String!
    var updatedByMsg : String!
    var createdAt : String!
    var updatedAt : String!
    var __v : Int!

    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
     userId = json["userId"].string
     chatWithRefId = json["chatWithRefId"].string
     name = json["name"].string
     gender = json["gender"].string
     email =  json["email"].string
     user_image = json["user_image"].string
     phone = json["phone"].string
     birth = json["birth"].string
     country = json["country"].string
     userTitle = json["userTitle"].string
     userProfileUrl = json["userProfileUrl"].string
        
     onlineStatus = json["onlineStatus"].intValue
     seenStatus = json["seenStatus"].intValue
     readReceipts = json["readReceipts"].intValue
     isAdmin =  json["isAdmin"].intValue
     emailConfirm = json["emailConfirm"].intValue
     languageCode = json["languageCode"].string
     status = json["status"].intValue
     pStatus = json["pStatus"].intValue
     isGroup = json["isGroup"].intValue
     lastActiveTime = json["lastActiveTime"].string
     callStatus =  json["callStatus"].intValue
     favourite = json["favourite"].intValue
     token = json["token"].string
     fcm_id = json["fcm_id"].string
     rememberMe = json["rememberMe"].intValue
     voiceCallReceive = json["voiceCallReceive"].intValue
     videoCallReceive = json["videoCallReceive"].intValue
     secretKey = json["secretKey"].string
     qr_code = json["qr_code"].string
     ring = json["ring"].string
     ring_id = json["ring_id"].string
     r_read = json["r_read"].intValue
     about_url = json["about_url"].string
     terms_url = json["terms_url"].string
        
        let contactsArray = json["clearedUsersChat"].arrayValue
        for contactsJson in contactsArray {
            clearedUsersChat.append(contactsJson.rawValue as! String)
        }
        //clearuserGroupchat
        let clearedUsersGC = json["clearedUsersGroupChat"].arrayValue
        for contactsJson in clearedUsersGC {
            if contactsJson.count >= 1 {
                
            clearedUsersGroupChat.append(contactsJson.rawValue as! String)
            }
            else {
                
            }
        }
        //blockedUser
        let blockedUser = json["blockedUsers"].arrayValue
        for contactsJson in blockedUser {
            blockedUsers.append(contactsJson.rawValue as! String)
        }
        //BlockedGroup
        let blockedGrp = json["blockedGroups"].arrayValue
        for contactsJson in blockedGrp {
            blockedGroups.append(contactsJson.rawValue as! String)
        }
        //BlockedGroup
        let hiddenUser = json["hiddenUsers"].arrayValue
        for contactsJson in hiddenUser {
            hiddenUsers.append(contactsJson.rawValue as! String)
        }
        //Hidden Groups
        let hiddenGroup = json["hiddenGroups"].arrayValue
        for contactsJson in hiddenGroup {
            hiddenGroups.append(contactsJson.rawValue as! String)
        }
        //mutedUsers
        let contactsArraye = json["mutedUsers"].arrayValue
        for contactsJson in contactsArraye {
             mutedUsers.append(contactsJson.rawValue as! String)
        }
        //mutedGroups
        let mutedGroup = json["mutedGroups"].arrayValue
        for contactsJson in mutedGroup {
            mutedGroups.append(contactsJson.rawValue as! String)
        }
        //hiddenO2OChatUsers
        let hiddenO2OChatUser = json["hiddenO2OChatUsers"].arrayValue
        for contactsJson in hiddenO2OChatUser {
            hiddenO2OChatUsers.append(contactsJson.rawValue as! String)
        }
        //hiddenGroupChatUsers
        let hiddenGroupChatUser = json["hiddenGroupChatUsers"].arrayValue
        for contactsJson in hiddenGroupChatUser {
            hiddenGroupChatUsers.append(contactsJson.rawValue as! String)
        }
    
        _id = json["_id"].string
     projectId = json["projectId"].string
     updatedByMsg = json["updatedByMsg"].string
     createdAt = json["createdAt"].string
     updatedAt = json["updatedAt"].string
     __v = json["__v"].intValue
    }
}




//userCleard chAT
    
    class Contact: Codable{

        var assistantName : String!
         /**
         * Instantiate the instance using the passed json values to set the properties values
         */
        init(fromJson json: JSON!){
            if json == nil{
                return
            }
            assistantName = json["AssistantName"].stringValue
           
        }
        
        enum CodingKeys: String, CodingKey{
            case assistantName
           
    //        case attributes
        }
    }
