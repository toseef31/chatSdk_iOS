//
//  FriendListVM.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 27/09/2022.
//


import Foundation
import SimpleTwoWayBinding

class FriendListVM {
    
    var listFriends : Observable<[AllFrind_Data]> = Observable([])
    var isLoader: Observable<Bool> = Observable(false)
   
  
    init(OperationType: String? = ""){
        friendLists(OperationType: OperationType)
    }
    
   
    func friendLists(OperationType: String? = ""){
        
        var serviceUrl  = ""
        switch OperationType
        {
        case "Muted Friend":
            serviceUrl = ServiceURL.muteFriends
            break
            
        case "Hidden Fiends":
            serviceUrl = ServiceURL.hideFriends
            break
            
        case "Blocked Friends":
            serviceUrl = ServiceURL.blockFriends
            break
        default:
            break
        }
        
        
        isLoader.value = true
        APIServices.shared.getFrindOperationList(serviceUrl: "\(serviceUrl)\(AppUtils.shared.user?._id ?? "")") { [self] (response, errorMessage) in
            isLoader.value = false
            if response != nil{
                listFriends.value = response
                
            }else{
                
            }
        }
    }
    
    func muteFriend (muteId: String){
    APIServices.shared.muteFriend(muteId: muteId, muteType: 0, muteStatus: 0) { response, data in print(response) }
    }
    func hideFriend (hideUserId: String){
        APIServices.shared.hideFriend(hideUserId: hideUserId, hideStatus: 0) { (response, errorMesage) in print("response")} }
    
    func blockUser (blockUserId: String){
        
        APIServices.shared.blockUser(blockStatus: 0, blockUserId: blockUserId) { response, data in }
    }
    
    }
    
    
    

