//
//  Friend_Data+CoreDataProperties.swift
//  
//
//  Created by Toseef Ahmed on 03/08/2022.
//
//

import Foundation
import CoreData


extension Friend_Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend_Data> {
        return NSFetchRequest<Friend_Data>(entityName: "Friend_Data")
    }

    @NSManaged public var u_id: String?
    @NSManaged public var name: String?
    @NSManaged public var user_img: String?
    @NSManaged public var onlinestatus: Int16
    @NSManaged public var seenstatus: Int16
    @NSManaged public var red_recipt: Int16
    @NSManaged public var pstatus: Int16
    @NSManaged public var lastActive: String?
    @NSManaged public var lastchat: String?
    @NSManaged public var messageType: Int32
    @NSManaged public var lastChatCounter: Int32
    @NSManaged public var ismuted: Int16
    @NSManaged public var isblocked: Int16
    @NSManaged public var ishidden: Int16

}
