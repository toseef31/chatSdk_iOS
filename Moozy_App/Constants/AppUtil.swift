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
  
    
    func saveFCMToken(fcmToken: String){
        UserDefaults.setSavedValue(value: fcmToken, key: .fcmToken)
    }
    
    func getFCMToken() -> String{
        return UserDefaults.getSavedValue(key: .fcmToken) ?? ""
    }
    
    func registerNotification(value: Bool){
        UserDefaults.setSavedValue(value: value, key: .registerNotification)
    }
    
    func isRegisterNotification() -> Bool{
        if UserDefaults.containsKey(key: .registerNotification){
            return UserDefaults.getSavedValue(key: .registerNotification)
        }else{
            return true
        }
    }
    
    
    
    func saveTocken(token: String){
        UserDefaults.setSavedValue(value: projectID, key: .projectID)
    }
    
    var language: String{
        get{
            if UserDefaults.containsKey(key: .language){
                return UserDefaults.getSavedValue(key: .language) ?? ""
            }
            return "1"
        }
    }
    
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
    
    var allUsers: [FrindsModel]?{
        get{
            if UserDefaults.containsKey(key: .allUsers){
                if let data : Data = UserDefaults.getSavedValue(key: .allUsers){
                    if let user = try? decoder.decode(Array<FrindsModel>.self, from: data){
                        return user
                    }
                }
            }
            return []
        }
    }
    
    var getAllChat: [chatModel]?{
        get{
            if UserDefaults.containsKey(key: .allChat){
                if let data : Data = UserDefaults.getSavedValue(key: .allChat){
                    if let chat = try? decoder.decode(Array<chatModel>.self, from: data){
                        return chat
                    }
                }
            }
            return []
        }
    }
    
    //Chatto Get Chat
    func getChatMessages(key: String, onCompletion: @escaping onCompletion<[chat_data]>){
        if UserDefaults.containsChatKey(key: key){
            if let data : Data = UserDefaults.Get_ChatMessage(key: key){
                if let chat = try? decoder.decode(Array<chat_data>.self, from: data){
                    onCompletion(chat, "no Data")
                }
            }
        }
    }
    
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
    
    
    func saveImageCache( obj : [NSURL:UIImage]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "CacheImages")
        } catch {
            print("Couldn't save file")
        }
    }
    
    
    func saveChatImages(storeImage: [storeImage]?){
        UserDefaults.setSavedValue(value: storeImage, key: .saveImage)
    }
    
    
    
    func saveProfileImageCache( obj : [NSURL:UIImage]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "CacheImages")
        } catch {
            print("Couldn't save file")
        }
    }
    
    //Chatto Save Chat
    func saveChatMessages(chat: [chat_data]?, key: String ){
        if let encodedData = try? encoder.encode(chat){
            UserDefaults.Save_ChatMessage(value: encodedData, key: key)
        }
    }
    
    //Chatto Save Chat
    func saveChatMessa(chat: Data, key: String ){
      
        if let encodedData = try? encoder.encode(chat){
            UserDefaults.Save_ChatMessage(value: chat, key: key)
        }
    }
    
    
    //Chatto Save Chat
//    func saveChatMessag (chat: [ChatMessagesModel]?, key: String ){
//        if let encodedData = try? encoder.encode(chat){
//            UserDefaults.Save_ChatMessage(value: encodedData, key: key)
//        }
//    }
    
    
    //Chatto Save Chat
    func saveMessages(chat: [chatModel]?){
        if let encodedData = try? encoder.encode(chat){
            UserDefaults.Save_ChatMessage(value: encodedData, key: "allDumyChat")
        }
    }
    
    
    var getdumyChat: [chatModel]?{
        get{
            if UserDefaults.containsKey(key: .allDumyChat){
                if let data : Data = UserDefaults.getSavedValue(key: .allDumyChat){
                    if let chat = try? decoder.decode(Array<chatModel>.self, from: data){
                        return chat
                    }
                }
            }
            return []
        }
    }
    
    
    var projectID: String{
        get{
            if UserDefaults.containsKey(key: .projectID){
                return UserDefaults.getSavedValue(key: .projectID) ?? ""
            }
            return ""
        }
    }
    
    var senderID: String {
        get{
            if UserDefaults.containsKey(key: .senderID){
                return UserDefaults.getSavedValue(key: .senderID) ?? ""
            }
            return ""
        }
    }
    
    func saveProjectID(projectID: String){
        UserDefaults.setSavedValue(value: projectID, key: .projectID)
    }
    //list of userdetail
//    set
    
//    func userImageNames(userImageNames: String){
//        UserDefaults.setSavedValue(value: userImageNames, key: .Block)
//    }
   
    
    func MuteFriends(MuteFriends: [String]){
        UserDefaults.setSavedValue(value: MuteFriends, key: .MuteFriends)
    }
    func HideFriends(HiddenFriend : [String]){
        UserDefaults.setSavedValue(value: HiddenFriend, key: .HideFriends)
    }
    func BlockFriends(BlockFriends: [String]){
        UserDefaults.setSavedValue(value: BlockFriends, key: .BlockFriends)
    }
  
    //get
//    var  getUserImg: String {
//        get{
//            if UserDefaults.containsKey(key: .userImageNames){
//                return UserDefaults.getSavedValue(key: .userImageNames) ?? ""
//            }
//            return ""
//        }
//    }
    
    var  MuteUsere: [String]? {
        get{
            if UserDefaults.containsKey(key: .MuteFriends){
                return UserDefaults.getSavedValue(key: .MuteFriends) ?? []
            }
            return []
        }
    }
    var  blockUserUsere: [String]? {
        get{
            if UserDefaults.containsKey(key: .BlockFriends){
                return UserDefaults.getSavedValue(key: .BlockFriends) ?? []
            }
            return []
        }
    }
    
    var  hiddenUsere: [String]? {
        get{
            if UserDefaults.containsKey(key: .HideFriends){
                return UserDefaults.getSavedValue(key: .HideFriends) ?? []
            }
            return []
        }
    }
    //end..
    func saveSenderID(senderID: String){
        UserDefaults.setSavedValue(value: senderID, key: .senderID)
    }
    
    
    func saveLanguage(languageId: String){
        UserDefaults.setSavedValue(value: languageId, key: .language)
    }
    
    func saveUser(user: LogInModel){
        if let encodedData = try? encoder.encode(user){
            UserDefaults.setSavedValue(value: encodedData, key: .loginUser)
        }
    }
    
    func saveAllUser(user: [FrindsModel]?){
        if let encodedData = try? encoder.encode(user){
            UserDefaults.setSavedValue(value: encodedData, key: .allUsers)
        }
    }
    
    
    
    func saveAllChat(chat: [chatModel]?){
        if let encodedData = try? encoder.encode(chat){
            UserDefaults.setSavedValue(value: encodedData, key: .allChat)
        }
    }
    
    
    
    func clearSession(){
        UserDefaults.removeAllKeysValues()
    }
    
    func saveTheme(theme: UserDefaultsKey){
        UserDefaults.setSavedValue(value: theme, key: .app_theme)
    }
    
    var theme: String{
        get{
            if UserDefaults.containsKey(key: .app_theme){
                return UserDefaults.getSavedValue(key: .app_theme) ?? ""
            }
            return ""
        }
    }
    

    func decryptMessage(message:String, key:String, iv:String)-> String{
    
        var ivStr = iv
        let halfLength = 16 //receiverId.count / 2
        let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
        ivStr.insert("-", at: index)
        let result = ivStr.split(separator: "-")
        let iv = String(result[0] )
        let s =  "" + message
        var decMessage = ""
        print("my sec id is dm \(s)")
        do{
            decMessage = try s.aesDecrypt(key: key , iv: iv)
        }catch( let error as Error ){
            print(error)}
        print("DENCRYPT",decMessage)
        return decMessage
    }
    
    
    //MARK: Decrypt Messages..
    func decryptMessage(msgData: chatModel, completion: @escaping (Bool, String) -> ()) {
      
        let senderId = msgData.senderId?._id// length == 32
        var  ivStr = senderId ?? "" + ""
        let index = ivStr.index(ivStr.startIndex, offsetBy: 16) // 16 is the half length..
        ivStr.insert("-", at: index)
        let result = ivStr.split(separator: "-")
        do {
            let decryptedMessage = try msgData.message.aesDecrypt(key: senderId ?? "", iv: String(result[0]))
            completion(true, decryptedMessage)
        }catch( let error as NSError ) {
            print(error)
            completion(false, "")
        }
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



var app_theme = "app_theme"
let Blue = "Blue"
let Pink = "Pink"
let Green = "Green"
let Orange = "Orange"
let Yellow = "Yellow"
let Purple = "Purple"
let Red = "Red"
let Gray = "Grey"
let White = "White"


