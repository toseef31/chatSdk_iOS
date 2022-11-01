//
//  chatListVM.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 26/04/2022.
//

import Foundation
import SimpleTwoWayBinding

class ChatListVM{
    
    var isLoader: Observable<Bool> = Observable(false)
    var isReLoad: Observable<Bool> = Observable(false)
    var isUpdate: Observable<Bool> = Observable(false)
    
    let db = DatabaseHandler()
    var listOfFriends: Observable<[friendInfoModel]> = Observable()
   
    init(){
        getLocalFrind()
        chatList()
    }
    
    func getLocalFrind(){
        let ary =   db.getFriends()
        self.listOfFriends.value = ary
    }
    func updateReciptStuts(FriendId: String,reciptStatus: Int ){
       let res =  db.friendRecipt(FriendId: FriendId, reciptStatus: reciptStatus)
       getLocalFrind()
        APIServices.shared.readReciptFriends(friendId: FriendId) { data, error in
            print(data)
        }
      
    }
    
    
    func inputFreindsInfo(inputFriend : friendInfoModel) {
        let res =  db.inputFriendInformation(Finfo: inputFriend)
        print(res)
    }
    
    func chatList(){
        isLoader.value = true
        APIServices.shared.getAllFriends { [self] (response, errorMessage) in
            isLoader.value = false
            if response != nil{
               
                db.DeleteAllFriends()
                response?.forEach({ da in
                    let inputFriend = friendInfoModel()
                    inputFriend.message = da.message
                    inputFriend.messageType  = da.messageType
                    inputFriend.receipt_status  = da.unread
                    inputFriend.createdAt = da.createdAt
                    inputFriend.messageCounter  = da.messageCounter
                    inputFriend.friendId = da._id
                    inputFriend.name = da.name
                    inputFriend.profile_image = da.profile_image
                    inputFriend.onlineStatus  = da.onlineStatus
                    inputFriend.ismute  = da.ismute
                    inputFreindsInfo(inputFriend: inputFriend)
                    
                })
                
                self.listOfFriends.value  =   db.getFriends()
                
            }else{
                
            }
        }
    }
    
    func logOutUser(){
        APIServices.shared.logOutUser() { (response, errorMessage) in
            if response != nil{
               print("true")
            }else{
               print("false")
            }
        }
    }
    
    func readAllChat(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        APIServices.shared.readAllChat(receiverId: receiverId) { (response, errorMessage) in
            if response != nil{
                onCompletion(true, nil)
            }else{
                onCompletion(false, nil)
            }
        }
    }
    
    func unreadAllChat(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        APIServices.shared.UnReadAllChat(receiverId: receiverId) { (response, errorMessage) in
            if response != nil{
                onCompletion(true, nil)
            }else{
                onCompletion(false, nil)
            }
        }
    }
    
    func deleteAllChat(receiverId: String, onCompletion: @escaping onCompletion<Bool>){
        APIServices.shared.deleteFriend(receiverId: receiverId) { (response, errorMessage) in
            if response != nil{
                onCompletion(true, nil)
            }else{
                onCompletion(false, nil)
            }
        }
    }
    
    func hideFriends(reciverId: String? = ""){
        APIServices.shared.hideFriend(hideUserId: reciverId ?? "", hideStatus: 1) { (response, errorMesage) in
            print(response)
        }
    }
    
    
    
    
    }
    
    
    

