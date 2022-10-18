//
//  socketIOManager.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 08/05/2022.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager : NSObject{
    var Isconnected = false
    static let sharedInstance = SocketIOManager()
    static let sharedMainInstance = SocketIOManager()
    static let sharedCallInstance = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: ServiceURL.baseURL)!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    private override init(){
        super.init()
        socket = manager.defaultSocket
        addHandlers()
    }
    
    func socketOff(){
        socket.off(SocketHelper.receivemsg)
        socket.off(SocketHelper.receiverUserStatus)
        socket.off(SocketHelper.starttyping)
        socket.off(SocketHelper.stoptyping)
        socket.off(SocketHelper._ringyHideOnlineStatus)
        socket.removeAllHandlers()
    }
    
    
    func addHandlers(){
        socket.on(clientEvent: .connect) {data, ack in
            print("Socket connected By Class1 ")
            print(data)
           
            self.ConnectSocket()
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            self.Isconnected = false
            print("\n Socket disconnected By\n")
        }
        socket.on(clientEvent: .error) {data, ack in
            print("\nSocket error By\n")
        }
        
        socket.on(clientEvent: .statusChange) {data, ack in
            print("\nStatus change: By \(data)\n")
        }
        self.establishConnection()
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    func sendMessage(message: Any) {
        if  Isconnected == false {
            ConnectSocket()
            socket.emit(SocketHelper.o2o, with: [message]) }
        else {
            socket.emit(SocketHelper.o2o, with: [message])
        }
    }
    
    func Unreadsms(message: Any) {
        socket.emit(SocketHelper.o2oUpdateReadMsg, with: [message])
    }
    
    func getChatMessage(completionHandler: @escaping ( _ messageInfo: Any , _ selectusL : String) -> Void) {
        socket.on(SocketHelper._o2o) { (dataArray, socketAck) -> Void in
            print(dataArray)
             print(selectdfrind)
             completionHandler(dataArray,selectdfrind)
         
        }
    }
    func onlinestatus (completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on(SocketHelper.onlineStatus) { (dataArray, socketAck) -> Void in
            print(dataArray)
             completionHandler(dataArray)
         
        }
    }
    
    func StartTypingFriend(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on(SocketHelper.onTyping) { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func StopTypingFriend(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on(SocketHelper.onStopTyping) { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    func StartTyping(receiver_id: String? = "") {
        let userinfo = [
            "senderId" : "\(AppUtils.shared.senderID)",
            "name" : "\(AppUtils.shared.user?.name ?? "")",
            "receiverId" : receiver_id ?? ""
        ]
        if AppUtils.shared.getTypingStatus == 1 {
            socket.emit(SocketHelper.emitIsTyping, with: [userinfo]) }
    }
    
    func StopTyping(receiver_id: String? = "") {
        let userinfo = [
            "senderId" : "\(AppUtils.shared.senderID)",
            "name" : "\(AppUtils.shared.user?.name ?? "")",
            "receiverId" : receiver_id ?? ""
        ]
        socket.emit(SocketHelper.emitStopTyping, with: [userinfo])
    }
   
    func changeStatus(message: Any) {
        socket.emit(SocketHelper.statusOn, with: [message])
    }
   
    func changeStatusLogout(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on(SocketHelper.changestatuslogout){(dataArray, socketAck) -> Void in
            print(dataArray)
            completionHandler(dataArray)
        }
    }
    
    func ConnectSocket() {
        Isconnected = true
        self.socket.emit(SocketHelper.user_connected, with: [ AppUtils.shared.user?._id ?? ""])
    }
   
    func updateMsg(message: Any) {
        print(socket.emit(SocketHelper.o2oUpdateMsg, with: [message]))
    }
    
    func receiveupdatedsms (completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on(SocketHelper._o2oUpdateMsg){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
}


class JSONSendData: NSObject {
    static let sharedInstance = JSONSendData()
    func typing(msgSenderId:String)->NSMutableDictionary {
        let prod: NSMutableDictionary = NSMutableDictionary()
         let recieverId: NSMutableDictionary = NSMutableDictionary()
         recieverId.setValue(msgSenderId, forKey: "_id")
         let recvData = try? JSONSerialization.data(withJSONObject: recieverId, options: .prettyPrinted)
         let recvParsed = try! JSONSerialization.jsonObject(with: recvData!, options: .allowFragments)
         prod.setValue(recvParsed, forKey: "selectFrienddata")
        prod.setValue(AppUtils.shared.senderID, forKey: "UserId")
        return prod
    }
}
