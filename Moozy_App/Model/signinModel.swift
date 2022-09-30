//
//  signinModel.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 29/04/2022.
//

import Foundation
import SwiftyJSON

class SigninModel : NSObject, Codable{

    var user : User!
    var code: Int!
    var userRings : String!
    var flag: Bool!
    var message: String!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        let userDataJson = json["user"]
        if userDataJson != JSON.null{
            user = User(fromJson: userDataJson)
        }
        code = json["code"].intValue
        userRings = json["userRings"].stringValue
        message = json["message"].stringValue
        flag = json["flag"].boolValue
    }
}

class User : NSObject, Codable{

    var userProfileUrl: String!
    var userId: String!
    var r_read: Int!
    var isAdmin: Int!
    var pStatus: Int!
    var birth : String!
    var _id : String!
    var p_image : String!
    var languageCode : String!
    var ring : String!
    var deviceType : String!
    var videoCallReceive : Int!
    var ring_user_id : String!
    var cryptedHexKey : String!
    var secretKey : String!
    var terms_url : String!
    var status : Int!
    var password : String!
    var about_url : String!
    var country : String!
    var notification : Int!
    var fcm_id : String!
    var qr_code : String!
    var emailConfirm : Int!
    var __v : Int!
    var user_image : String!
    var voip_id : String!
    var user_name : String!
    var voiceCallReceive : Int!
    var ring_id : String!
    var gender : String!
    var readReceipts : Int!
    var userTitle : String!
    var callStatus : Int!
    var lastActiveTime : String!
    var ring_name : String!
    var updatedByMsg : String!
    var name : String!
    var loggedIn : Int!
    var createdAt : String!
    var isGroup : Int!
    var token : String!
    var seenStatus : Int!
    var onlineStatus : Int!
    var projectId : String!
    var email : String!
    var phone : String!
    var emailRechecked : Int!
    var chatWithRefId : String!
    var updatedAt : String!
    
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        userProfileUrl = json["userProfileUrl"].stringValue
        userId = json["userId"].stringValue
        r_read = json["r_read"].intValue
        isAdmin = json["isAdmin"].intValue
        pStatus = json["pStatus"].intValue
        birth = json["birth"].stringValue
        _id = json["_id"].stringValue
        p_image = json["p_image"].stringValue
        languageCode = json["languageCode"].stringValue
        ring = json["ring"].stringValue
        deviceType = json["deviceType"].stringValue
        videoCallReceive = json["videoCallReceive"].intValue
        ring_user_id = json["ring_user_id"].stringValue
        cryptedHexKey = json["cryptedHexKey"].stringValue
        secretKey = json["secretKey"].stringValue
        terms_url = json["terms_url"].stringValue
        status = json["status"].intValue
        password = json["password"].stringValue
        about_url = json["about_url"].stringValue
        country = json["country"].stringValue
        notification = json["notification"].intValue
        fcm_id = json["fcm_id"].stringValue
        qr_code = json["qr_code"].stringValue
        emailConfirm = json["emailConfirm"].intValue
        __v = json["__v"].intValue
        user_image = json["user_image"].stringValue
        voip_id = json["voip_id"].stringValue
        user_name = json["user_name"].stringValue
        voiceCallReceive = json["voiceCallReceive"].intValue
        ring_id = json["ring_id"].stringValue
        gender = json["gender"].stringValue
        readReceipts = json["readReceipts"].intValue
        userTitle = json["userTitle"].stringValue
        callStatus = json["callStatus"].intValue
        lastActiveTime = json["lastActiveTime"].stringValue
        ring_name = json["ring_name"].stringValue
        updatedByMsg = json["updatedByMsg"].stringValue
        name = json["name"].stringValue
        loggedIn = json["loggedIn"].intValue
        createdAt = json["createdAt"].stringValue
        isGroup = json["isGroup"].intValue
        token = json["token"].stringValue
        seenStatus = json["seenStatus"].intValue
        onlineStatus = json["onlineStatus"].intValue
        projectId = json["projectId"].stringValue
        email = json["email"].stringValue
        phone = json["phone"].stringValue
        emailRechecked = json["emailRechecked"].intValue
        chatWithRefId = json["chatWithRefId"].stringValue
        updatedAt = json["updatedAt"].stringValue
    }
}



//Mo0zy_App_Model


class loginModel : NSObject, Codable{
    
    var data : loginData!
    var imageFile : String!
    var isUserExist : Bool!
    var message: String!
    

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        let dataJson = json["data"]
        if dataJson != JSON.null{
            data = loginData(fromJson: dataJson)
        }
        
        imageFile = json["imageFile"].stringValue
        isUserExist = json["isUserExist"].boolValue
        message = json["message"].stringValue
    }
}


class loginData : NSObject, Codable{
    
    var id : String!
    var email : String!
    var name : String!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        id = json["id"].stringValue
        email = json["email"].stringValue
        name = json["name"].stringValue
        
    
    }
}


//Sql database

class Users{
    var name: String = ""
    var createdAt: String = ""
    var onlineStatus: Int = 0
    var seenStatus: Int = 0
    var userId: String = ""
    var user_image: String = ""
}


class AllUsers{
    var image: String = ""
    var isOnline: Int = 0
    var usCount: Int = 0
    var sender_id: String = ""
    var _id: Int = 0
    var receiver_id = ""
    var name: String = ""
    var createdAt: String = ""
    var onlineStatus: Int = 0
    var seenStatus: Int = 0
    var userId: String = ""
    var user_image: String = ""
}

class Messages{
    var receiver_id: String = ""
    var messageType: String = ""
    var createdAt: String = ""
    var isSeen: Int = 0
    var message: String = ""
    var _id: Int = 0
    var sender_id: String = ""
    var name: String = ""
    var onlineStatus: Int = 0
    var seenStatus: Int = 0
    var userId: String = ""
    var user_image: String = ""
    var isIncoming: Int = 0
}



//Sign Up Model

class SignUpModel : NSObject, Codable {
    
    var message : String!
    var status : Int!
    var data : SignUP!
    var token : String!

    init(from json: JSON!)  {
        
      
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        if userDataJson != JSON.null{
            data = SignUP(fromJson: userDataJson)
        }
        message = json["message"].stringValue
        status = json["status"].intValue
        token = json["token"].stringValue
       
       
    }

}


class SignUP : NSObject, Codable {
    
    var deactivateAccount : Int!
    var deleteAccount : Int!
    var language : String!
    var outsideUser : Int!
    var profile_image : String!
    var workPhoneNumber : String!
    var mobileNumber : String!
    var companyName : String!
    var country : String!
    var city : String!
    var emailConfirm : Int!
    var timeZone : String!
    var onlineStatus : Int!
    var _id : String!
    var chattoId : String!
    var name : String!
    var birthday : String!
    var email : String!
    var password : String!
    var projectId : String!
    var createdAt : String!
    var updatedAt : String!
    var __v : Int!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        deactivateAccount = json["deactivateAccount"].intValue
        deleteAccount = json["deleteAccount"].intValue
        language = json["language"].stringValue
        outsideUser = json["outsideUser"].intValue
        profile_image = json["profile_image"].stringValue
        workPhoneNumber = json["workPhoneNumber"].stringValue
        _id = json["_id"].stringValue
        mobileNumber = json["mobileNumber"].stringValue
        companyName = json["companyName"].stringValue
        country = json["country"].stringValue
        city = json["city"].stringValue
        emailConfirm = json["emailConfirm"].intValue
        timeZone = json["timeZone"].stringValue
        onlineStatus = json["onlineStatus"].intValue
        chattoId = json["chattoId"].stringValue
        name = json["name"].stringValue
        birthday = json["birthday"].stringValue
        password = json["password"].stringValue
        email = json["email"].stringValue
        country = json["country"].stringValue
        projectId = json["projectId"].stringValue
        createdAt = json["createdAt"].stringValue
         updatedAt = json["updatedAt"].stringValue
        __v =  json[__v].intValue
        

}
    
    
}
