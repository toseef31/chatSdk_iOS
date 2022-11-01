//
//  BookMarkVM.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 20/10/2022.
//

import Foundation
import Foundation
import SimpleTwoWayBinding

class bookMarkVM{
    
    var allChat: Observable<[chat_data]> = Observable([])
    var ChatMessagesArray = [ChatMessagesModel]()
    var AllChatMsg: Observable<[ChatMessagesModel]> = Observable()
    var isLoader: Observable<Bool> = Observable(false)
   
    init(){
        getBookMarkChat()
        dataBinding()
    }
    
   
    //Get All chat
    func getBookMarkChat(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            self.isLoader.value = true
            
             APIServices.shared.getBookMarkList() { [self]  (response, errorMessage) in
                 isLoader.value = false
                 if response != nil{
                     self.allChat.value = response
                   
                    }else{
                        print(errorMessage)
                 }
             }
            
       })
    }
    
    func unBookMark(messageId: String? = "",receiverId: String? = "" ){
        APIServices.shared.bookmarkChat(messageId: messageId, status: "0", userId: AppUtils.shared.user?._id , receiverId: receiverId){  (response, errorMessage) in
            if response != nil{
               print(response)
               }else{
                print(response)
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
    
    
}
    
    
    

