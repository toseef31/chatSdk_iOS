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
    
    static let sharedInstance = SocketIOManager()
    static let sharedMainInstance = SocketIOManager()
    static let sharedCallInstance = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: ServiceURL.baseURL)!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    private override init(){
        super.init()
        socket = manager.defaultSocket
        //socket(forNamespace: "/simplechat")
        socket.connect();
        socket.on("user_connected") { [self] data, ack in
            print("socket is connected");
            
        }
      
    }
    
    func addHandlers(){
        
        socket.on(clientEvent: .connect) {data, ack in
            print("Socket connected By Class1 ")
            print(data)
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("\n Socket disconnected By\n")
        }
        socket.on(clientEvent: .error) {data, ack in
            print("\nSocket error By\n")
        }
        
        socket.on(clientEvent: .statusChange) {data, ack in
            print("\nStatus change: By \(data)\n")
        }
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    func sendMessage(message: Any) {
        print(message)
        socket.emit("o2o", with: [message])
    }
  
    func deleteMessage(message: Any) {
        socket.emit("senderdeletemsg", with: [message])
    }
    
    func updateDeletedMessage(message: Any) {
        socket.emit("sendid", with: [message])
    }
    
    func recvDeleteMsg(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("reciverdeletemsg") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func getChatMessage(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
       // sending to a specific room in a specific namespace, including sender
         socket.on("_o2o") { (dataArray, socketAck) -> Void in
            print(dataArray)
             completionHandler(dataArray)
         
        }
    }
    func onlinestatus (completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
       // sending to a specific room in a specific namespace, including sender
         socket.on("front_user_status") { (dataArray, socketAck) -> Void in
            print(dataArray)
             completionHandler(dataArray)
         
        }
    }
    
    
    func getChatdumy () {
        // print("socket")
    
        socket.on("dumy") { (data, socketAck) -> Void in
            print(data)
          
         
        }
    }
    
    
    
    func updateRecvMsg(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("receiveid") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func StartTypingFriend(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        //msgtyping
        socket.on("_o2oTyping") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    
    func StopTypingFriend(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("_o2oStopTyping") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func socketOff(){
        socket.off("receivemsg")
        socket.off("receiverUserStatus")
        socket.off("starttyping")
        socket.off("stoptyping")
        socket.off("_ringyHideOnlineStatus")
        socket.removeAllHandlers()
    }
    
    func StartTyping(receiver_id: String? = "") {
        // create class
        let userinfo = [
            "sender_id" : "\(AppUtils.shared.senderID)",
            "name" : "\(AppUtils.shared.user?.name ?? "")",
            "receiver_id" : receiver_id ?? ""
        ]
        if AppUtils.shared.getTypingStatus == 1 {
            socket.emit("o2oTyping", with: [userinfo]) }
    }
//message: Any
    func StopTyping(receiver_id: String? = "") {
        let userinfo = [
            "sender_id" : "\(AppUtils.shared.senderID)",
            "name" : "\(AppUtils.shared.user?.name ?? "")",
            "receiver_id" : receiver_id ?? ""
        ]
        socket.emit("o2oStopTyping", with: [userinfo])
    }
    //Show Login Status
    func login(message: Any) {
        socket.emit("login", with: [message])
    }
    func changeStatus(message: Any) {
        socket.emit("statusOn", with: [message])
    }
    
    func logout(message: Any) {
        socket.emit("logout", with: [message])
    }
    
    func changeStatusLogout(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("changestatuslogout"){(dataArray, socketAck) -> Void in
            print(dataArray)
            completionHandler(dataArray)
        }
    }
    
    func changeStatusLogin(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("changestatuslogin"){(dataArray, socketAck) -> Void in
            print(dataArray)
            completionHandler(dataArray)
        }
    }
    
    func changeStatusHiddenLogin(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("hideonlinestatus"){(dataArray, socketAck) -> Void in
            print(dataArray)
            completionHandler(dataArray)
        }
        
    }
    //MARK:// Group Chat
    func sendGroupMessage(message: Any) {
        socket.emit("sendgroupmsg", with: [message])
    }
    
    func getGroupChatMessage(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("receivegroupmsg") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func updateGroupDeletedMessage(message: Any) {
        socket.emit("groupsendid", with: [message])
    }
    
    func ConnectSocket() {
        self.socket.emit("user_connected", with: [ AppUtils.shared.user?._id ?? ""])
    }
    func updateGroupRecvMsg(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("groupreceiveid") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func GroupRecvDeleteMsg(completionHandler: @escaping ( _ messageInfo: Any) -> Void) {
        socket.on("grpreciverdeletemsg") { (dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func GroupSenderDeleteMessage(message: Any) {
        socket.emit("grpsenderdeletemsg", with: [message])
    }
    
    //MARK: Message Seen Status
    func receiverUserStatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("receiverUserStatus"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    func updateUserSelection(message: Any) {
        print(socket.emit("updateUserSelection", with: [message]))
    }
    //MARK: Socket recieve status
    func receiveRequeststatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("receiveRequeststatus"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    //
    
    func updateRequeststatus(message: Any) {
        print(socket.emit("updateRequeststatus", with: [message]))
    }
    
    //MARK: Socket Update Read Receipt
    func receiveReceiptStatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("receiveUpdateReadReceipt"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    func updateReceiptStatus(message: Any) {
        print(socket.emit("updateReadReceipt", with: [message]))
    }
    
    //MARK: Socket Update Message
    func receiveUpdateMsg(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //updateUserSelection
        socket.on("receiveupdatechatmsg"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func updateMsg(message: Any) {
        print(socket.emit("o2oUpdateMsg", with: [message]))
    }
    
    //MARK: Socket Group Call Disconnect
    func receiveupdatedsms (completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //
        socket.on("_o2oUpdateMsg"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    //MARK: Socket Group Call Disconnect
    func receiveGroupDetail(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        //
        socket.on("receiveGroupdetail"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    //MARK: Socket Call Disconnect
    func receiveUpdateCallStatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("receiveupdateCallStatus"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    //MARK: Socket Call Disconnect
    func callDiconnectedStatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("_leaveAndroidUser"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    func callDisconnect(message: Any) {
       // print("Call1 leaveAndroidUser by me")
        print(socket.emit("leaveAndroidUser", with: [message]))
    }
    
    // MARK: Call recv Update
    func O2OstarTimer(message: Any) {
        print(socket.emit("O2OstarTimer", with: [message]))
    }
    
    func O2OreceivestarTimer(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("O2OreceivestarTimer"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    //HideOnlineStatus
    func SethideOnlineStatus(message: Any) {
        socket.emit("ringyHideOnlineStatus", with: [message])
    }
    
    func GethideOnlineStatus(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("_ringyHideOnlineStatus"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    // MARK: Ringing Call
    func isRinging(message: Any) {
        socket.emit("isRinging", with: [message])
    }
        
    func _isRinging(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("_isRinging"){(dataArray, socketAck) -> Void in
            completionHandler(dataArray)
        }
    }
    
    // MARK: Accept Call
    func callAccepted(message: Any) {
        socket.emit("callAccepted", with: [message])
    }
        
    func _callAccepted(completionHandler: @escaping ( _ messageInfo: Any) -> Void){
        socket.on("_callAccepted"){(dataArray, socketAck) -> Void in
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
