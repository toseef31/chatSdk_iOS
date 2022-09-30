//
//  chatDetailVM.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 01/06/2022.
//

import Foundation

class chatDetailVM{
    
    
    var receiverId: String? = ""
    
    init(receiverId: String? = ""){
        self.receiverId = receiverId
    }
    
    
    
    
    func hideFrind(){
        APIServices.shared.hideUser(muteId: "\(receiverId ?? "")", muteType: 0, muteStatus: 1){ response, errorMessage in
            if response != nil{
                
            }else{
                
            }
        }
    }
    
    func blockFrind(){
        APIServices.shared.blockUser(blockStatus: 0, blockUserId: "\(receiverId ?? "")"){ response, errorMessage in
            if response != nil{
                
            }else{
                
            }
        }
    }
    
    func deleteFrind(){
        APIServices.shared.deleteAllChat(receiverId: "\(receiverId ?? "")") { response, errorMessage in
            if response != nil{
                
            }else{
                
            }
        }
    }
    
}
