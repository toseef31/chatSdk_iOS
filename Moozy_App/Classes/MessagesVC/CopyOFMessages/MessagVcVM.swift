//
//  MessagVcVM.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 06/08/2022.
//


import Foundation
import SimpleTwoWayBinding
import UIKit

struct ChatMessageModelselection : Codable {
    var isSelected: Bool?
    var isSending: Bool?
    var isDownloading: Bool?
    var messages : chat_data?
}

struct ChatMessagesModel : Codable {
    var isSelected: Bool?
    var date : String?
    var messagesData : [ChatMessageModelselection]?
}


class ChatDataVM {
    
    var allChat: Observable<[chat_data]> = Observable([])
    var isAllChat: Observable<Bool> = Observable(false)
    
    var receiverID: Observable<String> = Observable("")
    //new Updated
    var ChatMessagesArray = [ChatMessagesModel]()
    var AllChatMsg: Observable<[ChatMessagesModel]> = Observable()
    
    var isSelecting : Bool = false
    var selectedMessage : [chat_data]  = []
    private let utilityQueues = DispatchQueue.global(qos: .utility)
    
    init(receiverId: String? = ""){
        receiverID.value = receiverId!
         getChat()
        dataBinding()
    }
    func updatalocalChat(data : [ChatMessagesModel]){
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let datae = try! encoder.encode(data)
        UserDefaults.removeSpecificKeys(key: "\(AppUtils.shared.user?._id ?? "")\(receiverID.value!)")
        AppUtils.shared.saveChatMessa(chat: datae, key: "\(AppUtils.shared.user?._id ?? "")\(receiverID.value!)")
    
    }
    
    //Get All chat
    func getChat(){
        
        APIServices.shared.getChat(receiverId: receiverID.value!, limit: 0, chatHideStat: false) { [self] (response, errorMessage) in
            if response != nil{
                isSelecting = false
                 DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    allChat.value = response
                })
               }else{
                
            }
        }
    }
    
    
    //Send Messages
    func sendMessage(message: String, chatType: Int, messageType: Int, commentId: String? = "" , commentData : [chat_data]? = [] , selectedUserData: String? = ""){
        
        isForwardByMe = true
        
        APIServices.shared.sendMessage(receiver_Id: receiverID.value!, message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, commentData: commentData, createdAt: "", selectedUserData: selectedUserData ?? "") { [self] (response, errorMessage) in
            if response != nil{
                print("Send Message")
                isSelecting = false
              
            }else{}
        }
        
    }
    
    //Send Messages
    func UpdateMessage(Messages: [ChatMessagesModel], message_Id : IndexPath ,message: String, chatType: Int, messageType: Int, commentId: String? = "", selectedUserData: String? = ""){
        isForwardByMe = true
        
        let data = Messages
       // let data = arrayOfMessages

        data[message_Id.section].messagesData?[message_Id.row].messages?.message = message
        
        AllChatMsg.value = data
        
        APIServices.shared.updateMessage(message_Id: AllChatMsg.value![message_Id.section].messagesData?[message_Id.row].messages?._id ?? "" ,receiver_Id: receiverID.value!, message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, createdAt: AllChatMsg.value![message_Id.section].messagesData?[message_Id.row].messages?.createdAt.getActualDate() ?? "", selectedUserData: selectedUserData ?? "")
    }
    
    
    func getChatMessageLocal(){
        
        let senderId = AppUtils.shared.senderID
        print("\(senderId)\(receiverID.value!)")
        AppUtils.shared.getLocalChatMessages(key: "\(senderId)\(receiverID.value!)") { [self] (response, errorMessage) in
            if response != nil{
                isSelecting = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    AllChatMsg.value = response
                   // allChat.value = response
                    
                })
            }else{
                
            }
        }
    }
    
    
    func sendMessage(message: String, chatType: Int, messageType: Int, commentId: String? = "" , commentData : [chat_data] ){
        isForwardByMe = true
        APIServices.shared.sendMessage(receiver_Id: receiverID.value!, message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, commentData: commentData, createdAt: "", selectedUserData: "") { [self] (response, errorMessage) in
            if response != nil{
                isSelecting = false
                getChat()
                
            }else{
                
            }
        }
    }
    
   
    func dataBinding(){
        
        allChat.bind { [self] (data, _) in
            ChatMessagesArray.removeAll()
            for msgIndex in 0..<data.value!.count {
                var actualDate = ""
                
                if data.value![msgIndex].createdAt != ""{
                    actualDate = data.value![msgIndex].createdAt.getActualDate()
                }
                if ChatMessagesArray.count >= 0 {
                    if let filteredIndex = ChatMessagesArray.firstIndex(where: {$0.date == actualDate}) {
                        ChatMessagesArray[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: false, isDownloading: false, messages:  data.value![msgIndex])])
                    }
                    else {
                        ChatMessagesArray.append(ChatMessagesModel(isSelected: false, date: actualDate, messagesData: [ChatMessageModelselection(isSelected: false, isSending: false, isDownloading: false, messages: data.value![msgIndex])]))
                        
                    }
                }
            }
            AllChatMsg.value = ChatMessagesArray
        }
    }
    
    
    func updateCustomerSelection(Messages: [ChatMessagesModel], location: IndexPath){
        
        var arrayOfMessages = Messages
        
        let status = (!((arrayOfMessages[location.section].messagesData?[location.row].isSelected)!))
        arrayOfMessages[location.section].messagesData?[location.row].isSelected = status
        isSelecting = true
        if (arrayOfMessages[location.section].messagesData?[location.row].isSelected!) == true{
            selectedMessage.append((Messages[location.section].messagesData?[location.row].messages)!)
        }else{
            selectedMessage = selectedMessage.filter{$0._id != (Messages[location.section].messagesData?[location.row].messages?._id)!}
        }
        AllChatMsg.value = arrayOfMessages
        print(selectedMessage.count)
        
        
    }
    
    
    func StartDownloading (Messages: [ChatMessagesModel], location: IndexPath){
        
        var arrayOfMessages = Messages
        isSelecting = true
        arrayOfMessages[location.section].messagesData?[location.row].isDownloading = true
       AllChatMsg.value = arrayOfMessages
        
    }
    
    
    
    func CancelSelectionMessages( ){
      
        var arrayOfMessages = AllChatMsg.value
        var actualDate = ""
        
        selectedMessage.forEach { data in
            actualDate = (data.createdAt?.getActualDate())!
            if let filteredIndex = arrayOfMessages?.firstIndex(where: {$0.date == actualDate}) {
                
                let row = arrayOfMessages?[filteredIndex].messagesData?.firstIndex(where: {$0.messages?._id == data._id })
                let status = (!((arrayOfMessages?[filteredIndex].messagesData?[row ?? 0].isSelected)!))
                arrayOfMessages?[filteredIndex].messagesData?[row ?? 0].isSelected = status
                
            }else {
                print("NotFound")
            }
        }
        AllChatMsg.value = arrayOfMessages
        selectedMessage.removeAll()
        
    }
    
    
    func DeleteMessages( ){
        
        var arrayOfMessages = AllChatMsg.value
        
        var actualDate = ""
        
        selectedMessage.forEach { data in
            actualDate = (data.createdAt?.getActualDate())!
            
            if let filteredIndex = arrayOfMessages?.firstIndex(where: {$0.date == actualDate}) {
                
                let row = arrayOfMessages?[filteredIndex].messagesData?.firstIndex(where: {$0.messages?._id == data._id })
                
                if arrayOfMessages?[filteredIndex].messagesData?.count ?? 0 == 1 {
                    arrayOfMessages?.remove(at: filteredIndex)
                }
                else {
                    arrayOfMessages?[filteredIndex].messagesData?.remove(at: row ?? 0)
                }
                
                
            }else {
                print("NotFound")
            }
        }
        AllChatMsg.value = arrayOfMessages
        print(selectedMessage.count)
        
        APIServices.shared.deleteSingleChat(messageId: selectedMessage ){ [self] (response, errorMessage) in
            print(response)
        }
        
        
    }
    
    func sendFile(image: UIImage? = nil , fileName: String? = "", audioData:Data?, videoData:Data? = nil, friendId: String, messageType: Int, receiptStatus: Int, receiverId: String ) {
        isSelecting = false
        isForwardByMe = true
        APIServices.shared.sendFiles(image: image, fileName: fileName, audioData: audioData,videoData: videoData,  friendId: friendId, messageType: messageType , receiptStatus: 0, receiverId: receiverId) { response, progress, errorMessage in
            if response != nil{
                print("SentSucessfullu")
            }else{
                print("errro")
                
            }
        }
        
    }
    
    
    func downloadImage(Messages: [ChatMessagesModel] , imageName: String, senderId : String,isSent: Bool ,indexPath: IndexPath ){
        var arrayOfMessages = Messages
        
        DownloadData.sharedInstance.download(isImage: true, isVideo: false, isSent: isSent, name: imageName , senderId: senderId ) { (response, isDownloaded) in
            
            if isDownloaded!{
                DispatchQueue.main.async { [self] in
                    print(response)
                    isSelecting = true
                    
                    arrayOfMessages[indexPath.section].messagesData?[indexPath.row].isDownloading = false
                    AllChatMsg.value = arrayOfMessages
                }
            }
            else{
                print("Error")
            }
        }
    }
    
    func downloadAudio (Messages: [ChatMessagesModel] , audioName: String, senderId : String,isSent: Bool ,indexPath: IndexPath) {
        var arrayOfMessages = Messages
        print(audioName)
        print(senderId)
        print(isSent)
       
        APIServices.shared.downloadaudio(isSent: true, name: audioName, senderId: senderId ){ (response) in
            if response == true {
                DispatchQueue.main.async { [self] in
                    print(response)
                    isSelecting = true
                    arrayOfMessages[indexPath.section].messagesData?[indexPath.row].isDownloading = false
                    AllChatMsg.value = arrayOfMessages
                      
                }
            }
            
        }
    }
    
    
    func dowloadFile(Messages: [ChatMessagesModel] ,  fileName : String, isSent : Bool, senderId : String ,indexPath: IndexPath ) {
        var arrayOfMessages = Messages
        
        DownloadData.sharedInstance.download(isImage: false, isVideo: false, isSent: isSent, name: fileName , senderId: senderId ) { [self] (response, isDownloaded) in
            print(response)
            if isDownloaded!{
                isSelecting = true
               
               // self.imgdownloadFile.isHidden = true
                DispatchQueue.main.async { [self] in
                    print(response)
                    arrayOfMessages[indexPath.section].messagesData?[indexPath.row].isDownloading = false
                    AllChatMsg.value = arrayOfMessages
                     
                }
            }
        }
    }
    
}
