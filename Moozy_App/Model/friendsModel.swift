//
//  friendsModel.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 09/05/2022.
//

import Foundation
import SwiftyJSON

class FrindsModel: NSObject, Codable{
    
    var friend : Friend!
    var lastChat : String!
    var lastchatCounter : Int!
    var messageType: Int!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        let friendDataJson = json["Friend"]
        if friendDataJson != JSON.null{
            friend = Friend(fromJson: friendDataJson)
        }
        
        lastChat = json["lastChat"].stringValue
        messageType = json["messageType"].intValue
        lastchatCounter = json["lastchatCounter"].intValue
    }
}


class UserId : NSObject, Codable{
    
    var name : String!
    var emailConfirm : Int!
    var secretKey : String!
    var _id : String!
    var userTitle : String!
    var readReceipts : String!
    var blockedGroups : [String]!
    var phone : String!
    var pStatus : Int!
    var mutedGroups : [String]!
    var hiddenO2OChatUsers : [String]!
    var ring : String!
    var rememberMe : Int!
    var hiddenUsers : [String]!
    var createdAt : String!
    var userId : String!
    var status : Int!
    var onlineStatus : Int!
    var userProfileUrl : String!
    var fcm_id : String!
    var terms_url : String!
    var seenStatus : Int!
    var favourite : Int!
    var chatWithRefId : String!
    var updatedAt : String!
    var blockedUsers : [String]!
    var isGroup : Int!
    var lastActiveTime : String!
    var token : String!
    var videoCallReceive : String!
    var languageCode : String!
    var ring_id : String!
    var isAdmin : Int!
    var __v : Int!
    var r_read : Int!
    var updatedByMsg : String!
    var clearedUsersGroupChat : [String]!
    var projectId : String!
    var callStatus : Int!
    var gender : String!
    var email : String!
    var hiddenGroups : [String]!
    var hiddenGroupChatUsers : [String]!
    var user_image : String!
    var about_url : String!
    var birth : String!
    var voiceCallReceive : String!
    var mutedUsers : [String]!
    var qr_code : String!
    var country : String!
    var clearedUsersChat : [String]!
    
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        name = json["name"].stringValue
        emailConfirm = json["emailConfirm"].intValue
        secretKey = json["secretKey"].stringValue
        _id = json["_id"].stringValue
        userTitle = json["userTitle"].stringValue
        readReceipts = json["readReceipts"].stringValue
        phone = json["phone"].stringValue
        pStatus = json["pStatus"].intValue
        ring = json["ring"].stringValue
        rememberMe = json["rememberMe"].intValue
        createdAt = json["createdAt"].stringValue
        userId = json["userId"].stringValue
        status = json["status"].intValue
        onlineStatus = json["onlineStatus"].intValue
        userProfileUrl = json["userProfileUrl"].stringValue
        fcm_id = json["fcm_id"].stringValue
        terms_url = json["terms_url"].stringValue
        seenStatus = json["seenStatus"].intValue
        favourite = json["favourite"].intValue
        chatWithRefId = json["chatWithRefId"].stringValue
        updatedAt = json["updatedAt"].stringValue
        isGroup = json["isGroup"].intValue
        lastActiveTime = json["lastActiveTime"].stringValue
        token = json["token"].stringValue
        videoCallReceive = json["videoCallReceive"].stringValue
        languageCode = json["languageCode"].stringValue
        ring_id = json["ring_id"].stringValue
        isAdmin = json["isAdmin"].intValue
        __v = json["__v"].intValue
        r_read = json["r_read"].intValue
        updatedByMsg = json["updatedByMsg"].stringValue
        projectId = json["projectId"].stringValue
        callStatus = json["callStatus"].intValue
        gender = json["gender"].stringValue
        email = json["email"].stringValue
        user_image = json["user_image"].stringValue
        about_url = json["about_url"].stringValue
        birth = json["birth"].stringValue
        voiceCallReceive = json["voiceCallReceive"].stringValue
        qr_code = json["qr_code"].stringValue
        country = json["country"].stringValue
        
        
//        blockedGroups : [String]!
//        mutedGroups : [String]!
//        hiddenO2OChatUsers : [String]!
//        hiddenUsers : [String]!
//        blockedUsers : [String]!
//        clearedUsersGroupChat : [String]!
//        hiddenGroups : [String]!
//        hiddenGroupChatUsers : [String]!
//        mutedUsers : [String]!
//        clearedUsersChat : [String]!
//
    }
    
    
}


class Friend : Codable {
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
    var clearedUsersChat : [String]!
    var clearedUsersGroupChat : [String]!
    var blockedUsers : [String]!
    var blockedGroups : [String]!
    var hiddenUsers : [String]!
    var hiddenGroups : [String]!
    var mutedUsers : [String]!
    var mutedGroups : [String]!
    var hiddenO2OChatUsers : [String]!
    var hiddenGroupChatUsers : [String]!
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
        
        r_read = json["r_read"].intValue
        userId = json["userId"].stringValue
        name = json["name"].stringValue
        gender = json["gender"].stringValue
        email = json["email"].stringValue
        user_image = json["user_image"].stringValue
        phone = json["phone"].stringValue
        birth = json["birth"].stringValue
        country = json["country"].stringValue
        userTitle = json["userTitle"].stringValue
        userProfileUrl = json["userProfileUrl"].stringValue
        onlineStatus = json["onlineStatus"].intValue
        seenStatus = json["seenStatus"].intValue
        readReceipts = json["readReceipts"].intValue
        isAdmin = json["isAdmin"].intValue
        emailConfirm = json["emailConfirm"].intValue
        languageCode = json["languageCode"].stringValue
        status = json["status"].intValue
        pStatus = json["pStatus"].intValue
        isGroup = json["isGroup"].intValue
        lastActiveTime = json["lastActiveTime"].stringValue
        callStatus = json["callStatus"].intValue
        favourite = json["favourite"].intValue
        token = json["token"].stringValue
        fcm_id = json["fcm_id"].stringValue
        rememberMe = json["rememberMe"].intValue
        voiceCallReceive = json["voiceCallReceive"].intValue
        videoCallReceive = json["videoCallReceive"].intValue
        secretKey = json["secretKey"].stringValue
        ring = json["ring"].stringValue
        ring_id = json["ring_id"].stringValue
        r_read = json["r_read"].intValue
        about_url = json["about_url"].stringValue
        terms_url = json["terms_url"].stringValue
        _id = json["_id"].stringValue
        projectId = json["projectId"].stringValue
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        __v = json["__v"].intValue
        
    }

}


class HideUser: NSObject, Codable {
        let _id : String?
        let userId : String?
        let chatWithRefId : String?
        let name : String?
        let gender : String?
        let email : String?
        let user_image : String?
        let phone : String?
        let birth : String?
        let country : String?
        let password : String?
        let userTitle : String?
        let userProfileUrl : String?
        let onlineStatus : Int?
        let seenStatus : Int?
        let readReceipts : Int?
        let isAdmin : Int?
        let emailConfirm : Int?
        let languageCode : String?
        let status : Int?
        let pStatus : Int?
        let isGroup : Int?
        let lastActiveTime : String?
        let callStatus : Int?
        let favourite : Int?
        let token : String?
        let fcm_id : String?
        let rememberMe : Int?
        let voiceCallReceive : Int?
        let videoCallReceive : Int?
        let secretKey : String?
        let qr_code : String?
        let ring : String?
        let ring_id : String?
        let r_read : Int?
        let about_url : String?
        let terms_url : String?
        let clearedUsersChat : [String]?
        let clearedUsersGroupChat : [String]?
        let blockedUsers : [String]?
        let blockedGroups : [String]?
        let hiddenUsers : [String]?
        let hiddenGroups : [String]?
        let mutedUsers : [String]?
        let mutedGroups : [String]?
        let hiddenO2OChatUsers : [String]?
        let hiddenGroupChatUsers : [String]?
        let projectId : String?
        let updatedByMsg : String?
        let createdAt : String?
        let updatedAt : String?
        let __v : Int?
}


//SpesificFriends.

