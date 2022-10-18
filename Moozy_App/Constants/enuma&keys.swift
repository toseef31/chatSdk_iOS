//
//  enuma&keys.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import SwiftUI

typealias onCompletion<T> = (T?, String?) -> ()
typealias onClick = () -> Void
typealias onChangedValue<T> = ((T) -> ())
let utilityQueue = DispatchQueue.global(qos: .utility)


public enum UserDefaultsKey : String {
    
   
    case fcmToken = "fcmToken"
    case loginUser = "loginUser"
   
    case typingStatus = "typingStatus"
    case OnlineStatus = "OnlineStatus"
    case projectID = "projectID"
    case senderID = "senderID"
    case saveImage = "saveImage"
   
    //Theme
    case app_theme = "app_theme"
    case Blue = "Blue"
    case Pink = "Pink"
    case Green = "Green"
    case Orange = "Orange"
    case Yellow = "Yellow"
    case Purple = "Purple"
    case Red = "Red"
    case Gray = "Grey"
    case White = "White"
}
