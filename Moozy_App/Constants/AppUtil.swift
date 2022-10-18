//
//  AppUtil.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

struct storeImage{
    var image: UIImage?
    var name: String?
}


class AppUtils{
    
    static let shared = AppUtils()
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
  
    //Fcm Token for the Notifications.
    func saveFCMToken(fcmToken: String){
        UserDefaults.setSavedValue(value: fcmToken, key: .fcmToken)
    }
    func getFCMToken() -> String{
        return UserDefaults.getSavedValue(key: .fcmToken) ?? ""
    }
  
  
    //Typing Staus user set on/off Typing Status.
    var getTypingStatus : Int {
        get{
            if UserDefaults.containsKey(key: .typingStatus){
                return UserDefaults.getSavedValue(key: .typingStatus) ?? 1
            }
            return 1
        }
    }
    
    func saveUserTyping (typingStatus: Int){
        UserDefaults.setSavedValue(value: typingStatus , key: .typingStatus)
    }
    //Online Staus user set on/off Online Status.
    var getOnlineStatus : Int {
        get{
            if UserDefaults.containsKey(key: .OnlineStatus){
                return UserDefaults.getSavedValue(key: .OnlineStatus) ?? 1
            }
            return 1
        }
    }
    
    func saveUserOnline (typingStatus: Int){
        UserDefaults.setSavedValue(value: typingStatus , key: .OnlineStatus)
    }
    
    
    //Store User Info who Is Logged In.
    var user: LogInModel?{
        get{
            if UserDefaults.containsKey(key: .loginUser){
                if let data : Data = UserDefaults.getSavedValue(key: .loginUser){
                    if let user = try? decoder.decode(LogInModel.self, from: data){
                        return user
                    }
                }
            }
            return nil
        }
    }
    
    func saveUser(user: LogInModel){
        if let encodedData = try? encoder.encode(user){
            UserDefaults.setSavedValue(value: encodedData, key: .loginUser)
        }
    }
    //Get and Save chat Localy Stored for a Spesific User.
    func getLocalChatMessages(key: String, onCompletion: @escaping onCompletion<[ChatMessagesModel]>){
        if UserDefaults.containsChatKey(key: key){
            if let data : Data = UserDefaults.Get_ChatMessage(key: key){
                if let chat = try? decoder.decode(Array<ChatMessagesModel>.self, from: data){
                    onCompletion(chat, "no Data")
                }
            }
        }
        else {
            onCompletion([], "no Data")
        }
    }
    
    func saveChatMessa(chat: Data, key: String ){
        if let encodedData = try? encoder.encode(chat){
            UserDefaults.Save_ChatMessage(value: chat, key: key)
        }
    }
    //ProjectID..
    var projectID: String{
        get{
            if UserDefaults.containsKey(key: .projectID){
                return UserDefaults.getSavedValue(key: .projectID) ?? ""
            }
            return ""
        }
    }
    
    func saveProjectID(projectID: String){
        UserDefaults.setSavedValue(value: projectID, key: .projectID)
    }
    
    var senderID: String {
        get{
            if UserDefaults.containsKey(key: .senderID){
                return UserDefaults.getSavedValue(key: .senderID) ?? ""
            }
            return ""
        }
    }



    func saveSenderID(senderID: String){
        UserDefaults.setSavedValue(value: senderID, key: .senderID)
    }
    
    func clearSession(){
        UserDefaults.removeAllKeysValues()
    }
    
   
   
    func writeFileToPath(name:String,data:Data?,fileFolderName:String,destinationUrl:URL?) {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let folderURL = documentsUrl.appendingPathComponent(fileFolderName)
        let fileUrl = folderURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            do{
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Error Writing Image: \(error)")
            }
            print("File does NOT exist1 -- \(fileUrl) -- is available for use")
            let data = data
            do {
                print("Write image")
                if let url = destinationUrl{
                    try FileManager.default.copyItem(at: url, to: fileUrl)
                    return
                }
                try data!.write(to: fileUrl)
            } catch {
                print("Error Writing Image: \(error)")
            }
        } else {
            print("This file exists -- something is already placed at this location")
        }
    }
    
    // MARK: Load Images
     func loadImage(fileName: String) -> UIImage? {
         
         var result = fileName.contains("&MAP_")
         var dataCompare = ""
         print(result)
         if result == true {
             
             let result = fileName.split(separator: ".")
              dataCompare = result[0].count > 38  ? String(fileName.dropFirst(37)) : fileName
             
         }
         else {
             dataCompare = fileName.count > 38  ? String(fileName.dropFirst(37)) : fileName
         }
         print(dataCompare)
        // let cellImage = AppUtils.shared.loadImage(fileName: dataCompare)
        
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let newUrl = documentsUrl.appendingPathComponent("Images")
        let fileURL = newUrl.appendingPathComponent(dataCompare)
         
         print(fileURL)
        do {
            let imageData = try Data(contentsOf: fileURL)
            let image = UIImage(data: imageData)
            return image
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}

