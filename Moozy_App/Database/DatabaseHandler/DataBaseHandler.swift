//
//  DataBaseHandler.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 03/08/2022.
//

import Foundation
import CoreData
import UIKit
import CircleProgressView
class dbHelper {
   static var shareInstance = dbHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    
    func save(object: [String:Any]) {
        
        let friendlist = NSEntityDescription.insertNewObject(forEntityName: "Friend_Data", into: context!) as! Friend_Data
        friendlist.u_id = object["u_id"] as? String
        friendlist.name = object["name"] as? String
        friendlist.user_img = object["user_img"] as? String
        friendlist.onlinestatus = object["onlinestatus"] as! Int16
        friendlist.seenstatus = object["seenstatus"] as! Int16
        friendlist.red_recipt = object["red_recipt"] as! Int16
        friendlist.pstatus = object["pstatus"] as! Int16
        friendlist.lastActive = object["lastActive"] as? String
        friendlist.lastchat = object["lastchat"] as? String
        friendlist.messageType = object["messageType"] as! Int32
        friendlist.lastChatCounter = object["lastChatCounter"] as! Int32
        friendlist.ismuted = object["ismuted"] as? String ?? ""
        friendlist.isblocked = object["isblocked"] as? String ?? ""
        friendlist.ishidden = object["ishidden"] as? String ?? ""
        
        do {
            try context?.save()
        }
        catch {
            print("unable to save")
        }
        
    }
    
    func getFriendsData() -> [Friend_Data] {
        var strudnt = [Friend_Data] ()
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Friend_Data")
        do {
            strudnt = try context?.fetch(fetchrequest) as! [Friend_Data]
        }
        catch {
            print("get data")
        }
        return strudnt
    }
    
    
    //get Friends which are not hide
    
    func getUnhideFiend() -> [Friend_Data] {
        var strudnt = [Friend_Data] ()
        let predicate = NSPredicate(format: "ishidden = %@ AND isblocked = %@ AND lastchat != %@ " , "0" , "0" , "")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Friend_Data")
        fetchRequest.predicate = predicate
                            
        do{
            strudnt  = try context?.fetch(fetchRequest) as! [Friend_Data]
            } catch let err {
            print("Error in updating",err)
        }
        return strudnt
    }
    
    func getHiddenFiend(PredictTpe: String? = "") -> [Friend_Data] {
        
        var predicate = NSPredicate(format: "ishidden = %@ " , "1")
      
        switch PredictTpe
        {
         case "Muted Friend":
            predicate = NSPredicate(format: "ismuted = %@ " , "1")
            break
        case "Hidden Fiends":
            predicate = NSPredicate(format: "ishidden = %@ " , "1")
            break
        case "Blocked Friends":
            predicate = NSPredicate(format: "isblocked = %@ " , "1")
            break
        default:
            break
        }
        
        var strudnt = [Friend_Data] ()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Friend_Data")
        fetchRequest.predicate = predicate
                            
        do{
            strudnt  = try context?.fetch(fetchRequest) as! [Friend_Data]
            } catch let err {
            print("Error in updating",err)
        }
        return strudnt
    }
    
    
//    deleteAllfriend(index: Int) -> [Friend_Data]
    
    func deleteSpesificfriend(index: Int) {
        var friend = getFriendsData()
        context?.delete(friend[index])
        friend.remove(at: index)
       
        do {
            try context?.save()
        }
        catch {
            print("canot delete it..")
        }
    }
    //delete all friends
    
    func deleteAllfriend(index: Int) {
        var friend = getFriendsData()
        
        context?.delete(friend[index])
       // friend.removeAll()
       
        do {
            try context?.save()
        }
        catch {
            print("canot delete it..")
        }
    }
    
    
    
    func editFriendData(object: [String:Any], user_id : String){
        var friend = getFriendsData()
        let filteredIndex = friend.firstIndex(where: {$0.u_id == user_id})
        print(object["lastchat"] as? String)
        if filteredIndex != nil {
            friend[filteredIndex!].lastActive = object["lastActive"] as? String
         friend[filteredIndex!].lastchat = object["lastchat"] as? String
            friend[filteredIndex!].messageType = object["messageType"] as! Int32 }
        
        //update all here....
        do {
            try context?.save()
        }
        catch {
            print("data not updatedd ..")
        }
    }
    
    
    func editHidenFriends (object: [String:Any], user_id : String){
        var friend = getFriendsData()
        let filteredIndex = friend.firstIndex(where: {$0.u_id == user_id})
        
        if filteredIndex != nil {
            friend[filteredIndex!].ishidden = object["ishidden"] as? String ?? ""
        }
        do {
            try context?.save()
        }
        catch {
            print("data not updatedd ..")
        }
    
    }
    
    func editMutedFriends (object: [String:Any], user_id : String){
        var friend = getFriendsData()
        let filteredIndex = friend.firstIndex(where: {$0.u_id == user_id})
        
        if filteredIndex != nil {
            friend[filteredIndex!].ismuted = object["ismuted"] as? String ?? ""
        }
        do {
            try context?.save()
        }
        catch {
            print("data not updatedd ..")
        }
    
    }
    
    
    func editBlockFriends (object: [String:Any], user_id : String){
        var friend = getFriendsData()
        let filteredIndex = friend.firstIndex(where: {$0.u_id == user_id})
        
        if filteredIndex != nil {
            friend[filteredIndex!].isblocked = object["isblocked"] as? String ?? ""
        }
        do {
            try context?.save()
        }
        catch {
            print("data not updatedd ..")
        }
    
    }
    
    
    func editReadChatFriends (object: [String:Any], user_id : String  ){
        var friend = getFriendsData()
        let filteredIndex = friend.firstIndex(where: {$0.u_id == user_id})
        
        if filteredIndex != nil {
            print(object["pstatus"])
            friend[filteredIndex!].pstatus = object["pstatus"]  as? Int16 ?? 0
        }
        do {
            try context?.save()
        }
        catch {
            print("data not updatedd ..")
        }
    
    }
    
    
    func cleanAlldata () {
        let contexts = getFriendsData()
          do {
            
            for object in contexts {
                context?.delete(object)
            }
              }
    }
    
}

