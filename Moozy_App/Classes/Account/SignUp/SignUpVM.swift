//
//  SignUpVM.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 08/09/2022.
//

import Foundation
import SimpleTwoWayBinding

class SignUpVM{
    
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var first_name: Observable<String> = Observable("")
    var last_name: Observable<String> = Observable("")
    
    var isSignUp: Observable<Bool> = Observable(false)
    var message: Observable<String> = Observable("")
    
    var isLoader: Observable<Bool> = Observable(false)
    
    init(){
        
    }
    
    func signUp(){
        isLoader.value = true
        isSignUp.value = true
        APIServices.shared.SignUpUser() { [self] response, errorMessaage in
            if let result = response {
                print(result.message)
            }
            
                    }
//        APIServices.shared.signUP(email: email.value!, password: password.value!, first_name: first_name.value!, last_name: last_name.value!){ [self] response, errorMessaage in
//            isLoader.value = false
//            if let result = response{
//                print(result)
//                isSignUp.value = true
//            }else{
//                message.value = "\(errorMessaage ?? "")"
//            }
//        }
    }
}
