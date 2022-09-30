//
//  LoginModel.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 16/09/2022.
//

import Foundation
import SwiftyJSON

class LogIn : NSObject, Codable {
    
    
    var status : Int!
    var token : String!
    var data : LogInModel!
    var message : String!

    init(fromJson json: JSON!)  {
        
        if json == nil{
            return
        }
        let userDataJson = json["data"]
        if userDataJson != JSON.null{
            if  userDataJson == [] {
                print("emput")
            } else {
                data = LogInModel(fromJson: userDataJson.first!.1)
            }
           
        }
        message = json["message"].stringValue
        status = json["status"].intValue
        token = json["token"].stringValue
       
       
    }

}


class LogInModel : NSObject, Codable {
    
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
        password = json["password"].stringValue
        email = json["email"].stringValue
        projectId = json["projectId"].stringValue
        createdAt = json["createdAt"].stringValue
         updatedAt = json["updatedAt"].stringValue
        __v =  json["__v"].intValue
        

}
    
    
}
