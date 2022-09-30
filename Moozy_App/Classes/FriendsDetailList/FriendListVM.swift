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
            serviceUrl = "friends/muteFriends/"
            break
            
        case "Hidden Fiends":
            serviceUrl = "friends/hideFriends/"
            break
            
        case "Blocked Friends":
            serviceUrl = "friends/blockFriends/"
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
    
    
    }
    
    
    

