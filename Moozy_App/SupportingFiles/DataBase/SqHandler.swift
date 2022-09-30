//
//  SqHandler.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 19/09/2022.
//

import Foundation
import SQLite3
import UIKit


class DatabaseHandler{
    //database name is case sensitive
    let databaseName : String = "MoozyDB" // just name not extension
    var db : OpaquePointer! = nil
    
    init() {
        prepareDatafile()
        db = openDatabase()
    }
    
    //inset Friend Information..
    func inputFriendInformation(Finfo : friendInfoModel)->Bool {
        let query = "insert into Friend_Information(message , messageType,receipt_status,createdAt , messageCounter,friendId , name,profile_image,onlineStatus,ismute) values('\(Finfo.message)','\(Finfo.messageType)','\(Finfo.receipt_status)','\(Finfo.createdAt)','\(Finfo.messageCounter)','\(Finfo.friendId)','\(Finfo.name)','\(Finfo.profile_image)','\(Finfo.onlineStatus)','\(Finfo.ismute)')"
    
          return executeQuery(query: query)
      }
    
    
    //get all FriendList from database
    func  getFriends () -> [friendInfoModel] {
                var friendList : [friendInfoModel] = []
                let queryStatementString = "SELECT * FROM Friend_Information"
                var queryStatement: OpaquePointer? = nil
    
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    // 2
              
                    while  sqlite3_step(queryStatement) == SQLITE_ROW
                    {
    
                        let friendDetail = friendInfoModel()
                        
                        let message = sqlite3_column_text(queryStatement, 0)
                        if(message != nil){
                            friendDetail.message = String(cString: message!)
                        }
                        
                        let messageType = sqlite3_column_int(queryStatement, 1)
                             friendDetail.messageType = Int(messageType)
                        
                        let receipt_status  = sqlite3_column_int(queryStatement, 2)
                        friendDetail.receipt_status = Int(receipt_status)
                        
                        let createdAt = sqlite3_column_text(queryStatement, 3)
                        if(createdAt != nil){
                            friendDetail.createdAt = String(cString: createdAt!)
                        }
                        
                        let messageCounter = sqlite3_column_int(queryStatement, 4)
                             friendDetail.messageCounter = Int(messageCounter)
                       
                        
                        let friendId = sqlite3_column_text(queryStatement, 5)
                        if(friendId != nil){
                            friendDetail.friendId = String(cString: friendId!)
                        }
                        
                        let name = sqlite3_column_text(queryStatement, 6)
                        if(name != nil){
                            friendDetail.name = String(cString: name!)
                        }
                        
                        let profile_image = sqlite3_column_text(queryStatement, 7)
                        if(profile_image != nil){
                            friendDetail.profile_image = String(cString: profile_image!)
                        }
                        
                        
                        let ismute = sqlite3_column_int(queryStatement, 8)
                        friendDetail.onlineStatus =  Int(ismute)
                        
                        let onlineStatus = sqlite3_column_int(queryStatement, 9)
                             friendDetail.ismute = Int(onlineStatus)
                        
                        
                       
                        friendList.append(friendDetail)
                    }
    
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("'get categories failed:\(errmsg)")
                }
                sqlite3_finalize(queryStatement)
                return friendList
    
            }
  
    
    //Delete All friends
    func DeleteAllFriends(){
        let deleteStatementStirng = "DELETE FROM Friend_Information"
            
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Success`fully deleted row.")
                   // print(itemId)
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
    }
    
    func friendRecipt(FriendId: String , reciptStatus: Int)->Bool {
                let query = "UPDATE Friend_Information SET  receipt_status = \(reciptStatus) ,messageCounter ='\(0)' WHERE  friendId ='\(FriendId)'"
                return executeQuery(query: query)
            }
    
    func updateMuteStatus(FriendId: String , mutestatus: Int)->Bool {
                let query = "UPDATE Friend_Information SET  ismute = \(mutestatus) WHERE  friendId ='\(FriendId)'"
                return executeQuery(query: query)
            }
    
    func updatelastsms(FriendId: String , message: String)->Bool {
                let query = "UPDATE Friend_Information SET  message = \(message) ,messageType ='\(0)', messageCounter ='\(0)' WHERE  friendId ='\(FriendId)'"
                return executeQuery(query: query)
            }

    
  ///////not changed
    
    func executeSelect(query: String)->OpaquePointer{
        
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")
        }
        return queryStatement!
    }
    
    func executeQuery(query: String)->Bool{
        
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
            }
            else{
                sqlite3_finalize(queryStatement)
                return true
            }
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    /////////////////////////////
    //Copy database for fist time
    /////////////////////////////
    func prepareDatafile()
    {
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).db")
        
        let localUrl=Bundle.main.url(forResource: databaseName, withExtension: "db")
        print(localUrl?.path ?? "")
        
        let filemanager=FileManager.default
        
        if !FileManager.default.fileExists(atPath: fdoc_url.path){
            do{
               try filemanager.copyItem(atPath: (localUrl?.path)!, toPath: fdoc_url.path)
                
                print("Database copied to simulator-device")
            }catch
            {
                print("error while copying")
            }
        }
        else{
            print("Database alreayd exists in similator-device")
        }
    }
    
    
    
    /////////////////////////////////////
    /////Open Connection to Database
    ////////////////////////////////////
    func openDatabase() -> OpaquePointer? {
        
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).db")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fdoc_url.path, &db) == SQLITE_OK {
            print("DB Connection Opened, Path is :: \(fdoc_url.path)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
        
    }
    
    
}
