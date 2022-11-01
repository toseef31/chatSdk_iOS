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
    static let  ThemeUrl = "https://chat.chatto.jp:20000/themes/"
}
struct SceenSize {
    static var deviceWidth : CGFloat = 0.0
}


struct ConstantStrings {
    
    static let cell = "Cell"
    static let ProjectId = "63183b5bb110c06cb4822451"
    static let projectid = "projectid"
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
            chatOptionsModel(image: UIImage(systemName: "trash"), title: "Clear Chat")
//            chatOptionsModel(image: UIImage(systemName: "photo.on.rectangle"), title: "Chat Background")
        ]
    }
  
    
    struct chatSetting {
        static var options = [
            chatOptionsModel(image: UIImage(systemName: "eye.slash"), title: "Hidden Fiends"),
            chatOptionsModel(image: UIImage(systemName: "smallcircle.filled.circle"), title: "Blocked Friends"),
            chatOptionsModel(image: UIImage(systemName: "speaker"), title: "Muted Friend"),
            chatOptionsModel(image: UIImage(systemName: "bookmark"), title: "BookMarks"),
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
    static let baseURL = "https://chat.chatto.jp:20000/"
    static let setLiveStatus = "profile/changeStatus"
    static let SignUp = "settings/register-user"
    static let markUnread = "meeting/markUnread"
    static let deleteSingleMsg = "meeting/deleteSingleMsg"
    static let sendChat = "meeting/sendChat"
    static let updateMsg = "meeting/updateMsg"
    static let muteFriend = "friends/muteFriend"
    static let blockFriend = "friends/blockFriend"
    //old apis
    static let setOnlineStatus = "setOnlineStatus"
    static let login = "settings/login-user"
    static let getFriends = "friends/chatUserList/"
    static let getusers = "friends/allFriends/"
    static let getChat = "meeting/getChat"
    static let deleteSingleChat = "deleteMsg"
    
    static let unreadAllChat = "unreadAllChat"
    static let readAllChat = "readAllChat"
    static let logoutUser = "profile/logout"
    static let deleteAllChat = "meeting/clearChat"
    static let loggedUser = "business/getloggeduser"
    static let hideUser = "friends/hideFriend"
    
    static let deleteFriend = "friends/deleteFriend"
    
    static let muteFriends  = "friends/muteFriends/"
    static let hideFriends  = "friends/hideFriends/"
    static let blockFriends  = "friends/blockFriends/"
    
    static let getBookmarkChat  = "meeting/getBookmarkChat/"
    static let bookmarkChat  = "meeting/bookmarkChat"
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
    static let primaryColor : UIColor = #colorLiteral(red: 0.9215686275, green: 0.1333333333, blue: 0.1568627451, alpha: 1)
    static let shadoColor : UIColor = #colorLiteral(red: 0.824, green: 0.824, blue: 0.824, alpha: 0.5)
    
    static let btnBackColor : UIColor = #colorLiteral(red: 0.7137254902, green: 0.2470588235, blue: 0.2549019608, alpha: 1)
    static let backColorColor : UIColor = #colorLiteral(red: 0.6862745098, green: 0.4470588235, blue: 0.4156862745, alpha: 0.750080235)
    static let secondaryColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let BlackColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let primaryFontColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let secondaryFontColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let incomingMsgColor : UIColor = #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3764705882, alpha: 0.18)
    static let outgoingMsgColor : UIColor = #colorLiteral(red: 0.9215686275, green: 0.6901960784, blue: 0.2666666667, alpha: 0.23)
    static let ReplyMsgColor : UIColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.968627451, alpha: 1)
    
    
    static let replyLineColor : UIColor = #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3764705882, alpha: 1)
    static let headerMsgColor : UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    
}

struct AppGradentColor {
    static let colorRight : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
    static let colorLeft: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.01708643242)
}


struct AppImages{
    static let back: UIImage = #imageLiteral(resourceName: "Arrow-left-1")
}




struct SocketHelper{
    static let emitStopTyping: String = "stopTyping"
    static let emitIsTyping: String = "isTyping"
    static let onStopTyping: String = "stopTyping"
    static let onTyping: String = "isTyping"
    static let emitsendid: String = "sendid"

    static let o2oUpdateMsg : String =  "o2oUpdateMsg"
    
    static let _o2oUpdateMsg : String = "_o2oUpdateMsg"
    static let user_connected : String = "user_connected"
    static let changestatuslogout : String = "changestatuslogout"
    static let logout : String = "logout"
    static let statusOn : String = "statusOn"
    static let login : String = "login"
    static let receiveid : String = "receiveid"
    static let onlineStatus : String = "onlineStatus"
    static let _o2o : String = "_o2o"
    static let reciverdeletemsg : String = "reciverdeletemsg"
    static let senderdeletemsg : String = "senderdeletemsg"
    static let o2oUpdateReadMsg : String = "o2oUpdateReadMsg"
    static let o2o : String = "o2o"
    static let receivemsg : String = "receivemsg"
    static let receiverUserStatus : String = "receiverUserStatus"
    static let starttyping : String = "starttyping"
    static let stoptyping : String = "stoptyping"
    static let _ringyHideOnlineStatus : String = "_ringyHideOnlineStatus"
    
    
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

protocol ChatItemSelection {
    func AudioSelected(cell: AudioMsgCell)
    func IMGorMapSelected(cell: PhotoMsgCell)
    func VideoSelected(cell: VideoMsgCell)
    func audioCellTap(cell: AudioMsgCell)
    func audioValueChange(cell: AudioMsgCell,valeSlider: Float)
}

struct ThemeConstant {
    static var app_theme = "app_theme"
    static let Blue = "Blue"
    static let Pink = "Pink"
    static let Green = "Green"
    static let Orange = "Orange"
    static let Yellow = "Yellow"
    static let Purple = "Purple"
    static let Red = "Red"
    static let Gray = "Grey"
    static let White = "White"
}

let constatntChatModels = """
 {
                       "repliedTo": null,
                       "message": "632088181ef7ace35eff6ece1666098574911Audio_1666098567232345.m4a",
                       "messageType": 6,
                       "chatType": 0,
                       "status": 1,
                       "seen": 0,
                       "deletedBy": [],
                       "bookmarked": [],
                       "receipt_status": 0,
                       "file_size": "37392",
                       "isread": 0,
                       "_id": "setLastCell",
                       "senderId": {
                           "profile_image": "",
                           "_id": "632088181ef7ace35eff6ece",
                           "name": "kamran"
                       },
                       "receiverId": "6320835d7e9c3ce1572d01eb",
                       "projectId": "63183b5bb110c06cb4822451",
                       "createdAt": "2022-10-18T13:09:34.912Z",
                       "reaction": [],
                       "updatedAt": "2022-10-18T13:09:34.912Z",
                       "__v": 0,
                       "isGroup": 0,
                       "id": "setLastCell"
        }
"""

