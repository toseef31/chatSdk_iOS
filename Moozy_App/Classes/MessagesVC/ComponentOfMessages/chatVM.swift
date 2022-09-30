//
//  chatVM.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 10/05/2022.
//

import Foundation
import SimpleTwoWayBinding
import UIKit

struct NewMessages{
    var date : String
    var messages : [ChatMessageModel]
}

struct NewChatMessages{
    var isDowloading: Bool
    var date : String
    var messages : [chatModel]
}


class ChatVM{
    
    var allChat: Observable<[chatModel]> = Observable([])
    var isAllChat: Observable<Bool> = Observable(false)
    var allChatMessage: Observable<[ChatMessageModel]> = Observable()
    
    var receiverID: Observable<String> = Observable("")
    
    var allMessages = [ChatMessageModel]()
    var allChatMessages = [[ChatMessageModel]]()
    
//    var AllChatMessage: Observable<[NewMessages]> = Observable()
    var AllChatMessage: Observable<[NewChatMessages]> = Observable()
    
//    var messagesArr = [NewMessages]()
    
    var chatMessagesArr = [NewChatMessages]()
    
    var chatLocalMessages: Observable<[chatModel]?> = Observable([])
     
    init(receiverId: String? = ""){
        receiverID.value = receiverId!
//        Reachability.isConnectedToNetwork { [self] isConneted in
//            if isConneted{
//                getChat()
////            }else{
//                getChatMessageLocal()
//            }
//        }
    }
    
    //Get All chat
    func getChat(){
        APIServices.shared.getChat(receiverId: receiverID.value!, limit: 0, chatHideStat: false) { [self] (response, errorMessage) in
            if response != nil{
                let senderID = AppUtils.shared.senderID
//                UserDefaults.removeSpecificKeys(key: "\(senderID)\(receiverID.value!)")
               // AppUtils.shared.saveChatMessages(chat: response., key: "\(senderID)\(receiverID.value!)")
                getChatMessageLocal()
            }else{}
        }
    }
    
    
    func getChatMessageLocal(){
        let senderId = AppUtils.shared.senderID
        AppUtils.shared.getChatMessages(key: "\(senderId)\(receiverID.value!)") { [self] (response, errorMessage) in
            if response != nil{
          //      createMessageSection(from: response)
            }else{}
        }
    }
    
    
    func sendMessage(message: String, chatType: Int, messageType: Int, commentId: String? = ""){
//        APIServices.shared.sendMessage(receiver_Id: receiverID.value!, message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, createdAt: "", selectedUserData: "") { [self] (response, errorMessage) in
//            if response != nil{
//                print("Send Message")
////                Reachability.isConnectedToNetwork { isConnected in
////                    if isConnected{
//                        getChat()
////                    }else{
////                        getChatMessageLocal()
////                    }
////                }
//            }else{
//
//            }
//        }
    }
    
    //MARK: Split Messages by each day (Sections)..
    let chatMessages = ChatMessageModel(user_id: "", frind_id: "", message: "", message_Type: 0, status: nil, isSeen: nil, receiptStatus: nil, createdDate: "", hide: nil, sender_id: "", sender_name: "", sender_image: "", receiver_id: "", receiver_name: "", receiver_image: "")
    
    
    func createMessageSection(from messagesArray:[chatModel]?) {
        
        chatMessagesArr.removeAll()
        chatMessagesArr.insert(NewChatMessages(isDowloading: false, date: chatMessages.createdDate!, messages: []), at: 0)
        
        for messagesIndex in 0..<messagesArray!.count {
            var actualDate = ""
            if messagesArray![messagesIndex].createdAt != "" {
                actualDate = (messagesArray![messagesIndex].createdAt?.getActualDate())!
            }
            
            if chatMessagesArr.count >= 1 {
                if let filteredIndex = chatMessagesArr.firstIndex(where: {$0.date == actualDate}) {
                    chatMessagesArr[filteredIndex].messages.append(contentsOf: [messagesArray![messagesIndex]])
                }else {
                    chatMessagesArr.append(NewChatMessages(isDowloading: false, date: actualDate, messages: [messagesArray![messagesIndex]]))
                }
            }
        }
        
        
        
        
        AllChatMessage.value = chatMessagesArr
        
        isAllChat.value = true
        print(AllChatMessage.value?.count)
    }

    

}
