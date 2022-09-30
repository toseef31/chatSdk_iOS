//
//  NewChatVM.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 12/08/2022.
//

import Foundation
import SimpleTwoWayBinding
import UIKit


struct Friend_DataModel {
    var isSelected: Bool?
    var FrienList : AllFrind_Data?
}
class AllFriendsVM {
  
    var allFriendList: Observable<[String:[Friend_DataModel]]> = Observable()
    
    var userDictionary = [String:[Friend_DataModel]]()
    var sortedContacts :[Friend_DataModel]!
    var userInfo :[Friend_DataModel] = []
    var userDictionaryNil = [String:[Friend_DataModel]]()
    var users = [Friend_DataModel]()
    var userSection = [String]()
    var Allusers = [AllFrind_Data]()
    var userSections: Observable<[String]> = Observable()
    var selecteFriends : [AllFrind_Data] = []
    init(){
        getFriendList()
       
    }
    
    
    func getFriendList(){
        getChat()
       
    }
    
    func getChat(){
        APIServices.shared.getAllUser { [self] (response, errorMessage) in
            if response != nil{
                print(response?.count)
                Allusers = response!
                response?.forEach { data in
                    userInfo.append(Friend_DataModel(isSelected: false, FrienList: data))
                }
                
                sorting()
               
            }else{}
        }
        
    }
    
    func sorting(){
        self.sortedContacts = []
        self.sortedContacts = userInfo.sorted(by: { $0.FrienList?.name?.capitalizingFirstLetter() ?? "" < $1.FrienList?.name?.capitalizingFirstLetter() ?? ""   })
        
        self.users = self.sortedContacts
        userDictionary = userDictionaryNil
        for user in self.users{
            users.forEach { da in
                let index = users.firstIndex(where: {$0.FrienList?.name == "" })
                if index != nil {
                    users[index!].FrienList?.name = "No Name"
                }
            }
            
            let key = "\((user.FrienList?.name!.capitalizingFirstLetter().uppercased().prefix(1)) ?? "NN")"
            if var userValue = self.userDictionary[key]{
             
                userValue.append(user)
                self.userDictionary[key]?.append(user)
            }else{
                //print(user)
                self.userDictionary[key] = [user]
            }
            self.userSection = [String](self.userDictionary.keys).sorted()
        }
       
        userSections.value = userSection
        allFriendList.value = userDictionary
       
    }
    
    
    func updateCustomerSelection( userKey : String , location: IndexPath){
        
        var arrayOfFriends = allFriendList.value!
        let status = (!((arrayOfFriends[userKey]?[location.row].isSelected)!))
        arrayOfFriends[userKey]?[location.row].isSelected = status
        allFriendList.value = arrayOfFriends
       
        
        if (arrayOfFriends[userKey]?[location.row].isSelected!) == true{
            
            selecteFriends.append((arrayOfFriends[userKey]?[location.row].FrienList) as! AllFrind_Data)

        }else{
            selecteFriends = selecteFriends.filter{$0._id != (arrayOfFriends[userKey]?[location.row].FrienList?._id)!}
        }
        print(selecteFriends.count)
        
    }
    
    //Send Messages
    func sendMessage(message: [chat_data]){
        selecteFriends.forEach { data in
            message.forEach { messageData in
            
                APIServices.shared.sendMessage(receiver_Id: data._id ?? "", message: messageData.message, messageType: messageData.messageType, chatType: 0, comment_Id: "" , createdAt: "", selectedUserData: messageData._id) { [self] (response, errorMessage) in
                    if response != nil{
                        print("Send Message")
                        
                    }else{}
                }
            }
          
            
        }
//        APIServices.shared.sendMessage(receiver_Id: selecteFriends.first?.u_id ?? "", message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, createdAt: "", selectedUserData: selectedUserData ?? "") { [self] (response, errorMessage) in
//            if response != nil{
//                print("Send Message")
//
//            }else{}
//        }
    }
    
}


