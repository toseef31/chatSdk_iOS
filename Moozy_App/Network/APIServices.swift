//
//  APIServices.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 10/05/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import CoreLocation
import CoreMedia


protocol sendMessageDelegate {
    func sendMessage(messageData: Any)
    func sendTextMessage(messageData: Any )
    func sendAudioMessage(messageData: Any )
}

class APIServices{
    
    static let shared = APIServices()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    var sendDelegate:sendMessageDelegate?
   
    
    //Login User
    func loginUser(email: String, password: String, onCompletion: @escaping onCompletion<LogInModel>){
        AppUtils.shared.saveProjectID(projectID: ConstantStrings.ProjectId)
        let param = [
            "email" : email,
            "password" : password,
            "regToken" : AppUtils.shared.getFCMToken(),
            "deviceType" : "iOS"
        ]
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.login, onComplition: { response, error in
            
            if let result = response {
                print(param)
                print(result)
                let data = LogIn.init(fromJson: result)
                
                if data.status != 0 {
                    onCompletion(data.data, nil)
                }else{
                    onCompletion(nil, data.message)
                }
            }else{
                let data = LogIn.init(fromJson: response)
                onCompletion(nil, data.message)
            }
        })
    }
    
    
    //HideFriend
    func hideFriend (hideUserId: String,hideStatus : Int , onCompletion: @escaping onCompletion<Bool>) {
        let param = [
            "userId": AppUtils.shared.user?._id ?? "",
             "friendId" :  hideUserId,
            "hideStatus" :  "\(Int(hideStatus))",
            
        ]
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.hideUser) { (response, errorMessage) in
            if response != nil{
                onCompletion(true, nil)
            }else{
                onCompletion(nil, "\(errorMessage)")
            }
        }
    }
    
    
   // All_Friends_List
    func getAllFriends(onCompletion: @escaping onCompletion<[Frind_Data]>){
        let seletedUser = AppUtils.shared.user?._id ?? ""
         let url = "\(ServiceURL.getFriends)\(seletedUser)"
        NetworkController.shared.serviceResponseObject(method: .get, serviceName: url) { response, errorMessage in
            if let result = response {
                print(result.first)
                 let dataa = Friend_Model.init(fromJson: result)
                onCompletion(dataa.data, nil)
            }else{
                onCompletion(nil, "\(errorMessage!)")
            }
        }
    }
    //User Online status OFF/ON which is visible to other or not.
    func userOnlineStatus (status: String){
        let param = [
            "userId":  AppUtils.shared.user?._id ?? "",
            "status": status
        ]
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.setLiveStatus) { response, errorMessage in
            if let result = response {
               print("sucess")
            }else{
                print("false")
            }
        }
    }
    
    
  
    func readReciptFriends(friendId: String,onCompletion: @escaping onCompletion<Bool>){
        let param = [
            "userId":  AppUtils.shared.user?._id ?? "",
            "receiverId": friendId,
        ]
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.markUnread) { response, errorMessage in
            if let result = response {
                onCompletion(true, nil)
            }else{
                onCompletion(false, "\(errorMessage!)")
            }
        }
    }
    
    //Get All_User_List
    func getAllUser(onCompletion: @escaping onCompletion<[AllFrind_Data]>){
        let seletedUser = AppUtils.shared.user?._id ?? ""
         let url = "\(ServiceURL.getusers)\(seletedUser)"
        NetworkController.shared.serviceResponseObject(method: .get, serviceName: url) { response, errorMessage in
            if let result = response {
                let dataa = AllFriend_Model.init(fromJson: result)
                onCompletion(dataa.data, nil)
            }else{
                onCompletion(nil, "\(errorMessage!)")
            }
        }
    }
    
    
    //Get_All_user which are Muted , Hidde or Blocked.
    func getFrindOperationList (serviceUrl: String? = "" , onCompletion: @escaping onCompletion<[AllFrind_Data]>){
        NetworkController.shared.serviceResponseObject(method: .get, serviceName: serviceUrl ?? "") { response, errorMessage in
            if let result = response {
                let dataa = AllFriend_Model.init(fromJson: result)
                onCompletion(dataa.data, nil)
            }else{
                onCompletion(nil, "\(errorMessage!)")
            }
        }
    }
    
    
    
    //MARK: GET BookMark Chat.
    func getBookMarkList ( onCompletion: @escaping onCompletion<[chat_data]>){
        let servieUrl = "\(ServiceURL.getBookmarkChat)\(AppUtils.shared.user?._id ?? "")"
        print(servieUrl)
        NetworkController.shared.serviceResponseObject(method: .get, serviceName: servieUrl ) { response, errorMessage in
            if let result = response {
                print(result)
               let Chatdata = chat_Model.init(fromJson: result)
                onCompletion(Chatdata.data, nil)
                
            }else{
                onCompletion(nil, "\(errorMessage!)")
            }
        }
    }
    
    
    //MARK: Set BookMark Chat.
    func bookmarkChat (messageId : String? = "" ,status : String? = "0",userId : String? = "" ,receiverId : String? = "" , onCompletion: @escaping onCompletion<Bool>){
        let param = [
            "status" : "\(status ?? "")",
            "messageId" : "\(messageId ?? "")",
            "userId":  AppUtils.shared.user?._id ?? "",
            "isGroup" : "\("0" )" ,
            "receiverId" :  "\(receiverId ?? "")"
        ]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.bookmarkChat ) { response, errorMessage in
            if let result = response {
                onCompletion(true, nil)
            }else{
                onCompletion(false, "\(errorMessage!)")
            }
        }
    }
    
    
    //Get Chat Of sepesific User.
    func getChat(receiverId: String, limit: Int, chatHideStat: Bool = false, onCompletion: @escaping onCompletion<[chat_data]>){
        let param = [
            "userId":  AppUtils.shared.user?._id ?? "",
            "isGroup": "\(Int(0))",
            "receiverId" :  receiverId
        ]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.getChat) { (response, errorMessage) in
            if let result = response{
                print(result)
               let Chatdata = chat_Model.init(fromJson: result)
                onCompletion(Chatdata.data, nil)
            }else{
                onCompletion(nil, "\(errorMessage)")
            }
        }
    }
    //Delete Spesific sms from chat.
    func deleteSingleChat(messageId: [chat_data] , onCompletion: @escaping onCompletion<Bool>){
        self.utilityQueue.async {
        messageId.forEach { data in
            
            let param = [
                "_id":  data._id ?? "",
                "isGroup": "\(Int(0))",
                "userId" :  AppUtils.shared.user?._id ?? ""
            ]
            print(param)
            NetworkController.shared.serviceResponseObject(method: .post, parameter: param , serviceName: ServiceURL.deleteSingleMsg) { (response, errorMessage) in
                if let result = response{
                      onCompletion(true, nil)
                }else{
                    onCompletion(false, "\(errorMessage)")
                }
            }
        }
            
        }
        
    }
    
    //send Sms to User single or multiple (dumy parameter are used to store locally.)
    func sendMessage(receiver_Id: String, message: String, messageType: Int, chatType: Int, comment_Id: String? = "" , commentData : [chat_data]? = [] , createdAt: String, selectedUserData: String, onCompletion: @escaping onCompletion<chat_data>)   {
       
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.string(from: today)
        let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        let senderIds = [
            "_id" : "\(AppUtils.shared.senderID)",
            "name" : "",
            "user_image" : "",
            
        ]
       
        let RepliedTo = [
            
            "_id" : "\(comment_Id ?? "")" ,
            "message" : commentData?.first?.message ,
            "messageType" : commentData?.first?.messageType  ,
            "chatType" : commentData?.first?.chatType,
            "status" : 0 ,
            "seen" : 0,
            "receipt_status" : 0,
            "isread" : 0,
            "senderId" : senderIds,
            "receiverId" : "\(receiver_Id)",
            "projectId" : AppUtils.shared.projectID,
            "createdAt" : "\(finalDate)",
            "updatedAt" : "\(finalDate)",
            "__v" : 0 ,
            "isProgress" :  false ,
            
        ] as [String : Any]
        
        let bookmark : [String] = [] 
        
    var mydata2 = [
        "_id" : "msgIDLocal" ,
        "message" : "\(message)" ,
        "messageType" : messageType ,
        "chatType" : chatType,
        "status" : 0 ,
        "seen" : 0,
        "receipt_status" : 1,
        "isread" : 0,
        "senderId" : senderIds,
        "receiverId" : "\(receiver_Id)",
        "projectId" : AppUtils.shared.projectID,
        "repliedTo" : RepliedTo,
        "createdAt" : "\(finalDate)",
        "updatedAt" : "\(finalDate)",
        "__v" : 0 ,
        "isProgress" :  false ,
        "bookmarked" : bookmark,
        ] as [String : Any]
        
        
        
        let dummyparameter = [
            "selectedUserData" : "\(selectedUserData)",
            "userId" : AppUtils.shared.senderID,
            "msgData" : mydata2,
        ] as [String : Any]
      
       self.sendDelegate?.sendTextMessage(messageData: dummyparameter)
        
        SocketIOManager.sharedInstance.sendMessage(message: dummyparameter)
        print(message)
        self.utilityQueue.async {
            let key = AppUtils.shared.senderID
            var  ivStr = AppUtils.shared.senderID
            let halfLength = 16 //receiverId.count / 2
            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
            ivStr.insert("-", at: index)
            let result = ivStr.split(separator: "-")
            let iv = String(result[0])
            let s = message
            var encMessage = ""
            do{
                encMessage = try s.aesEncrypt(key: key, iv: iv)
            }catch( let error as NSError ){
                print(error)
            }
            
            var param = [
                "messageType" : messageType ,
                "message" : "\(message)" ,
                "chatType" : chatType,
                "isGroup" : 0 ,
                "projectId" : "\(AppUtils.shared.projectID)",
                "receiverId" : "\(receiver_Id)",
                "userId" : "\(AppUtils.shared.senderID)"
            ] as [String : Any]
           
            if chatType == 1 {
                param.updateValue(commentData?.first?._id ?? "", forKey: "selectedMsgId")
                
            }
         
            NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.sendChat) { response, errorMessage in
                if let data = response {
                     print(data)
                    
                    let dataa = chat_data.init(fromJson: data)
                    
                    let userDataJsons = data["data"]
                    var data : [chat_data] = []
                    if  userDataJsons != JSON.null {
                    for msg in userDataJsons.arrayValue{
                        data.append(chat_data(fromJson: msg))
                    }
                    }
                    mydata2["_id"] = "\(data.first?._id ?? "")"
                    
                    let dummyparameters = [
                        "receiver_id" : "\(selectedUserData)",
                        "createdAT" : "\(data.first?.createdAt ?? "")",
                        "messageId" : "\(data.first?._id ?? "")",
                        "senderId" : AppUtils.shared.user?._id ,
                        "message" : "\(data.first?.message ?? "")"
                    ] as [String : Any]
                   
                      onCompletion(dataa, nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        SocketIOManager.sharedInstance.updateMsg(message: dummyparameters)
                    }
                }else{
                    onCompletion(nil, "Error")
                }
            }
        }
    }
    
    //Forward sms.
    func forwardsendMessage(receiver_Id: String, message: String, messageType: Int, chatType: Int, comment_Id: String? = "" , commentData : [chat_data]? = [] , createdAt: String, selectedUserData: String, onCompletion: @escaping onCompletion<chat_data>)   {
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.string(from: today)
        let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        let senderIds = [
            "_id" : "\(AppUtils.shared.senderID)",
            "name" : "",
            "user_image" : "",
            
        ]
       
        let RepliedTo = [
            
            "_id" : "\(comment_Id ?? "")" ,
            "message" : commentData?.first?.message ,
            "messageType" : commentData?.first?.messageType  ,
            "chatType" : commentData?.first?.chatType,
            "status" : 0 ,
            "seen" : 0,
            "receipt_status" : 0,
            "isread" : 0,
            "senderId" : senderIds,
            "receiverId" : "\(receiver_Id)",
            "projectId" : AppUtils.shared.projectID,
            "createdAt" : "\(finalDate)",
            "updatedAt" : "\(finalDate)",
            "__v" : 0 ,
            "isProgress" :  false ,
            
        ] as [String : Any]
        
      let bookmark = [String]()
        
    var mydata2 = [
        "_id" : "msgIDLocal" ,
        "message" : "\(message)" ,
        "messageType" : messageType ,
        "chatType" : chatType,
        "status" : 0 ,
        "seen" : 0,
        "receipt_status" : 1,
        "isread" : 0,
        "senderId" : senderIds,
        "receiverId" : "\(receiver_Id)",
        "projectId" : AppUtils.shared.projectID,
        "repliedTo" : RepliedTo,
        "createdAt" : "\(finalDate)",
        "updatedAt" : "\(finalDate)",
        "__v" : 0 ,
        "isProgress" :  false ,
        "bookmarked" : bookmark,
        ] as [String : Any]
        
        self.utilityQueue.async {
            let key = AppUtils.shared.senderID
            var  ivStr = AppUtils.shared.senderID
            let halfLength = 16 //receiverId.count / 2
            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
            ivStr.insert("-", at: index)
            let result = ivStr.split(separator: "-")
            let iv = String(result[0])
            let s = message
            var encMessage = ""
            do{
                encMessage = try s.aesEncrypt(key: key, iv: iv)
            }catch( let error as NSError ){
                print(error)
            }
            
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
            let date = dateFormatter.string(from: today)
            let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            
            
            var param = [
                "messageType" : messageType ,
                "message" : "\(message)" ,
                "chatType" : chatType,
                "isGroup" : 0 ,
                "projectId" : "\(AppUtils.shared.projectID)",
                "receiverId" : "\(receiver_Id)",
                "userId" : "\(AppUtils.shared.senderID)"
            ] as [String : Any]
           
            if chatType == 1 {
                param.updateValue(commentData?.first?._id ?? "", forKey: "selectedMsgId")
                
            }
            NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.sendChat) { response, errorMessage in
                if let data = response {
                    print(response)
                    let dataa = chat_data.init(fromJson: data)
                    
                    let userDataJsons = data["data"]
                    var data : [chat_data] = []
                    if  userDataJsons != JSON.null {
                    for msg in userDataJsons.arrayValue{
                        data.append(chat_data(fromJson: msg))
                    }
                    }
                    mydata2["_id"] = "\(data.first?._id ?? "")"
                    
                    let dummyparameters = [
                        "msgData" : mydata2
                    ] as [String : Any]
                    print(dummyparameters)
                      onCompletion(dataa, nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        SocketIOManager.sharedInstance.sendMessage(message: dummyparameters)
                    }
                }else{
                    onCompletion(nil, "Error")
                }
            }
        }
    }
    
    
    
    //Update Text SMS.
    func updateMessage(message_Id: String,receiver_Id: String, message: String, messageType: Int, chatType: Int, comment_Id: String? = "", createdAt: String, selectedUserData: String){

        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.string(from: today)
        let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")

        self.utilityQueue.async {
            let key = AppUtils.shared.senderID
            var  ivStr = AppUtils.shared.senderID
            let halfLength = 16 //receiverId.count / 2
            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
            ivStr.insert("-", at: index)
            let result = ivStr.split(separator: "-")
            let iv = String(result[0])
            let s = message
            var encMessage = ""
            do{
                encMessage = try s.aesEncrypt(key: key, iv: iv)
            }catch( let error as NSError ){
                print(error)
            }

            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
            let date = dateFormatter.string(from: today)
            let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")


            let param = [
                "messageId" : message_Id,
                "message" : "\(message)" ,
                "isGroup" : 0,
                "userId" : "\(AppUtils.shared.senderID)"
            ] as [String : Any]

            NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.updateMsg) { response, errorMessage in
                if let data = response {
                     
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        //SocketIOManager.sharedInstance.sendMessage(message: dummyparameters)
                        let updatesms = [
                            "messageId" : message_Id,
                            "message" : "\(message)" ,
                            "senderId" : "\(AppUtils.shared.senderID)",
                            "receiver_id" : receiver_Id,
                            "createdAT" : createdAt
                        ] as [String : Any]

                        print(updatesms)

                        SocketIOManager.sharedInstance.updateMsg(message: updatesms)
                    }
                }else{
                   
                }
            }
        }
    }

    //Send Files.
    func sendFiles(image: UIImage?, fileName: String? = "", audioData:Data?, videoData:Data? = nil, friendId: String, messageType: Int, receiptStatus: Int, receiverId: String,  onCompletion: @escaping (Bool?, Progress?, Error?)->()){
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.string(from: today)
        let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        let senderIds = [
            "_id" : "\(AppUtils.shared.senderID)",
            "name" : "",
            "user_image" : "",
            
        ]
        let bookmark : [String] = []
        
        let RepliedTo = [
            
            "_id" : "comment_Id" ,
            "message" : fileName ?? "" ,
            "messageType" : messageType  ,
            "chatType" : 0,
            "status" : 0 ,
            "seen" : 0,
            "receipt_status" : 0,
            "isread" : 0,
            "senderId" : senderIds,
            "receiverId" : receiverId,
            "projectId" : AppUtils.shared.projectID,
            "createdAt" : "\(finalDate)",
            "updatedAt" : "\(finalDate)",
            "__v" : 0 ,
            "isProgress" :  false ,
           
            
        ] as [String : Any]
        
      
        
    var mydata2 = [
        "_id" : "msgIDLocal" ,
        "message" : fileName ?? "" ,
        "messageType" : messageType ,
        "chatType" : 0,
        "status" : 0 ,
        "seen" : 0,
        "receipt_status" : 1,
        "isread" : 0,
        "senderId" : senderIds,
        "receiverId" : receiverId,
        //"projectId" : AppUtils.shared.projectID,
        "repliedTo" : RepliedTo,
        "createdAt" : "\(finalDate)",
        "updatedAt" : "\(finalDate)",
        "__v" : 0 ,
        "isProgress" :  false ,
        "bookmarked" : bookmark,
        ] as [String : Any]
        
        
        
        let dummyparameter = [
            "selectedUserData" : receiverId,
            "userId" : AppUtils.shared.senderID,
            "msgData" : mydata2,
        ] as [String : Any]
       print(AppUtils.shared.senderID)
        print(dummyparameter)
        
        if messageType == 6 {
            self.sendDelegate?.sendAudioMessage(messageData: dummyparameter)
        } else {
            self.sendDelegate?.sendMessage(messageData: dummyparameter)
        }
        
        self.utilityQueue.async { [self] in

            let imageData = Data()// = image!.pngData()!

            let key = AppUtils.shared.senderID
            var  ivStr = key
            let halfLength = 16 //receiverId.count / 2
            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
            ivStr.insert("-", at: index)
            let result = ivStr.split(separator: "-")
            let iv = String(result[0])

            let url =  "https://chat.chatto.jp:20000/meeting/sendChat"
            
            var encImage = Data()
            var encAudio = Data()

            var timestamp: TimeInterval!

            timestamp = NSDate().timeIntervalSince1970

            var param: [String: Any]
            
            param = [
                "file" : imageData,
                "userId" : "\(AppUtils.shared.senderID)",
                "receiverId" : "\(friendId)",
                "isGroup" : 0,
                "messageType" : messageType,
                "chatType" : 0,
            ]as [String : Any]
            print(param)
            var dataDecoded : Data = Data()
                do{
                    if messageType == 5{

                    }else if messageType == 6{

                        encAudio = audioData!
                        encAudio = try audioData?.aesEncrypt(key: key, iv: iv) as! Data
                        let fileSize = Double(encAudio.count / 1048576)
                        print("Audio File size1 in MB Audio: ", fileSize , encAudio.count)

                    }else if messageType == 1{

                        print("ImageSend start enc")
                        var mainImage = image!

                         let imageData = image!.jpeg(.medium)
                        encImage = try imageData?.aesEncrypt(key: key, iv: iv) as! Data
                        let fileSize = Double(encImage.count / 1048576) //Convert in to MB
                        print("ImageSend File2 size in MB: ", fileSize, encImage.count)

                    }else{

                    }
                }catch( let error as NSError ){
                    print(error)
                }
            //database
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in param{
                    print(key)
                    print(value)
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

                if messageType == 1{
                    multipartFormData.append(encImage, withName: "file", fileName: "\(fileName!)", mimeType: "image/jpeg")
                    let fileSize = Double(encImage.count / 1048576) //Convert in to MB
                    print("ImageSend File2 size in MB: ", fileSize, encImage.count)

                }else if (messageType == 5){
                   
                    multipartFormData.append(videoData!, withName: "file", fileName: fileName!, mimeType: "\(timestamp!)/mp4")
                }else if (messageType == 6){
                    let fileSize1 = Double(audioData?.count ?? 0 / 1048576) //Convert in to MB
                    print("ImageSend File size in MB1: ", fileSize1, audioData?.count)
                    multipartFormData.append(encAudio, withName: "file", fileName: fileName!, mimeType: "\(timestamp!)/m4a")

                    let fileSize = Double(encAudio.count / 1048576) //Convert in to MB
                    print("ImageSend File size in MB2: ", fileSize, encAudio.count)
                }else if (messageType == 7){
                    if let jpegData = image!.jpegData(compressionQuality: 1.0) {
                        multipartFormData.append(jpegData, withName: "file", fileName: "\(fileName!)", mimeType: "image/jpeg")
                        let fileSize = Double(jpegData.count / 1048576) //Convert in to MB

                        print("ImageSend location File size1 in MB: ", fileSize , jpegData.count)
                    }else{
                        multipartFormData.append(imageData, withName: "file", fileName: "\(fileName!)", mimeType: "image/jpeg")
                    }
                }


            }, to: url, headers: [ConstantStrings.projectid: ConstantStrings.ProjectId]
                             , encodingCompletion: { (result) in

                let fileSize =  Double(encAudio.count / 1048576)  //Convert in to MB

                switch result{

                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("File Uploading Progress: ", progress.fractionCompleted)
                    })
                    upload.responseJSON { response in
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response.description)")
                        let json = JSON(response.data!)
                        
                        
                        onCompletion(true, nil, nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                            if json["data"].exists(){
                                let userDataJsons = json["data"]
                                var data : [chat_data] = []
                                if  userDataJsons != JSON.null {
                                for msg in userDataJsons.arrayValue{
                                    data.append(chat_data(fromJson: msg))
                                }
                                }
                            
                                mydata2["_id"] = "\(data.first?._id ?? "")"
                                mydata2["message"] = "\(data.first?.message ?? "")"
                                mydata2["receiptStatus"] = 1
                                mydata2["isProgress"] = false 
                                if messageType != 6 {
                                    mydata2["receiptStatus"] = 0
                                }
                               }else{
                               print("not found data ")
                            }
                            
                            print(AppUtils.shared.senderID)
                            print(receiverId)
                            //get the id of that file.....
                            
                            let dummyparameter = [
                                "msgData" : mydata2,
                            ] as [String : Any]
                              SocketIOManager.sharedInstance.sendMessage(message: dummyparameter)
                        }
                        }

                    
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                }
            })

        }
    }
    
    
    
func sendFile(receiverId: String ,document: UIDocument?,docName:String,filesurl:URL,isGroup:Bool,receiptStatus:Bool,isSeen:Bool,onCompletion: @escaping (Bool?, Progress?, Error?)->()){
   
    var dataFile = Data()
    let senderId = AppUtils.shared.senderID
    //GlobalVar.userINFO?[0]._id
    let key =  "2eXJiSSZ5uIAeZVs"  // Get_Ring_ID()
    let ivStr = "7Hh3tLJKW3PeWO9d"
    let iv = ivStr
    var encFile = Data()
    
    do{

        print(filesurl)
        dataFile = try Data(contentsOf: filesurl)
        let fileSize = Double(dataFile.count / 1048576) //Convert in to MB
        print("ImageSend File2 size in MB: Afte get  ", fileSize, dataFile.count)
        print("ImageSend start Multipar")
    }catch(let error as NSError){
        print(error.localizedDescription)
    }

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    let createdAt = formatter.string(from: date)

    var arr_temp = [[String  : AnyObject]]()
    
    
    self.utilityQueue.async { [self] in
    let url = "https://chat.chatto.jp:20000/meeting/sendChat"
   
    var parameters: [String: String] = [

       // "file" : "dataFile",
        "projectId" : "\(AppUtils.shared.projectID)",
        "userId" : "\(AppUtils.shared.senderID)",
        "receiverId" : receiverId,
       // "message" : "\(fileName ?? "")",
        "isGroup" : "0",
        "messageType" : "2"

    ]
        

        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.string(from: today)
        let finalDate = date.localToUTC(incomingFormat: "MMM d, yyyy h:mm a", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
       
        
        let senderId = [
            "_id" : "\(AppUtils.shared.senderID)",
            "name" : "",
            "user_image" : "",
            
        ]
        let bookmark : [String] = []
        let RepliedTo = [
            
            "_id" : "comment_Id" ,
            "message" : docName ?? "" ,
            "messageType" : 2  ,
            "chatType" : 0,
            "status" : 0 ,
            "seen" : 0,
            "receipt_status" : 0,
            "isread" : 0,
            "senderId" : senderId ,
            "receiverId" : "632088181ef7ace35eff6ece",
            "projectId" : AppUtils.shared.projectID,
            "createdAt" : "\(finalDate)",
            "updatedAt" : "\(finalDate)",
            "__v" : 0 ,
            "isProgress" :  false ,
            
        ] as [String : Any]
        
      
        
    var mydata2 = [
        "_id" : "msgIDLocal" ,
        "message" : docName ?? "" ,
        "messageType" : 2 ,
        "chatType" : 0,
        "status" : 0 ,
        "seen" : 0,
        "receipt_status" : 0,
        "isread" : 0,
        "senderId" : senderId,
        "receiverId" : receiverId,
        //"projectId" : AppUtils.shared.projectID,
        "repliedTo" : RepliedTo,
        "createdAt" : "\(finalDate)",
        "updatedAt" : "\(finalDate)",
        "__v" : 0 ,
        "isProgress" :  false ,
        "bookmarked" : bookmark,
        ] as [String : Any]
        
        
        
        
        let dummyparameter = [
            "selectedUserData" : receiverId,
            "userId" : AppUtils.shared.senderID,
            "msgData" : mydata2,
        ] as [String : Any]
       
    sendDelegate?.sendAudioMessage(messageData: dummyparameter)

    var encMessage = ""
    var fileData = Data()

    do{

        let fileSize = Double(dataFile.count / 1048576) //Convert in to MB
        print("ImageSend File2 size in MB: ", fileSize, dataFile.count)
        print("ImageSend start Multipar")

        let fileSize2 = Double(fileData.count / 1048576) //Convert in to MB
        print("ImageSend File2 size in MB Enc: ", fileSize2, fileData.count)
        print("ImageSend start Multipar")

    }catch let error as NSError{
        print(error)
        print("ImageSend File2 size in MB Enc Error")
      //  completion(false)
    }
    Alamofire.upload(multipartFormData: { multipartFormData in

        for (key, value) in parameters{
            multipartFormData.append(value.data(using: .utf8)!, withName: key)
        }
        multipartFormData.append(filesurl, withName: "file", fileName: docName, mimeType: "application/pdf")

        }, to: url, headers: ["projectid": "63183b5bb110c06cb4822451"], encodingCompletion: { (result) in
            switch result{

        case .success(let upload, _, _):
            upload.uploadProgress(closure: { (progress) in
                print("File Uploading Progress: ", progress.fractionCompleted)
            })
            upload.responseJSON { response in
                print("the resopnse code is : \(response.response?.statusCode)")
                print("the response is : \(response.description)")
                let json = JSON(response.data!)

                onCompletion(true, nil, nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20){
                    if json["data"].exists(){
                        
                        let userDataJsons = json["data"]
                        var data : [chat_data] = []
                        if  userDataJsons != JSON.null {
                        for msg in userDataJsons.arrayValue{
                            data.append(chat_data(fromJson: msg))
                        }
                        }
                     
                        mydata2["_id"] = "\(data.first?._id ?? "")"
                        mydata2["receiptStatus"] = 0
                        mydata2["isProgress"] = false
                        mydata2["message"] = "\(data.first?.message ?? "")"
                      
                      
                        
                    }else{
                       print("not found data ")
                    }
                    
                    print(AppUtils.shared.senderID)
                    print(receiverId)
                    //get the id of that file.....
                    
                    let dummyparameter = [
                        //"selectedUserData" : receiverId,
//                        "userId" : AppUtils.shared.senderID,
                        "msgData" : mydata2,
                    ] as [String : Any]
                    
                    let dummyparameters = [
                        "selectedUserData" : receiverId,
                        "userId" : AppUtils.shared.senderID,
                        "msgData" : mydata2,
                    ] as [String : Any]
                    print(dummyparameters)
                      SocketIOManager.sharedInstance.sendMessage(message: dummyparameter)
                }
                
                
                if let msg = json["msg"].string {
                    print(msg)
                }
                if let stat = json["status"].int {
                    print(stat)
                }
            }


        case .failure(let encodingError):
            print("the error is  : \(encodingError.localizedDescription)")
        }
    })
                     }
}
       
              
    
    
    //Read_Unread_AllChat
    func UnReadAllChat(receiverId: String , onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "projectId" : AppUtils.shared.projectID,
            "senderId" : AppUtils.shared.senderID,
            "receiverId" : receiverId
        ]
        
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.unreadAllChat) { (response, errorMessage) in
            if let data = response {
                print(data)
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    
    
    func logOutUser( onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "userId" :AppUtils.shared.user?._id ?? "",
            "regToken" : AppUtils.shared.getFCMToken()
        ]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .get, parameter: param, serviceName: ServiceURL.logoutUser) { (response, errorMessage) in
            if let data = response {
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    
    
    //Read_AllChat
    func readAllChat(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "projectId" : AppUtils.shared.projectID,
            "senderId" : AppUtils.shared.senderID,
            "receiverId" : receiverId
        ]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.readAllChat) { (response, errorMessage) in
            
            if let data = response {
                print(data)
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    
    //Delete_Spesific chat of Friends..
    
    func deleteAllChat(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "isGroup" : "0" ,
            "userId" : AppUtils.shared.senderID,
            "receiverId" : receiverId
        ]
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.deleteAllChat) { (response, errorMessage) in
            
            if let data = response {
                print(data)
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    func deleteFriend(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "userId" : AppUtils.shared.senderID,
            "friendId" : receiverId
        ]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .delete, parameter: param, serviceName: ServiceURL.deleteFriend) { (response, errorMessage) in
            
            if let data = response {
                print(data)
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    
    
    
    //Hide Chat
    func muteFriend(muteId: String, muteType: Int, muteStatus: Int,  onCompletion: @escaping onCompletion<Bool>){
          let param = [
            "userId" : AppUtils.shared.senderID,
            "friendId" : muteId,
            "muteStatus" : muteStatus
        ] as [String : Any]
        print(param)
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.muteFriend) { (response, errorMessage) in
            
            if response != nil {
                
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
                
            }
        }
    }
    
    //Block_User
    func blockUser(blockStatus: Int, blockUserId: String, onCompletion: @escaping onCompletion<Bool>){
        
        let param = [
            "blockStatus" : blockStatus,
            "userId" : AppUtils.shared.senderID,
            "friendId" : blockUserId,
        ] as [String : Any]
        
        NetworkController.shared.serviceResponseObject(method: .post, parameter: param, serviceName: ServiceURL.blockFriend) { (response, errorMessage) in
            
            if let data = response {
                onCompletion(true, nil)
            }else{
                onCompletion(false, "Error")
            }
        }
    }
    
    
    // MARK: Check File Exist it will search Locally
    
    func searchFileExist(fileName:String,fileType:Int) -> String?{
        var fileextension = ""
        if fileType == 5
        {
            fileextension = "Videos"
        }
        else if fileType == 6
        {
            fileextension = "Audios"
        }
        else if fileType == 2
        {
            fileextension = "Document"
        }
      
        let dataCompare = fileName.count > 38  ? String(fileName.dropFirst(37) ?? "") : fileName ?? ""
      
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let folderUrl = url.appendingPathComponent(fileextension)
        if let pathComponent = folderUrl?.appendingPathComponent(dataCompare) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            print(filePath)
            pat = filePath
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                print(filePath)
                return filePath
            } else {
                
                print("FILE NOT AVAILABLE")
            }
        }else{
            print("FILE PATH NOT AVAILABLE")
        }
        return nil
    }
    
    func downloadaudio(isSent:Bool, name:String,senderId:String, completion: @escaping ((Bool?) -> Void)){
        var url:URL?
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        var newUrl:URL?
        do{
            var  newName = name.replacingOccurrences(of: " ", with: "%20")
            var urls = "https://chat.chatto.jp:20000/meetingchat/"
           // let urls = "https://chat.chatto.jp:21000/download/"
            url =  URL(string: "\(urls)\(newName)")
            newUrl = documentsUrl.appendingPathComponent("Audios")
            
            try FileManager.default.createDirectory(atPath: newUrl!.path, withIntermediateDirectories: true, attributes: nil)
            // let namesplit = name.split(separator: "-")
            // var finalname =  String(namesplit.last!)
            let nam = String(name.dropFirst(37) )
            let destinationFileUrl = newUrl?.appendingPathComponent(nam)
            let fileURL = url
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                var data = Data()
                var decAudio = Data()
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        do{
                            data = try Data(contentsOf: tempLocalUrl)
                            //New Added
                            let key = senderId // length == 32
                            let test = ""
                            var  ivStr = key ?? "" + test
                            let halfLength = 16 //receiverId.count / 2
                            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
                            ivStr.insert("-", at: index)
                            let result = ivStr.split(separator: "-")
                            let iv = String(result[0])
                            //New Added
                            decAudio = try data.aesDecryptData(key: key, iv: iv) as! Data
                            let fileSize = Double(decAudio.count / 1048576)
                            print("ImageSend File size1 in MB Audio Decrypt: ", fileSize , decAudio.count)
                            try decAudio.write(to: destinationFileUrl!)
                            
                        }catch(let error as Error){
                            print(error.localizedDescription)
                        }
                        completion(true)
                        DispatchQueue.main.async {
                            print("Image Downloaded")
                        }
                    }
                    do {
                        //try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                        
                    }catch (let writeError) {
                        print("Error1\(String(describing: destinationFileUrl)) : \(writeError)")
                        DispatchQueue.main.async {
                            print("Files already exist")
                            completion(false)
                        }
                    }
                 } else {
                    print("Error description: \(error?.localizedDescription ?? "")")
                }
            }
            task.resume()
        }catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
    }
    
    
    
}



extension UIImage {

func resized(withPercentage percentage: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: size.width  , height: size.height  )
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
}

func resizedTo1MB() -> UIImage? {
    guard let imageData = self.pngData() else { return nil }

    var resizingImage = self
    var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB

    while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
        guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
              let imageData = resizedImage.pngData()
            else { return nil }

        resizingImage = resizedImage
        imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
    }

    return resizingImage
}
}
