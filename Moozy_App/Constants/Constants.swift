//
//  Constants.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

//Size of total Screen..
var sizeScreen: CGSize = .zero
//Attachment
struct attacmentArr {
    var img: UIImage?
    var name: String?
}

struct chatListModel {
    var userImage: UIImage?
    var userName: String?
    var date: String?
    var lastMessage: String?
    var messageUnread: Int?
    var isTyping: Bool?
    var isActive: Bool?
}

struct chatMessage_Model {
    var date: String?
    var status: Int?
    var message: String?
    var messageType: Int?
    var isSender: Int?
    var image: UIImage?
}

struct FrindsNames {
    var names: [String]
}

struct CustomSplash {
    static var isEmoji = false
}
struct profileUrl {
    static let  Url = "https://chat.chatto.jp:20000/profile/"
    
}

struct ConstantStrings {
    
    static let cell = "Cell"
    static let ProjectId = "63183b5bb110c06cb4822451"
    
    struct alertMessage{
        static let alert = "Exceeded Maximum Number Of Selection."
    }
    
    
    struct CustomSplash {
        static let title = "Error"
        static let noInternetConnection = "No Internet Connection"
        static let tryAgain = "Try Again"
    }
    
    struct ErrorString {
        static var general = "Invalid value"
        static var emailError = "Email is not valid"
        static var passwordError = "Password is not Valid"
        static var mobileError = "Phone is not Valid"
    }
    
    struct Login {
        
        static let LoginType = "Login With Email"
        static let wellcome = "Welcome Back! Use your email to log init Moozy."
        static let Email = "Email"
        static let Password = "Password"
        static let UserName = "User Name"
        static let RepeatPassword = "Repeat Password"
        
        static let Login = "LOGIN"
        static let SignUp = "Sign Up"
        static let ForgotPassword = "Forgot Password?"
    }

    struct attacments{
        static let attacmentsname = [
            attacmentArr(img: UIImage(named: "Camera"), name: "From Camera"),
            attacmentArr(img: UIImage(named: "GalleryIcon"), name: "From Gallery"),
            attacmentArr(img: UIImage(named: "Location"), name: "Location"),
            attacmentArr(img: UIImage(named: "Copy"), name: "File")
           
        ]
        
        static let messageActiomName = [
            attacmentArr(img: UIImage(named: "Edit"), name: "Edit"),
            attacmentArr(img: UIImage(named: "Reply-1"), name: "Reply"),
            attacmentArr(img: UIImage(named: "Forward"), name: "Forward"),
            attacmentArr(img: UIImage(named: "Copy"), name: "Copy"),
            attacmentArr(img: UIImage(named: "Unread"), name: "Mark Unread"),
            attacmentArr(img: UIImage(named: "GalleryIcon"), name: "Select"),
            attacmentArr(img: UIImage(named: "trash"), name: "Delete")
        ]
    }
    
    
    struct chatOptions {
        static var options = [
            chatOptionsModel(image: UIImage(systemName: "speaker.slash"), title: "Mute Friend"),
            chatOptionsModel(image: UIImage(systemName: "eye.slash"), title: "Hide Friend"),
            chatOptionsModel(image: UIImage(systemName: "smallcircle.filled.circle"), title: "Block Friend"),
//            chatOptionsModel(image: UIImage(systemName: "arrow.triangle.2.circlepath"), title: "Change Ring"),
            chatOptionsModel(image: UIImage(systemName: "trash"), title: "Delete Chat")
//            chatOptionsModel(image: UIImage(systemName: "photo.on.rectangle"), title: "Chat Background")
        ]
    }
  
    
    struct chatSetting {
        static var options = [
            chatOptionsModel(image: UIImage(systemName: "eye.slash"), title: "Hidden Fiends"),
            chatOptionsModel(image: UIImage(systemName: "smallcircle.filled.circle"), title: "Blocked Friends"),
            chatOptionsModel(image: UIImage(systemName: "speaker"), title: "Muted Friend"),
            chatOptionsModel(image: UIImage(systemName: "circlebadge.fill"), title: "Online Status"),
            chatOptionsModel(image: UIImage(systemName: "pencil"), title: "Typing")
        ]
    }
    
    
    struct chatString {
        static let typing = "Typing..."
        static let delete = "Delete"
        static let hide = "Hide"
        static let pin = "Pin"
        static let read = "Read"
        static let Unread = "Unread"
    }
}

class constants{
    static let projectID = "5d4c07fb030f5d0600bf5c03"
    static let deviceType = "ios"
    static let language = "en"
    static let secretKey = UIDevice.current.identifierForVendor!.uuidString
}

struct systemImage {
    static let search = "magnifyingglass"
    static let read = "text.bubble"
    static let pin = "pin"
    static let delete = "trash"
    static let hide = "eye.slash"
    static let close = "xmark"
    static let logOut = "rectangle.portrait.and.arrow.right"
    static let setting = "gear"
}
struct userImages {
    static var userImage = ""
    static var userImageUrl =  "https://chat.chatto.jp:21000/chatto_images/chat_images/"
}

struct ServiceURL {
    static let SignUp = "settings/register-user"
    
    //old apis
    static let baseURL = "https://chat.chatto.jp:20000/"
    static let setOnlineStatus = "setOnlineStatus"
   // static let login = "business/login"
    static let login = "settings/login-user"
    static let getFriends = "friends/myFriends/"
    static let getusers = "friends/allFriends/"
    static let getChat = "meeting/getChat"
    static let deleteSingleChat = "deleteMsg"
    
    static let unreadAllChat = "unreadAllChat"
    static let readAllChat = "readAllChat"
//    static let deleteAllChat = "deleteAllChat"
    static let deleteAllChat = "meeting/clearChat"
    static let loggedUser = "business/getloggeduser"
    static let hideUser = "friends/hideFriend"
  
}


let scrollLimit = 50
let topTitleHeight: CGFloat = 40
let topFiltersHeight: CGFloat = 55
let bottomFilterHeight: CGFloat = 55
let listItemSize: CGSize = .init(width: 0, height: 45)
let listItemPaddig: UIEdgeInsets = .init(top: 6, left: 10, bottom: 6, right: 10)

let totalWidth = UIScreen.main.bounds.width
let backButtonSize: CGSize = .init(width: 30, height: 25)

struct AppColors {
    static let primaryColor : UIColor = #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3607843137, alpha: 1)
    
    static let btnBackColor : UIColor = #colorLiteral(red: 0.7137254902, green: 0.2470588235, blue: 0.2549019608, alpha: 1)
    static let backColorColor : UIColor = #colorLiteral(red: 0.6862745098, green: 0.4470588235, blue: 0.4156862745, alpha: 0.750080235)
    static let secondaryColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
   
    
    static let primaryFontColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let secondaryFontColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let incomingMsgColor : UIColor = #colorLiteral(red: 1, green: 0.9803921569, blue: 0.937254902, alpha: 1)
    static let outgoingMsgColor : UIColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    
    static let replyLineColor : UIColor = #colorLiteral(red: 0.9882352941, green: 0.6823529412, blue: 0, alpha: 1)
    static let headerMsgColor : UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
   
    
}

struct AppGradentColors {
    static let colorLeft : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4883234767)
    static let colorRight : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.01708643242)
}

struct AppImages{
    static let back: UIImage = #imageLiteral(resourceName: "Arrow-left-1")
}


//Notifications Name With Enums
extension Notification.Name{
    static var selectMessagesAction = Notification.Name("selectMessagesAction")
    static var selectAttachmentAction = Notification.Name("selectAttachmentAction")
    static var close = Notification.Name("close")
    static var selectLocation = Notification.Name("selectLocation")
    static var dowloadFile = Notification.Name("dowloadFile")
    static var dowloadImage = Notification.Name("dowloadImage")
    static var dowloadVedio = Notification.Name("dowloadVedio")
}

let constatntChatModel = """
 {
            "_id": "63286e5b003e18f9cad8c7bb",
            "message": "replied_To_postmanmesage2",
            "messageType": 1,
            "chatType": 0,
            "status": 1,
            "seen": 0,
            "deletedBy": [],
            "bookmarked": [],
            "receipt_status": 0,
            "file_size": "",
            "isread": 0,
            "senderId": {
                "_id": "6320835d7e9c3ce1572d01eb",
                "profile_image": "63287aac37d5acfef58e1a571663597228968passcode.PNG",
                "name": "tajamal1"
            },
            "receiverId": "632088181ef7ace35eff6ece",
            "projectId": "63183b5bb110c06cb4822451",
            "repliedTo": {
                "_id": "63286cf3bee27af93d3692ef",
                "message": "postmanmesage2",
                "messageType": 0,
                "senderId": {
                    "_id": "6320835d7e9c3ce1572d01eb",
                    "profile_image": "63287aac37d5acfef58e1a571663597228968passcode.PNG",
                    "name": "tajamal1"
                }
            },
            "createdAt": "2022-09-19T18:27:55.000Z",
            "reaction": [],
            "updatedAt": "2022-09-20T11:42:44.865Z",
            "__v": 0
        }
"""


protocol ChatItemSelection {
    func AudioSelected(cell: AudioMsgCell)
    func IMGorMapSelected(cell: PhotoMsgCell)
    func VideoSelected(cell: VideoMsgCell)
    func audioCellTap(cell: AudioMsgCell)
    func audioValueChange(cell: AudioMsgCell,valeSlider: Float)
 
}
