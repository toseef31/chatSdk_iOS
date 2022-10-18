//
//  loginVM.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 28/04/2022.
//

import Foundation
import SimpleTwoWayBinding

class LoginVM{
    
    var isCreate: Observable<String> = Observable("")
    var isLoader: Observable<Bool> = Observable(false)
    
    init(){
    }
    
    
    //Login User with Phone_Number
    func loginUser(phone: String, password: String){
        isLoader.value = true
        APIServices.shared.loginUser(email: phone, password: password){ [self](response, error) in
            isLoader.value = false
            print(response)
            if let result = response{
                if result._id != "" {
                    print(result.name)
                    AppUtils.shared.saveUser(user: result) //Save User
                    AppUtils.shared.saveSenderID(senderID: result._id ?? "")//Save Sender ID
                    isCreate.value = ""
                }else{
                    isCreate.value = "error!"
                }
            }else{
                isCreate.value = "error!"
            }
        }
    }
    
}
