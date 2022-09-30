//
//  commonVM.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 21/05/2022.
//

import Foundation
import SimpleTwoWayBinding
import SocketIO

class SocketVC{
    
    var TypingStatus = String()
    var timerSocket: Timer?
    var typingResponse: Observable<TypingResponse> = Observable()
    
    init() {
//        socket()
    }
    
    
    func socket(){
        
        let manager = SocketManager(socketURL: URL(string: ServiceURL.baseURL)!, config: [.log(true), .compress])
        let socket = manager.defaultSocket
        
        SocketIOManager.sharedMainInstance.establishConnection()
        
        timerSocket = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){(time) in
            
            if SocketIOManager.sharedMainInstance.socket.status == .connected{
                SocketIOManager.sharedMainInstance.receiverUserStatus { [self] (messag) in
                    let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    do{
                        let jsonData = try decoder.decode([SelectionResponse].self, from: jsonData!)
                        let data = jsonData[0]
                        print(data)
//                        selectionResponse.value = data
                    }catch let error as NSError{
                        print(error)}
                }
                self.timerSocket?.invalidate()
            }
        }
        
        //MARK: -- GetChatMessages
        SocketIOManager.sharedMainInstance.getChatMessage {( messageInfo) in
            print(messageInfo)
        }
        
        // MARK: Start Typing Response
        SocketIOManager.sharedMainInstance.StartTypingFriend { (typingData) in
            if self.TypingStatus == "" || self.TypingStatus == " " || self.TypingStatus == "1"{
                APIServices.shared.typingResponse(data: typingData ,typing: true){ [self] (response, errorMessage) in
                    typingResponse.value = response
                }
            }
        }
        // MARK: Stop Typing Response
        SocketIOManager.sharedMainInstance.StopTypingFriend { data in
            if self.TypingStatus == "" || self.TypingStatus == "" || self.TypingStatus == "1"{
                APIServices.shared.typingResponse(data: data, typing: false){ [self] (response, errorMessage) in
                    typingResponse.value = response
                }
            }
        }
    }
}
