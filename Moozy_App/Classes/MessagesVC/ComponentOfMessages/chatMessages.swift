////
////  chatMessages.swift
////  Moozy_App
////
////  Created by Ali Abdullah on 17/05/2022.
////
//
//
//import Foundation
//import UIKit
//import SwiftUI
//import SwipyCell
//import TLPhotoPicker
//import Photos
//import Alamofire
//import SocketIO
//import SimpleTwoWayBinding
//import iRecordView
//import MobileCoreServices
//import QuickLook
//import SDWebImage
//
//var lastsms = 0
//var lastname = ""
//var w = false
//class ChatMessages: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, TLPhotosPickerViewControllerDelegate, TLPhotosPickerLogDelegate, AVAudioRecorderDelegate  {
//
//    private var documents = [Document]()
//    private var sourceType: SourceType!
//
//    private var pickerController: UIDocumentPickerViewController?
//
//    var fileUrl2 :NSURL?
//    var navigationView: UIView?
//    var profileView: ProfileView?
//    var containerView: UIView?
//    var chatBG: UIImageView?
//    var tblChat: UITableView?
//
//    var inputBottomView: UIView?
//    var inputBottomOperationView: UIView?
//    var txtMessage: UITextView?
//    var recordView: RecordView?
//    var btnSend: MoozyActionButton?
//    var btnRecoard: RecordButton?
//    var replayImage = UIImage()
//    var btnView = UIView()
//
//    var receiverID: String?
//    var receiverData: Friend_Data?
//    var isKeyboardShow = false
//
//    var lblOnline: UILabel?
//    var online: UIView?
//
//    var tapPressGesture = UITapGestureRecognizer()
//    var longPressGesture = UILongPressGestureRecognizer()
//    var msgSelectedIndex = IndexPath()
//
//    var imagePicker: UIImagePickerController?
//    var images = [UIImage]()
//    var imageName = [String]()
//    var selectedAssets = [TLPHAsset]()
//
//    var messageAction: PopupMessageAction?
//    var replyView: ReplyView?
//    var statusColor: UIColor?
//    var searchTimer: Timer?
//
//    var audiofilename = ""
//    var audioPlayer: AVAudioPlayer?
//    var recordingSession: AVAudioSession?
//    var audioRecorder: AVAudioRecorder?
//    var audioPLayer :AVAudioPlayer?
//
//    var voicemsgstatus = 0
//
//    var containerViewConstraint: NSLayoutConstraint!
//    var inputBottomViewConstraint: NSLayoutConstraint!
//
//    var viewModel: ChatVM?
//    var chatList: [chatMessage_Model] = []
//
//    var isReply: Bool? = false
//    var EditingEnable :  String? = ""
//    var isdelForward: Bool? = false
//    var isdeleted: Bool? = false
//
//    var isSend: Bool? = false
//    var commentId: String? = ""
//
//    var imageDictionary = [NSURL: UIImage]()
//
//    var TypingStatus = String()
//    var timerSocket: Timer?
//    var typingResponse: Observable<TypingResponse> = Observable()
//
//    var chatMessagesArr = [NewChatMessages]()
//    let HeadercontainerView = UIView()
//    let chatMessages = ChatMessageModel(user_id: "", frind_id: "", message: "", message_Type: 0, status: nil, isSeen: nil, receiptStatus: nil, createdDate: "", hide: nil, sender_id: "", sender_name: "", sender_image: "", receiver_id: "", receiver_name: "", receiver_image: "")
//
//    var anywhereTapGesture: UITapGestureRecognizer!
//    var anywhereTapGesture2: UITapGestureRecognizer!
//
//
//    var sampleviewred4 : UIView?
//    //Buttom Constraint of Tableview.
//    var tblCHatBottomConstraint: NSLayoutConstraint?
//    //Component to delete or forward sms
//    var  BtnForDel : MoozyActionButton?
//    var  btnCancel : MoozyActionButton?
//    var lblForDel : UILabel?
//    var arraySelected = [String]()
//
//    init(receiverData: Friend_Data? = nil) {
//        if let receiver = receiverData {
//            chatMessagesArr.removeAll()
//            self.receiverData = receiver
//            self.receiverID = receiver.u_id ?? ""
//        }
//        viewModel = ChatVM(receiverId: receiverData?.u_id ?? "")
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureUI()
//        dataBinding()
//         backgroundAPI()
//        APIServices.shared.sendDelegate = self
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        notificationListener()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        isKeyboardShow = false
//        self.dismissKeyboard()
//        removeNotificationLestiner()
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override func didReceiveMemoryWarning() {
//        URLCache.shared.removeAllCachedResponses()
//        URLCache.shared.diskCapacity = 0
//        URLCache.shared.memoryCapacity = 0
//    }
//
//    @objc func backgroundAPI(){
//        DispatchQueue.main.async { [self] in
//            getChat()
//            getChatMessageLocal()
//        }
//    }
//
//    //MARK: -- initializedControls--
//    func initializedControls(){
//        socketConnected()
//
//        view.backgroundColor = .white
//        configureNavitionView()
//        configureTableView()
//        configureInputView()
//
//        chatBG = UIImageView(image: UIImage(named: "wallpaper2")!, contentModel: .scaleAspectFill)
//        containerView = UIView(backgroundColor: UIColor.white, maskToBounds: true)
//        containerView?.roundCorners(corners: [.topLeft, .topRight], radius: 10, clipToBonds: true)
//        self.replyView?.isHidden = true
//    }
//
//    //MARK: -- Configure UI
//    func configureUI(){
//        initializedControls()
//
//        view.addMultipleSubViews(views: navigationView!, containerView!)
//
//        containerView?.addMultipleSubViews(views: chatBG!, tblChat!,inputBottomView!,inputBottomOperationView!)
//
//        inputBottomOperationView?.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 100))
//
//        navigationView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//
//        navigationView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
//
//        containerView?.anchor(top: navigationView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -7, left: 0, bottom: 0, right: 0))
//
//        containerViewConstraint = containerView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        containerViewConstraint.isActive = true
//
//        chatBG?.fillSuperView()
//
//        inputBottomView?.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 5, right: 12))
//
//        inputBottomViewConstraint = inputBottomView?.heightAnchor.constraint(equalToConstant: 50)
//        inputBottomViewConstraint.isActive = true
//
//        inputBottomOperationView?.isHidden = true
//
//
////        tblChat?.anchor(top: containerView?.topAnchor, leading: containerView?.leadingAnchor, bottom: inputBottomView?.topAnchor, trailing: containerView?.trailingAnchor, padding: .init(top: -2, left: 0, bottom: 34, right: 0))
//
//        tblChat?.anchor(top: containerView?.topAnchor, leading: containerView?.leadingAnchor, bottom: nil , trailing: containerView?.trailingAnchor, padding: .init(top: -2, left: 0, bottom: 0, right: 0))
//
//        tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//        tblCHatBottomConstraint?.isActive = true
//
//        view.bringSubviewToFront(containerView!)
//        containerView?.bringSubviewToFront(navigationView!)
//
//        containerView?.bringSubviewToFront(inputBottomView!)
//        inputBottomView?.bringSubviewToFront(tblChat!)
//
//        chatBG?.isHidden = true
//        replayImage = createImage(txt: "", img: UIImage(named: "reply")!, size: 55.0)
//    }
//
//    //MARK: -- configure Navigation View
//    func configureNavitionView(){
//        navigationView = {
//            let view = UIView(backgroundColor: AppColors.primaryColor, maskToBounds: true)
//            statusColor = receiverData?.onlinestatus == 1 ? .green : .red
//            online = UIView(backgroundColor: statusColor!, cornerRadius: 4)
//
//            let statusOnline = receiverData?.onlinestatus == 1 ? "online" : "\(getMsgDate(date: receiverData?.lastActive ?? ""))"
//
//            lblOnline = UILabel(title: "\(statusOnline)", fontColor: AppColors.secondaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 11))
//
//            online?.constraintsWidhHeight(size: .init(width: 8, height: 8))
//
//            let stackss = UIStackView(views: [online!, lblOnline!], axis: .horizontal, spacing: 2)
//
//
//            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) { [self] in
//                print("Back")
//                let vm = ChatListVM()
//
//                if let last = chatMessagesArr.last {
//                    let frindsList = AppUtils.shared.allUsers
//                    let index = frindsList?.firstIndex(where: {$0.friend.userId == receiverData?.u_id })
//                    if index != nil {
//                        if frindsList?[index!].friend.name == receiverData?.name {
//                    frindsList?[index!].messageType = last.messages.last?.messageType
//                    frindsList?[index!].lastChat = last.messages.last?.message
//                        }
//                    }
//                    UserDefaults.removeSpecificKeysValues(key: .allUsers)
//                    AppUtils.shared.saveAllUser(user: frindsList)
//
//                }
//
//                self.pop(animated: true)
//            }
//
//            profileView = ProfileView(title: "\(receiverData?.name?.checkNameLetter() ?? "")", font: UIFont.font(.Poppins, type: .Medium, size: 14), BGcolor: UIColor.clear, titleFontColor: UIColor.white, borderColor: AppColors.secondaryColor.cgColor, borderWidth: 1, size: .init(width: 30, height: 30))
//
//            var url = "https://chat.chatto.jp:21000/chatto_images/chat_images/"
//            let image =  receiverData?.user_img ?? nil
//            if image != "" && image != nil {
//
//                let imgUrl = url
//                if let url = URL(string: imgUrl){
//                    profileView?.profileImagesss = "\(url)\(receiverData?.user_img ?? "")"
//                    //imgTitle?.profileImagesss = "\(url)\(dataSet?.friend.user_image ?? "")"
//                }else {
//                    profileView?.titleProfile = receiverData?.name != "" ? (receiverData?.name?.checkNameLetter()) : "No Name".checkNameLetter()
//                 }
//                profileView?.titleProfile = ""
//            } else {
//                profileView?.titleProfile = receiverData?.name != "" ? (receiverData?.name?.checkNameLetter()) : "No Name".checkNameLetter()
//
//            }
//
//
//            profileView?.isBound = true
//            profileView?.titleProfile = receiverData?.name?.checkNameLetter() ?? ""
//
//            let lblUserName = UILabel(title: "\(receiverData?.name?.capitalizingFirstLetter() ?? "")", fontColor: AppColors.secondaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .SemiBold, size: 12))
//
//            let statusOnlineStack = UIStackView(views: [lblUserName, stackss], axis: .vertical, spacing: 2)
//
//            let btnOptions = MoozyActionButton(image: UIImage(named: "MoreOption"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear, imageSize: .init(width: 25, height: 15)) { [self] in
//
//                self.replyView?.isHidden = true
//                //update table view..
//                tblCHatBottomConstraint?.isActive = false
//                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//                tblCHatBottomConstraint?.isActive = true
//
//
//                //self.pushTo(viewController: ChatDetailVC(receiverData: receiverData))
//            }
//
//            btnOptions.constraintsWidhHeight(size: .init(width: 25, height: 15))
//            let stack = UIStackView(views: [btnOptions], axis: .horizontal, distribution: .fill)
//
//            view.addMultipleSubViews(views: btnBack, profileView!, statusOnlineStack, stack)
//
//            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: backButtonSize)
//
//            profileView?.anchor(top: nil, leading: btnBack.trailingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 20, right: 0), size: .init(width: 30, height: 30))
//            btnBack.verticalCenterWith(withView: profileView!)
//
//            statusOnlineStack.anchor(top: nil , leading: profileView?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
//
//            statusOnlineStack.verticalCenterWith(withView: profileView!)
//
//            //stackss.anchor(top: lblUserName.bottomAnchor, leading: lblUserName.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
//
//            stack.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12))
//            stack.verticalCenterWith(withView: profileView!)
//                  return view
//        }()
//    }
//
//    //MARK: configure Input View--
//    func configureInputView(){
//
//        inputBottomOperationView = {
//            let Deleteview = UIView(backgroundColor: #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.7137254902, alpha: 1), cornerRadius: 0, maskToBounds: true)
//              BtnForDel = MoozyActionButton(image: UIImage(systemName: "trash"), foregroundColor: .white ,imageSize: .init(width: 25, height: 25)) { [self] in
//
//                  arraySelected.forEach { da in
//                      print(da)
//                  }
//
//
//                  print(arraySelected.count)
//
//                inputBottomOperationView?.isHidden = true
//                inputBottomView?.isHidden = false
//                  tblCHatBottomConstraint?.isActive = false
//                  tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//                  tblCHatBottomConstraint?.isActive = true
//                  isdelForward = false
//                  tblChat?.reloadData()
//              }
//
//           // (systemName: systemImage.close)
//             lblForDel = UILabel(title:  "Delete", fontColor:  .white, alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Medium, size: 14))
//              btnCancel = MoozyActionButton(image: UIImage(systemName: systemImage.close), foregroundColor: .white ,imageSize: .init(width: 25, height: 25)) { [self] in
//
//                  tblCHatBottomConstraint?.isActive = false
//                  tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//                  tblCHatBottomConstraint?.isActive = true
//                inputBottomOperationView?.isHidden = true
//                inputBottomView?.isHidden = false
//                  isdelForward = false
//                  tblChat?.reloadData()
//
//            }
//
//            let stack = UIStackView(views: [BtnForDel!, lblForDel!,btnCancel!], axis: .horizontal, spacing: 8, distribution: .fill)
//
//            Deleteview.addSubview(stack)
//            stack.fillSuperView(padding: .init(top: 10, left: 10, bottom: 20, right: 10))
//
//            return Deleteview
//
//        }()
//
//        inputBottomView = {
//
//            let view = UIView(backgroundColor: #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1), cornerRadius: 25, maskToBounds: true)
//
//            let userImage = ProfileView(font:  UIFont.font(.Poppins, type: .Medium, size: 14), BGcolor: AppColors.primaryColor, titleFontColor: AppColors.secondaryColor, borderColor: AppColors.primaryFontColor.cgColor , borderWidth: 1,  size: .init(width: 22, height: 22))
//
//
//            let url = "https://chat.chatto.jp:21000/chatto_images/chat_images/"
//            print(userImages.userImage )
//            let img = userImages.userImage
//
//            let image = "\(url)\(userImages.userImage)"
//            if img != "" {
//
//                    if image != "" && image != nil {
//
//                        let imgUrl = "\(url)\(userImages.userImage)"
//
//                        if let url = URL(string: imgUrl ?? ""){
//                            userImage.profileImagesss = imgUrl
//                         } else {
//                             userImage.isBound = true
//                             let name = AppUtils.shared.user?.name ?? ""
//                             userImage.titleProfile =  name != "" ? name.checkNameLetter() : "N".checkNameLetter()
//                         }
//                    }
//            } else {
//                    userImage.isBound = true
//                    let name = AppUtils.shared.user?.name ?? ""
//                userImage.titleProfile =  name != "" ? name.checkNameLetter() : "N".checkNameLetter()
//
//                }
//
//            txtMessage = {
//                let txt = UITextView()
//                txt.text = "Enter Message"
//                txt.textColor = AppColors.primaryColor
//                txt.allowsEditingTextAttributes = true
//                txt.showsVerticalScrollIndicator = false
//                txt.backgroundColor = UIColor.clear
//                txt.font = UIFont.font(.Poppins, type: .Regular, size: 12)
//                txt.isScrollEnabled = false
//                txt.delegate = self
//                return txt
//            }()
//
//            btnSend = MoozyActionButton(image: UIImage(systemName: "paperplane"), imageSize: .init(width: 40, height: 20)) { [self] in
//                 w = true
//                DispatchQueue.main.async { [self] in
//                    if txtMessage!.text.trimmingCharacters(in: .whitespaces).isEmpty {
//                        print("Not send")
//                    }else{
//                         lastsms = 1
//                        lastname = receiverData?.name ?? ""
//                        let chatType = isReply == true ? 1 : 0
//                        let commentId = commentId == "" ? "" : commentId
//
//                        if txtMessage?.text != ""{
//                            EditingEnable = ""
//                            sendMessage(message: "\(txtMessage?.text ?? "")", chatType: chatType, messageType: 0, commentId: commentId, selectedUserData: receiverData?.u_id ?? "")
//                            DispatchQueue.main.async { [self] in
//                                txtMessage?.text = ""
//                                btnSend?.isEnabled = true
//                                self.isReply = false
//                                self.commentId = ""
//                                self.replyView?.isHidden = true
//                                //update table view..
//                                tblCHatBottomConstraint?.isActive = false
//                                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//                                tblCHatBottomConstraint?.isActive = true
//                            }
//                        }
//                    }
//                }
//            }
//
//            recordView = {
//                let view = RecordView()
//                view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1)
//                view.layer.cornerRadius = 5
//                view.delegate = self
//                return view
//            }()
//
//
//            btnRecoard = {
//                let btn = RecordButton()
//                btn.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
//                btn.recordView = self.recordView
//                return btn
//            }()
//
//            let btnAttachment = MoozyActionButton(image: UIImage(systemName: "paperclip"), backgroundColor: UIColor.clear, imageSize: .init(width: 40, height: 20)) { [self] in
//                self.dismissKeyboard()
//                self.replyView?.isHidden = true
//                //update table view..
//                tblCHatBottomConstraint?.isActive = false
//                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//                tblCHatBottomConstraint?.isActive = true
//
//                self.ShowPopUp(PopView: PopUpAttachmentView())
//            }
//
//            btnSend?.tint = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//            btnRecoard?.constraintsWidhHeight(size: .init(width: 15, height: 30))
//            btnSend?.constraintsWidhHeight(size: .init(width: 40, height: 20))
//
//            btnView = UIView(backgroundColor: .white, cornerRadius: 5)
//            let stackButton = UIStackView(views: [btnRecoard!, btnSend!], axis: .horizontal)
//
//            view.addMultipleSubViews(views: userImage, txtMessage!, btnAttachment, recordView!, btnView)
//            btnView.addSubview(stackButton)
//
//            userImage.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
//
//            userImage.verticalCenterWith(withView: view)
//
//            btnView.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 35, height: 35))
//            btnView.verticalCenterWith(withView: view)
//            btnView.layer.cornerRadius = 35/2
//
//            stackButton.centerSuperView()
//
//            btnAttachment.anchor(top: nil, leading: nil, bottom: nil, trailing: btnView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 40, height: 20))
//            btnAttachment.verticalCenterWith(withView: btnView)
//
//            txtMessage?.anchor(top: view.topAnchor, leading: userImage.trailingAnchor, bottom: view.bottomAnchor, trailing: btnAttachment.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
//
//            recordView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: btnView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4))
//
//            btnSend?.isHidden = true
//            recordView?.isHidden = true
//            return view
//        }()
//    }
//
//    //MARK: --Configure TableView--
//    func configureTableView(){
//        tblChat = UITableView(frame: .zero, style: .plain)
//
//        tblChat?.register(DisclaimerCell.self, forCellReuseIdentifier: "Cell")
//        tblChat?.register(TextMsgCell.self, forCellReuseIdentifier: "Cell1")
//        tblChat?.register(PhotoMsgCell.self, forCellReuseIdentifier: "Cell2")
//        tblChat?.register(ReplyViewCell.self, forCellReuseIdentifier: "Cell3")
//        tblChat?.register(LocationMsgCell.self, forCellReuseIdentifier: "Cell4")//LocationMsgCell
//        tblChat?.register(VideoMsgCell.self, forCellReuseIdentifier: "Cell5")//LocationMsgCell
//        tblChat?.register(AudioMsgCell.self, forCellReuseIdentifier: "Cell6")//AudioMsgCell
//        tblChat?.register(FileMsgCell.self, forCellReuseIdentifier: "Cell7") //FileMsgCell
//        tblChat?.delegate = self
//        tblChat?.dataSource = self
//        tblChat?.backgroundColor = .clear
//        tblChat?.separatorStyle = .none
//        tblChat?.keyboardDismissMode = .onDrag
//        tblChat?.showsVerticalScrollIndicator = false
//        tblChat?.allowsMultipleSelectionDuringEditing = true
//
//        tblChat?.backgroundView = UIImageView(image: UIImage(named: "Chat_BG"))
//
//    }
//
//    //MARK: --Resize TextView to default size
//    private func didFinishedSendingMessage() {
//        DispatchQueue.main.async { [self] in
//            self.txtMessage?.isScrollEnabled = false
//            //            self.replyView?.isHidden = true
//            if isKeyboardShow != true{
//                self.txtMessage?.text = "Enter Message"
//            }
//            //            self.txtMessage?.text = isKeyboardShow == false ? "" : "Enter Message"
//            self.txtMessage?.textColor = isKeyboardShow == true ? .black: AppColors.primaryColor
//            self.inputBottomViewConstraint.constant = 50.0
//            self.inputBottomViewConstraint.isActive = true
//
//            self.inputBottomView?.layoutIfNeeded()
//            self.inputBottomView?.layoutSubviews()
//            self.inputBottomView?.setNeedsDisplay()
//            if chatMessagesArr.count > 1 {
//                self.tblChat?.scrollToBottom()
//            }
//        }
//    }
//
//    //MARK: -- DataBinding
//    func dataBinding(){
//        viewModel?.allChatMessage.bind(observer: { [self] chat, _ in
//            didFinishedSendingMessage()
//            tblChat?.reloadData()
//        })
//
//        viewModel?.isAllChat.bind(observer: { [self] observable, _ in
//            didFinishedSendingMessage()
//            tblChat?.reloadData()
//        })
//
//        viewModel?.AllChatMessage.bind(observer: { [self] data, _ in
//            self.tblChat?.scrollToBottom()
//            didFinishedSendingMessage()
//            tblChat?.reloadData()
//        })
//    }
//
//
//    //MARK: -- txcation Listener
//    func notificationListener(){
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessages.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessages.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
////
////        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessages.selectMessageObjectRecevied(_:)), name: .selectMessagesAction, object:nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessages.attchmentIndexreceiver(_:)), name: .selectAttachmentAction, object:nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessages.closeReplyView(_:)), name: .close, object:nil)
//
//
//    }
//
//    func removeNotificationLestiner(){
//        NotificationCenter.default.removeObserver(self, name: UITextView.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .selectMessagesAction, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .selectAttachmentAction, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .close, object: nil)
//    }
//
//
//
//    func mediaUploadObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadMessagesTableView), name: NSNotification.Name(rawValue: "ShowMediaUploadObserver"), object: nil)
//    }
//
//    @objc func reloadMessagesTableView(notification: NSNotification) {
//        if let uploadedProgress = notification.userInfo?["uploaded"] as? Double, let fileName = notification.userInfo?["fileName"] as? String {
//        outerLoop: for section in 0..<chatMessagesArr.count {
//            for index in 0..<chatMessagesArr[section].messages.count {
//                if chatMessagesArr[section].messages[index].message == fileName {
//                    chatMessagesArr[section].messages[index].uploadedProgress = uploadedProgress
//                    if tblChat!.hasRowAtIndexPath(indexPath: IndexPath(row: index, section: section)) {
//                        DispatchQueue.main.async {
//                            self.tblChat?.reloadRows(at: [IndexPath(row: index, section: section)], with: .none)
//                        }
//                    }
//                    break outerLoop
//                }
//            }
//        }
//        }
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowMediaUploadObserver"), object: nil)
//        mediaUploadObserver()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
////MARK: -- uitableview Delegates Functions
//extension ChatMessages: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        print(chatMessagesArr.count)
//        if chatMessagesArr.count == 0{
//            return 0
//        }else{
//            return chatMessagesArr.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return nil
//
//        }else {
//           // let headerView = UIView(backgroundColor: .clear)
//
//            let views = UIView(backgroundColor:  AppColors.incomingMsgColor)
//            let lblStoreName = UILabel(title:  chatMessagesArr[section].date, fontColor:  AppColors.primaryColor, alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Medium, size: 14))
//            HeadercontainerView.addSubview(views)
//            views.anchor(top: nil, leading: nil, bottom: nil , trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 91, height: 23))
//            views.roundCorners(corners: .allCorners, radius: 11 , clipToBonds: true)
//            views.horizontalCenterWith(withView: HeadercontainerView)
//            views.verticalCenterWith(withView: HeadercontainerView)
//            views.addSubview(lblStoreName)
//
//            lblStoreName.anchor(top: views.topAnchor, leading: views.leadingAnchor, bottom: views.bottomAnchor, trailing: views.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//
//            return HeadercontainerView
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatMessagesArr[section].messages.count ?? 0
//
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0, indexPath.section == 0 {
//            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell") as! DisclaimerCell
//            cell.selectionStyle = .none
//            return cell
//        }else{
//
//            if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0) {
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell1") as! TextMsgCell
//                cell.selectionStyle = .none
//                cell.isdelForward = isdelForward
//                cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//                    configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                cell.mainView?.applyBottomShadow()
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//
//                return cell
//            }else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 1 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
//                cell.isdelForward = isdelForward
//                //tblChat?.dequeueReusableCell(withIdentifier:"Cell2" ,for: indexPath) as! PhotoMsgCell
//                // tblChat?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
//                print(chatMessagesArr[indexPath.section].messages[indexPath.row].messageType)
//                cell.selectionStyle = .none
//                cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//                configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                //configureCell(cell, forRowAtIndexPath: indexPath)
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//
//
//                return cell
//            }else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 1){
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell3") as! ReplyViewCell
//                cell.isdelForward = isdelForward
//                cell.selectionStyle = .none
//                cell.dataSet = chatMessagesArr[indexPath.section].messages[indexPath.row]
//               // configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                cell.mainView?.applyBottomShadow()
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//                return cell
//            }
//
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 5 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell5") as! VideoMsgCell
//                cell.isdelForward = isdelForward
//                cell.selectionStyle = .none
//                cell.delegates = self
//                cell.dataSet = chatMessagesArr[indexPath.section].messages[indexPath.row]
//               // configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//                return cell
//
//            }
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 6 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell6") as! AudioMsgCell
//                cell.isdelForward = isdelForward
//                cell.selectionStyle = .none
//                cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//                //cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//                //configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                cell.mainView?.applyBottomShadow()
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//                return cell
//            }
//
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 2 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell7") as! FileMsgCell
//                cell.isdelForward = isdelForward
//                cell.selectionStyle = .none
//                cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//               // if chatMessages
//             if   chatMessagesArr[indexPath.section].isDowloading {
//                    print("Downloading")
//                 cell.activityIndicator.startAnimating()
//                }
//                else{
//                    print("NotDownloading")
//                    cell.activityIndicator.stopAnimating()
//               //     chatMessagesArr[indexPath.section].isDowloading = true
//                }
//                cell.actionSetSort = { sdf in
//                    print(indexPath.row)
//                    print("click to download...")
//                }
//                //cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//                //configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                cell.mainView?.applyBottomShadow()
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//                return cell
//            }else{
//                let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell4") as! LocationMsgCell
//                cell.selectionStyle = .none
//                cell.isdelForward = isdelForward
//                cell.chatData = chatMessagesArr[indexPath.section].messages[indexPath.row]
//              //  configureCell(cell, forRowAtIndexPath: indexPath)
//                cell.backgroundColor = UIColor.clear
//                //for blurr
//                let interaction = UIContextMenuInteraction(delegate: self)
//                cell.mainView?.addInteraction(interaction)
//                cell.mainView?.isUserInteractionEnabled = true
//                return cell
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPathe = tblChat?.indexPathForSelectedRow //optional, to get from any UIButton for example
// print(chatMessagesArr[indexPath.section].messages[indexPath.row]._id)
//
//        arraySelected.append(chatMessagesArr[indexPath.section].messages[indexPath.row]._id)
//
//        if isdelForward! {
//            if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 1 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! PhotoMsgCell
//                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                currentCell.ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            }
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! TextMsgCell
//                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                currentCell.ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            }
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 1){
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! ReplyViewCell
////                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
////                currentCell.ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//                //replycell
//            }
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 6 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0) {
//                //aUDIO
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! AudioMsgCell
//                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                currentCell.imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            }
//
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 2 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! FileMsgCell
//                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                currentCell.imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//                //file
//            }
//            else{
////                location
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! LocationMsgCell
//                currentCell.imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                currentCell.imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            }
//
//
//
//        }
//        else {
//            //
//       // let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell7") as! FileMsgCell
//
//
//        if indexPath.row == 0, indexPath.section == 0{
//
//        }else{
//            if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0) {
//
//
//            }else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 1 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//
//
//                let indexPathe = tblChat?.indexPathForSelectedRow //optional, to get from any UIButton for example
//
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! PhotoMsgCell
//
//                let cellImage = AppUtils.shared.loadImage(fileName: chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "")
//                if cellImage != nil{
//                    viewImage(indexPath: indexPath)
//
//                }
//                else{
//                    currentCell.imgdownloadFile.isHidden = true
//                    currentCell.activityIndicator.startAnimating()
//
//                    print(chatMessagesArr[indexPath.section].messages[indexPath.row].receiverId._id)
//                   // NotificationCenter.default.post(name: .dowloadImage, object: nil, userInfo: [ "downlaodImages" : chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "" ])
//
//                    NotificationCenter.default.post(name: .dowloadImage, object: nil, userInfo: [ "downlaodImages" : chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "" , "ReciverId" : chatMessagesArr[indexPath.section].messages[indexPath.row].receiverId._id ?? ""  , "SenderId" : chatMessagesArr[indexPath.section].messages[indexPath.row].senderId._id ?? "" ])
//
//
//
//
//
//                }
//            }else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 1){
//
//
//
//
//
//            }else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 6 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//
//            }
//
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 2 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//
//                let indexPathe = tblChat?.indexPathForSelectedRow //optional, to get from any UIButton for example
//
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! FileMsgCell
//
//
//               print("oPEN Files Here....")
//
//                var docPath =  DownloadData.sharedInstance.searchFileExist(fileName: chatMessagesArr[indexPath.section].messages[indexPath.row].message, fileType: 2)
//               currentCell.imgdownloadFile.isHidden = true
//
//                if docPath == "" || docPath == nil {
//                    currentCell.activityIndicator.startAnimating()
//
//                    NotificationCenter.default.post(name: .dowloadFile, object: nil, userInfo: [ "downlaodFile" : chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "" , "ReciverId" : chatMessagesArr[indexPath.section].messages[indexPath.row].receiverId._id ?? ""  , "SenderId" : chatMessagesArr[indexPath.section].messages[indexPath.row].senderId._id ?? "" ])
//
//                   // NotificationCenter.default.post(name: .dowloadFile, object: nil, userInfo: [ "deleteMinimizer": chatMessagesArr[indexPath.section].messages[indexPath.row].message ])
//
//                }
//                else{
//                    currentCell.activityIndicator.stopAnimating()
//                    docPath = "file://" + docPath!
//                    fileUrl2 = NSURL(string: docPath!)
//                    let quickLookViewController = QLPreviewController()
//                    quickLookViewController.dataSource = self
//                    self.present(quickLookViewController, animated: true, completion: nil)
//                }}
//
//            else if (chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 5 && chatMessagesArr[indexPath.section].messages[indexPath.row].chatType == 0){
//
//                let indexPathe = tblChat?.indexPathForSelectedRow //optional, to get from any UIButton for example
//                let currentCell = tblChat?.cellForRow(at: indexPathe!) as! VideoMsgCell
//
//                print(indexPath.section)
//                print(indexPath.row)
//
//
//                let videoUrl = DownloadData.sharedInstance.searchFileExist(fileName:  chatMessagesArr[indexPath.section].messages[indexPath.row].message , fileType: 5)
////             let  vedioUrls = videoUrl ?? ""
////                print(videoUrl)
////
////                print(vedioUrls)
////
//
//                if videoUrl == nil{
//                    currentCell.imgdownloadFile.isHidden = true
//                    currentCell.btnVideoPlay?.isHidden = true
//                    currentCell.activityIndicator.isHidden = false
//                    currentCell.activityIndicator.startAnimating()
//
//                    NotificationCenter.default.post(name: .dowloadVedio, object: nil, userInfo: [ "downlaodVideo" : chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "" , "ReciverId" : chatMessagesArr[indexPath.section].messages[indexPath.row].receiverId._id ?? ""  , "SenderId" : chatMessagesArr[indexPath.section].messages[indexPath.row].senderId._id ?? "" , "indexPathrow" : "\(indexPathe?.row)" , "indexPathSection" : "\(indexPathe?.section)"])
//
//
//                } else{
//
//                let UrlVedio = "https://chat.chatto.jp:21000/chatto_images/chat_images/" + (chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "")
//                self.pushTo(viewController: playVedioVC(data: nil, index: 0, vedioUrl: UrlVedio))
//                }
//
//            }
//            else{
//                viewImage(indexPath: indexPath)
//            }
//        }
//    }
//    }
//
//}
//
//
////MARK: - --Swip TableViewCell Delegate
//extension ChatMessages: SwipyCellDelegate{
//
//    func swipyCellDidStartSwiping(_ cell: SwipyCell) {
//
//    }
//
//    func swipyCellDidFinishSwiping(_ cell: SwipyCell, atState state: SwipyCellState, triggerActivated activated: Bool) {
//        if activated{
//            if let indexPath = tblChat?.indexPath(for: cell) {
//                print(indexPath)
//                isReply = true
//                setUpReplayView(index: indexPath)
//            }
//        }
//    }
//
//    func swipyCell(_ cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat, currentState state: SwipyCellState, triggerActivated activated: Bool) {
//
//    }
//
//    func configureCell(_ cell: SwipyCell, forRowAtIndexPath indexPath: IndexPath) {
//        let checkView = viewWithImageName("reply")
//        let clearColor = UIColor.white
//        cell.delegate = self
//        cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: clearColor, completion: { cell, trigger, state, mode in
//        })
//    }
//
//    func viewWithImageName(_ imageName: String) -> UIView {
//        let image = UIImage(named: imageName)?.imageWithColor(color1: AppColors.primaryColor)
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .center
//        return imageView
//    }
//}
//
////MARK: - UITextView Delegate
//extension ChatMessages: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        txtMessage?.text = ""
//        textView.textColor = UIColor.black
//        btnSend?.isHidden = false
//        btnRecoard?.isHidden = true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        btnSend?.isHidden = true
//        btnRecoard?.isHidden = false
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//
//        txtMessage?.text = "\(textView.text ?? "")"
//
//        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
//            self.btnSend?.isEnabled = false
//
//        }else {
//            self.btnSend?.isEnabled = true
//        }
//
//        if textView.contentSize.height >= 100 { // Max height of textView
//            textView.isScrollEnabled = true
//
//        } else {
//            textView.frame.size.height = textView.contentSize.height
//            textView.isScrollEnabled = false
//        }
//
//        if textView.numberOfLines() < 7 && textView.numberOfLines() > 1 {
//            textView.sizeToFit()
//            let letterheightheight = textView.frame.height
//            inputBottomViewConstraint.constant = letterheightheight + 20
//            inputBottomViewConstraint.isActive = true
//            textView.isScrollEnabled = true
//        }
//        else if textView.numberOfLines() == 1{
//            textView.isScrollEnabled = false
//            inputBottomViewConstraint.constant = 50
//            inputBottomViewConstraint.isActive = true
//        }else{
//            textView.isScrollEnabled = true
//        }
//    }
//}
//
////MARK: - ReplyView setUp UI
//extension ChatMessages{
//    func setUpReplayView(index: IndexPath){
//
//        commentId = ""
//        self.replyView?.isHidden = true
//        self.txtMessage?.becomeFirstResponder()
//
//        let data = chatMessagesArr[index.section].messages[index.row]
//
//        var decMessage = ""
//        let msg = data.message ?? ""+""
//        let key = data.senderId._id ?? ""  // length == 32
//        let test = ""
//        var  ivStr = key + test
//        let halfLength = 16 //receiverId.count / 2
//        let index1 = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
//        ivStr.insert("-", at: index1)
//        let result = ivStr.split(separator: "-")
//        let iv = String(result[0])
//        let s =  msg
//        print("my sec id is auvc \(s)")
//        do{
//            decMessage = try s.aesDecrypt(key: key, iv: iv)
//        }catch( let error ){
//            print(error)}
//        print("DENCRYPT",decMessage)
//
//        commentId = "6284e9ef324283a79dfb0458"
//
//        if data.messageType == 0{
//            replyView = ReplyView(title: "\(data.senderId.name?.capitalizingFirstLetter() ?? "")", message: "\(data.message ?? "")", image: nil, titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
//                self.replyView?.isHidden = true
//            }
//        }else{
//            replyView = ReplyView(title: "\(data.senderId.name?.capitalizingFirstLetter() ?? "")", message: "\(data.message ?? "")", image: UIImage(named: "profile3"), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
//                self.replyView?.isHidden = true
//            }
//        }
//
//        ReplyView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: { [self] in
//            self.containerView?.addSubview(self.replyView!)
//             replyView?.anchor(top: nil, leading: inputBottomView?.leadingAnchor, bottom: inputBottomView?.topAnchor, trailing: inputBottomView?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 0), size: .init(width: 0, height: 60))
//            //update table view..
//            tblCHatBottomConstraint?.isActive = false
//            tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: replyView!.topAnchor, constant: -20)
//            tblCHatBottomConstraint?.isActive = true
//
//        })
//    }
//}
//
//
//extension ChatMessages{
//
//    @objc func attchmentIndexreceiver(_ sender: Notification){
//        guard let userInfo = sender.userInfo,
//              let index = userInfo["select"] as? Int else{ return }
//
//        switch index {
//        case 0:
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePicker = UIImagePickerController()
//                imagePicker?.delegate = self
//                imagePicker?.sourceType = .camera;
//                imagePicker?.allowsEditing = false
//                self.present(imagePicker!, animated: true, completion: nil)
//            }
//            break
//        case 1:
//            imagesConfig()
//            break
//        case 2:
//            isSend = true
//            perform(#selector(MapVC), with: nil, afterDelay: 0)
//            break
//        case 3:
//           // isSend = true
//            self.folderAction()
//            print("filess")
//        default:
//            break
//        }
//    }
//
//    @objc func MapVC(){
//        let vc = LocationVC()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        self.images.removeAll()
//        imagePicker?.dismiss(animated: true, completion: nil)
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            return
//        }
//        UserDefaults.standard.set(0.0, forKey: "uploadProgress")
//        let fixOrientationImage = selectedImage.fixedOrientation()
//        let compressimg = fixOrientationImage.checkimgsize()
//        let timestamp = NSDate().timeIntervalSince1970
//        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//        timestampname = timestampname + ".png"
//
//        print("image: \(compressimg)")
//        print("imageName : \(timestampname)")
//
//
//        //let imageData = UIImageJPEGRepresentation(newImage!, 0.1)! as Data
//
//         let imageData = compressimg.compressimage(.low)
//
//
//        APIServices.shared.sendFiles(image: imageData, fileName: "\(timestampname)", audioData: nil, friendId: "\(receiverData?.u_id ?? "")", messageType: 1, receiptStatus: 1, receiverId:  "\(receiverData?.u_id ?? "")") { response, Progress, errorMessage in
//            if response != nil{
//                print(response)
//            }
//            else{
//                print(errorMessage)
//            }
//        }
//
//
//    }
//
//    func imagesConfig(){
//        let viewController = TLPhotosPickerViewController()
//        viewController.delegate = self
//        viewController.modalPresentationStyle = .fullScreen
//        viewController.didExceedMaximumNumberOfSelection = { (picker) in
//            self.ShowMessageAlert(inViewController: self, title: "", message: ConstantStrings.alertMessage.alert)
//        }
//        //        viewController.customDataSouces = CustomDataSources()
//        var configure = TLPhotosPickerConfigure()
//        configure.numberOfColumn = 3
//        configure.groupByFetch = .day
//        configure.allowedLivePhotos = true
//        configure.allowedPhotograph  = true
//        configure.maxSelectedAssets = 10
//        configure.maxVideoDuration = 150.0
//        configure.selectedColor = AppColors.primaryColor
//         configure.allowedVideoRecording = true
//        configure.allowedAlbumCloudShared = false
//        configure.allowedVideo = true
//        viewController.configure = configure
//        viewController.selectedAssets = self.selectedAssets
//        viewController.logDelegate = self
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
//        self.images.removeAll()
//        self.imageName.removeAll()
//        var isSelectedImage = false
//        let mutableImages: NSMutableArray! = []
//
//        for asset: PHAsset in withPHAssets {
//            if asset.mediaType == .video{
//                                self.encodePhasset(ivasset:asset)
////                DispatchQueue.main.async {
////                    self.ShowMessageAlert(inViewController: self, title: "Alert", message: "Under Development!!")
////                }
//            }else{
//                isSelectedImage = true
//                let targetSize = CGSize(width: asset.pixelWidth , height: asset.pixelHeight)
//                let option = PHImageRequestOptions()
//                option.isSynchronous = true
//                option.isNetworkAccessAllowed = true
//                let phImage = asset.image(targetSize: targetSize, contentMode: .aspectFit, options: option)
//                mutableImages.add(phImage)
//            }
//        }
//        if isSelectedImage{
//            if withPHAssets.count > 0{
//                self.images = mutableImages.copy() as? NSArray as! [UIImage]
//                if self.images.count > 0{
//                    for i in 0..<self.images.count{
//                        let compressimg = self.images[i].checkimgsize()
//                        let timestamp = NSDate().timeIntervalSince1970
//                        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//                        timestampname = timestampname + ".png"
//
//                            compressimg.writeImageToPath(name: "\(timestampname)")
////                        }
//                        let imageData = compressimg.compressimage(.low)
//
//                        APIServices.shared.sendFiles(image: imageData, fileName: "\(timestampname)", audioData: nil, friendId: "\(receiverData?.u_id ?? "")", messageType: 1, receiptStatus: 1, receiverId: "\(receiverData?.u_id ?? "")") { response, Progress, errorMessage in
//                            if response != nil{
//                                print("Upload")
//                                //compressimg.writeImageToPath(name: "\(timestampname)")
//                            }
//                            else{
//                              print("error")
//                            }
//                        }
//
//
//
//                    }
//                }
//            }
//        }
//    }
//
//    //Get Vedio details
//
//    func encodePhasset(ivasset:PHAsset){
//        if ivasset.mediaType == .video {
//            let options = PHVideoRequestOptions()
//            options.deliveryMode = .automatic
//            options.isNetworkAccessAllowed = true
//            PHImageManager.default().requestAVAsset(forVideo: ivasset, options: options) { [self] (asset, audiomix, info) in
//                if let urlAsset = asset as? AVURLAsset {
//                    let localVideoUrl = urlAsset.url
//                    self.gotoVideoTrim(vidUrl:localVideoUrl)
//                } else{
//                    hideCustomLoading()
//                    print("Asset is of not kind of AvUrlAsset.")
//                }
//            }
//        }else if ivasset.mediaType == .image {
//            let option = PHImageRequestOptions.init()
//            PHImageManager.default().requestImage(for: ivasset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: option) { [self] (result, info) in
//                if result != nil {
//                    if (String(describing: info!["PHImageResultIsDegradedKey"]!) == "0"){
//                    }
//                }else{
//                    hideCustomLoading()
//                }
//            }
//        }
//    }
//
//    func gotoVideoTrim(vidUrl:URL){
//     //   isImageCapturing = true
//        DispatchQueue.main.async(execute: { [self] in
//            hideCustomLoading()
//            let asset = AVURLAsset.init(url: vidUrl as URL)
//            let viewcontroller = VideoTrim_ViewController(nibName: "VideoTrim_ViewController", bundle: nil)
//            viewcontroller.delegate = self
//            viewcontroller.url = vidUrl
//            viewcontroller.asset = asset
//            self.navigationController?.pushViewController(viewcontroller, animated: true)
//        })
//    }
//
//    func hideCustomLoading(){
//        DispatchQueue.main.async(execute: {
//            print("Hide Loading Called.")
//          //  hud.hide(animated: true)
//            print("Hide Loading Called. hiden")
//        })
//    }
//
//    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
//        self.ShowMessageAlert(inViewController: self, title: "", message: ConstantStrings.alertMessage.alert)
//    }
//
//    func selectedCameraCell(picker: TLPhotosPickerViewController) {}
//
//    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {}
//
//    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {}
//
//    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {}
//
//    @objc func closeReplyView(_ sender: Notification){
//        guard let userInfo = sender.userInfo,
//              let _ = userInfo["close"] as? Bool else{ return }
//
//        isReply = false
//        commentId = ""
//
//        tblCHatBottomConstraint?.isActive = false
//        tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
//        tblCHatBottomConstraint?.isActive = true
//    }
//}
//
////MARK: --Keyboard Open/Hide
//extension ChatMessages{
//    @objc func keyboardWillHide(_ sender: Notification) {
//        containerViewConstraint.constant = 0
//        containerViewConstraint.isActive = true
//        isKeyboardShow = false
//        self.txtMessage?.text = "Enter Message"
//        self.EditingEnable  = ""
//        self.txtMessage?.textColor = AppColors.primaryColor
//        if let userInfo = (sender as NSNotification).userInfo {
//            if ((userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height) != nil {
//                if self.view.frame.origin.y != 0 {
//                    self.view.frame.origin.y = 0
//                }
//            }
//        }
//    }
//
//    @objc func keyboardWillShow(_ sender: Notification) {
//        self.tblChat?.alpha = 1
//        self.tblChat?.isUserInteractionEnabled = true
//        self.tblChat?.backgroundView = nil
//        self.isKeyboardShow = true
//        if EditingEnable == ""{
//            self.txtMessage?.text = ""
//        } else {
//            self.txtMessage?.text = EditingEnable ?? ""
//
//        }
//
//        self.txtMessage?.textColor = .black
//        if (sender as NSNotification).userInfo != nil {
//            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
//                if self.view.frame.origin.y == 0{
//                    self.view.layoutIfNeeded()
//                    self.view.layoutSubviews()
//                    self.view.setNeedsDisplay()
//                    containerViewConstraint.constant = -(keyboardSize.height)
//                    containerViewConstraint.isActive = true
//
//                    self.view.layoutIfNeeded()
//                    self.view.layoutSubviews()
//                    self.view.setNeedsDisplay()
//                    if chatMessagesArr.count > 1 {
//                        self.tblChat?.scrollToBottom()
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//extension ChatMessages{
//    func getChat(){
//        APIServices.shared.getChat(receiverId: receiverData?.u_id ?? "", limit: 0, chatHideStat: false) { [self] (response, errorMessage) in
//
//            if response != nil{
//                let senderID = AppUtils.shared.senderID
//                UserDefaults.removeSpecificKeys(key: "\(senderID)\(receiverData?.u_id ?? "")")
//                //AppUtils.shared.saveChatMessages(chat: response, key: "\(senderID)\(receiverData?.u_id ?? "")")
//                getChatMessageLocal()
//
//            }else{
//                getChatMessageLocal()
//            }
//        }
//    }
//
//
//    func sendMessage(message: String, chatType: Int, messageType: Int, commentId: String? = "", selectedUserData: String? = ""){
//
////        APIServices.shared.sendMessage(receiver_Id: receiverData?.u_id ?? "", message: message, messageType: messageType, chatType: chatType, comment_Id: commentId!, createdAt: "", selectedUserData: selectedUserData ?? "") { [self] (response, errorMessage) in
////            if response != nil{
////                print(response)
////                print("Send Message")
////
////                print(chatMessagesArr.count)
////                print(chatMessagesArr)
////
//////            outerLoop: for section in 0..<chatMessagesArr.count {
//////                for index in 0..<chatMessagesArr[section].messages.count {
//////                    if chatMessagesArr[section].messages[index]._id == "0" || chatMessagesArr[section].messages[index]._id == nil {
//////                        chatMessagesArr[section].messages[index]._id = response?._id ?? ""
//////                        break outerLoop
//////                    }
//////                    else{
//////                        print(chatMessagesArr.count)
//////                        if chatMessagesArr.count <= 2 {
//////                        backgroundAPI()
//////                            didFinishedSendingMessage() }
//////                        print("new chats... ")
//////                    }
//////                }
//////                if chatMessagesArr.count <= 2 {
//////                    tblChat?.reloadData() }
//////                print("not Executed THis loop")
//////            }
//////                if chatMessagesArr.count <= 2 {
//////                    backgroundAPI()
//////
//////                }
////                didFinishedSendingMessage()
////            }else{
////
////            }
////        }
//    }
//
//    func getChatMessageLocal(){
//        let senderId = AppUtils.shared.senderID
//        AppUtils.shared.getChatMessages(key: "\(senderId)\(receiverData?.u_id ?? "")") { [self] (response, errorMessage) in
//            if response != nil{
//                createMessageSection(from: response)
//            }else{}
//        }
//    }
//
//    //MARK: Split Messages by each day (Sections)..
//
//    func createMessageSection(from messagesArray:[chatModel]?) {
//
//        chatMessagesArr.removeAll()
//        chatMessagesArr.insert(NewChatMessages(isDowloading: false, date: chatMessages.createdDate!, messages: [messagesArray![0]]), at: 0)
//
//        // messagesArray!
//
//        for messagesIndex in 0..<messagesArray!.count {
//            var actualDate = ""
//            if messagesArray![messagesIndex].createdAt != "" {
//                actualDate = (messagesArray![messagesIndex].createdAt?.getActualDate())!
//
//            }
//
//            if chatMessagesArr.count >= 1 {
//                if let filteredIndex = chatMessagesArr.firstIndex(where: {$0.date == actualDate}) {
//                    chatMessagesArr[filteredIndex].messages.append(contentsOf: [messagesArray![messagesIndex]])
//                }else {
//                    chatMessagesArr.append(NewChatMessages(isDowloading: false, date: actualDate, messages: [messagesArray![messagesIndex]]))
//                }
//            }
//        }
//
//        didFinishedSendingMessage()
//        tblChat?.reloadData()
//    }
//
//
//    func viewImage(indexPath: IndexPath) {
//        self.dismissKeyboard()
//        self.isKeyboardShow = false
//        if chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 7{
//            openMap(indexPath: indexPath)
//        }else{
//            videoNimages(indexPath: indexPath)
//        }
//    }
//
//    func videoNimages(indexPath: IndexPath){
//        var newindex = 0
//
//        print(indexPath)
//
//        chatMessagesArr[indexPath.section].messages[indexPath.row].message
//
//        pushTo(viewController: previewImageVC(data:chatMessagesArr[indexPath.section].messages[indexPath.row].message))
//
//        var imagesArr = [chatModel]()
//        for section in 0..<chatMessagesArr.count{
//            for index in 0..<chatMessagesArr[section].messages.count {
//                if chatMessagesArr[section].messages[index].messageType == 1 &&  chatMessagesArr[section].messages[index].isDeleted != 1 || chatMessagesArr[section].messages[index].messageType == 5 &&  chatMessagesArr[section].messages[index].isDeleted != 1{
//                    if indexPath.row == index {
//                        newindex = imagesArr.count
//                    }
//                    imagesArr.append(chatMessagesArr[section].messages[index])
//                }
//            }
//        }
//
//       // pushTo(viewController: ImageVC(data: imagesArr, index: newindex))
//    }
//
//    func openMap(indexPath: IndexPath) {
//        let message = chatMessagesArr[indexPath.section].messages[indexPath.row].message.split(separator: "-")
//
//        if message.count > 0{
//            let latVal =   51.17889991879489 //Double(message[0])
//            let longVal =   -1.8263999372720716 //Double(message[1])
//            print(latVal)
//            print(longVal)
//            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//                UIApplication.shared.canOpenURL(NSURL(string:
//                                                        "comgooglemaps://?saddr=&daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)&directionsmode=driving")! as URL)
//            }else{
//                var direction:String = ""
//                direction = "http://maps.apple.com/?daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)"
//                let directionsURL = URL(string: direction)
//                if #available(iOS 10, *) {
//                    UIApplication.shared.open(directionsURL!)
//                } else {
//                    UIApplication.shared.openURL(directionsURL!)
//                }
//            }
//        }
//    }
//}
//
//
//extension ChatMessages{
//    func socketConnected(){
//        SocketIOManager.sharedMainInstance.establishConnection()
//        SocketIOManager.sharedInstance.addHandlers()
//
//        timerSocket = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){(time) in
//
//            if SocketIOManager.sharedMainInstance.socket.status == .connected{
//                SocketIOManager.sharedMainInstance.receiverUserStatus { [self] (messag) in
//                    let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
//                    let decoder = JSONDecoder()
//                    do{
//                        let jsonData = try decoder.decode([SelectionResponse].self, from: jsonData!)
//                        let data = jsonData[0]
//                        print(data)
//                        //selectionResponse.value = data
//                    }catch let error as NSError{
//                        print(error)}
//                }
//                self.timerSocket?.invalidate()
//            }
//        }
//
//        //MARK: -- GetChatMessages
//        SocketIOManager.sharedMainInstance.getChatMessage { [self](messageInfo) in
//            print(messageInfo)
//            parseSocketMsg(messag: messageInfo, isProgress: false)
//        }
//
//        // MARK: Start Typing Response
//        SocketIOManager.sharedMainInstance.StartTypingFriend { (typingData) in
//            if self.TypingStatus == "" || self.TypingStatus == " " || self.TypingStatus == "1"{
//                APIServices.shared.typingResponse(data: typingData ,typing: true){ [self] (response, errorMessage) in
//                    //self.typingResponse(data: response!, typing: true)
//                }
//            }
//        }
//
//        // MARK: Stop Typing Response
//        SocketIOManager.sharedMainInstance.StopTypingFriend { data in
//            if self.TypingStatus == "" || self.TypingStatus == "" || self.TypingStatus == "1"{
//                APIServices.shared.typingResponse(data: data, typing: false){ [self] (response, errorMessage) in
//                    //self.typingResponse(data: response!, typing: false)
//                }
//            }
//        }
//    }
//}
//
//extension ChatMessages {
//    func typingResponse(data:Any , typing:Bool){
//        do{
//            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//            let decoder = JSONDecoder()
//            do{
//                let json = try decoder.decode([TypingResponse].self, from: jsonData!)
//                let  usersObject = json[0]
//                if usersObject.UserId == AppUtils.shared.senderID && AppUtils.shared.senderID == usersObject.selectFrienddata._id{
//
//                    if typing{
//                        lblOnline?.text = "Typing..."
//                        statusColor = .green
//
//                    }else{
//                        let statusOnline = receiverData?.onlinestatus == 1 ? "online" : "\(getMsgDate(date: receiverData?.lastActive ?? ""))"
//
//                        lblOnline?.text = "\(statusOnline)"
//                        statusColor = receiverData?.onlinestatus == 1 ? .green : .red
//                    }
//                }
//            }catch let error as NSError{print(error)
//                print(error)
//            }
//        }
//    }
//
//
//
//
//    func parseSocketMsg(messag: Any, isProgress:Bool) {
//        print(messag)
//        print(isProgress)
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
//        do{
//            let msgObject = try JSONDecoder().decode(Array<MessageResponseData>.self, from: jsonData!)
//
//            for count in 0..<msgObject.count {
//                print(msgObject.count)
//                if msgObject[count].msgData == nil{
//                    break
//                }
//                if msgObject[count].msgData.receiverId?._id ?? "" == "" {
//                 print("not Existi")
//                    break
//                }else{
//                    print(" Existi")
//                }
//
//                if msgObject[count].msgData.receiverId?._id == AppUtils.shared.senderID && msgObject[count].msgData.senderId?._id == receiverData?.u_id ?? "" || msgObject[count].msgData.senderId?._id == AppUtils.shared.senderID && msgObject[count].msgData.receiverId?._id == receiverData?.u_id ?? "" {
//
//                    if msgObject[count].msgData._id == "" && msgObject[count].msgData.messageType == 6 {
////                        if msgObject[count].msgData.receiverId?._id == AppUtils.shared.senderID {
////                            //playSound(sound: "RecMessage", isRepeat: false)
////                        }else{
////                            //playSound(sound: "SendMessage", isRepeat: false)
////                        }
//                    }
//
//                    var messageDate = ""
//                    if msgObject[count].msgData.createdAt != "" {
//                        messageDate = msgObject[count].msgData.createdAt!.getActualDate()
//                    }
//
//                    if  msgObject[count].msgData.messageType == 0 {
//                        AppUtils.shared.decryptMessage(msgData: msgObject[count].msgData) { success, decryptedMsg in
//                            if success { msgObject[count].msgData.message = decryptedMsg }
//                        }
//                    }
//
//
//                    print(chatMessagesArr.count)
//
//
//                    if chatMessagesArr.count == 0 {
//                        chatMessagesArr.insert(NewChatMessages(isDowloading: false, date: "", messages: [msgObject[count].msgData]), at: 0)
//                    }
//
//
//                    DispatchQueue.main.async { [self] in
//                        //                        self.tblChat?.isScrollEnabled = true
//                        if isProgress {
////                            msgObject[count].msgData.isProgress = true
//
//                            if let filteredIndex = chatMessagesArr.firstIndex(where: {$0.date == messageDate}) {
//                                if let id = msgObject[count].msgData._id {
//                                    print(id)
//                                    if let index = chatMessagesArr[filteredIndex].messages.firstIndex(where: {$0.message == msgObject[count].msgData.message}) {
//                                        chatMessagesArr[filteredIndex].messages[index]._id = id
//                                        chatMessagesArr[filteredIndex].messages[index].isProgress = false
//                                        self.tblChat!.reloadRows(at: [IndexPath(row: index, section: filteredIndex)], with: .none)
//                                    }else{
//                                        chatMessagesArr[filteredIndex].messages.append(contentsOf: [msgObject[count].msgData])
//                                        let indexPath = IndexPath(row: chatMessagesArr[filteredIndex].messages.count - 1, section: filteredIndex)
//                                        self.tblChat!.insertRows(at: [indexPath], with: .none)
//                                    }
//                                }else {
//                                    chatMessagesArr[filteredIndex].messages.append(contentsOf: [msgObject[count].msgData])
//                                    let indexPath = IndexPath(row: chatMessagesArr[filteredIndex].messages.count - 1, section: filteredIndex)
//                                    self.tblChat!.insertRows(at: [indexPath], with: .none)
//                                }
//                                self.tblChat!.scrollToBottom()
//                            }else {
//                                chatMessagesArr.append(NewChatMessages(isDowloading: false, date: messageDate, messages: [msgObject[count].msgData]))
//                                self.tblChat!.reloadData()
//                                self.tblChat!.scrollToBottom()
//                            }
//                        }
//                        else{
//                            print(chatMessagesArr.count)
//                        outerLoop: for section in 0..<chatMessagesArr.count {
//
//                            for index in 0..<chatMessagesArr[section].messages.count {
//                                if let index = chatMessagesArr[section].messages.firstIndex(where: {($0.message == msgObject[count].msgData?.message && $0.isSend != nil && msgObject[count].msgData.isSend == nil)}) {
//                                    chatMessagesArr[section].messages[index].isSend = 0
//                                    chatMessagesArr[section].messages[index].isProgress = false
//                                    chatMessagesArr[section].messages[index] = msgObject[count].msgData
//                                    self.tblChat?.reloadRows(at: [IndexPath(row: index, section: section)], with: .none)
//
//                                    if chatMessagesArr.count > 1 {
//                                        self.tblChat?.scrollToBottom()
//                                    }
//                                    break outerLoop
//                                }
//                                    //executiong while new chat......
//                                else{
//                                    chatMessagesArr[section].messages[index].isProgress = false
//                                    chatMessagesArr[section].messages[index].isSend = 1
//                                    chatMessagesArr[section].messages[index].message = msgObject[count].msgData?.message
//                                    self.filterMessages(messageDate: messageDate, messages: msgObject[count].msgData)
//                                    break outerLoop
//                                }
//
//                            }
//                        }
//
//                        }
//                    }
//                }else {
//                    print("-------")
//                }
//            }
//        }catch let error as NSError {
//            print(error)
//        }
//    }
//
//    func filterMessages(messageDate: String, messages: chatModel) {
//
//        if let filteredIndex = chatMessagesArr.firstIndex(where: {$0.date == messageDate}) {
//
//            if (messages.messageType != 0){
//                if let index = chatMessagesArr[filteredIndex].messages.firstIndex(where: {$0.isSend == 1 && $0.message == messages.message}) {
//                    chatMessagesArr[filteredIndex].messages[index].isSend = 0
//                    chatMessagesArr[filteredIndex].messages[index].isProgress = false
//                    self.tblChat?.reloadRows(at: [IndexPath(row: index, section: filteredIndex)], with: .none)
//                }else{
//                    chatMessagesArr[filteredIndex].messages.append(contentsOf: [messages])
//                    let indexPath = IndexPath(row: chatMessagesArr[filteredIndex].messages.count - 1, section: filteredIndex)
//                    self.tblChat?.insertRows(at: [indexPath], with: .none)
//                }
//            }else {
//                if let index = chatMessagesArr[filteredIndex].messages.firstIndex(where: {$0.isSend == 1 && $0.message == messages.message}) {
//                    chatMessagesArr[filteredIndex].messages[index].isSend = 0
//                    chatMessagesArr[filteredIndex].messages[index].isProgress = false
//                    self.tblChat?.reloadRows(at: [IndexPath(row: index, section: filteredIndex)], with: .none)
//                }else{
//                    chatMessagesArr[filteredIndex].messages.append(contentsOf: [messages])
//                    let indexPath = IndexPath(row: chatMessagesArr[filteredIndex].messages.count - 1, section: filteredIndex)
//                    self.tblChat?.insertRows(at: [indexPath], with: .none)
//                }
//            }
//            if chatMessagesArr.count > 1 {
//                self.tblChat?.scrollToBottom()
//            }
//        }else {
//            chatMessagesArr.append(NewChatMessages(isDowloading: false, date: messageDate, messages: [messages]))
//            self.tblChat?.reloadData()
//            if chatMessagesArr.count > 1 {
//                self.tblChat?.scrollToBottom()
//            }
//        }
//        didFinishedSendingMessage()
//    }
//}
//
//
//extension ChatMessages{
//    @objc func startTyping() {
//        SocketIOManager.sharedInstance.StartTyping(message: JSONSendData.sharedInstance.typing(msgSenderId: receiverData?.u_id ?? ""))
//        searchTimer?.invalidate()
//        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(stopTyping), userInfo: nil, repeats: false)
//    }
//
//    @objc func stopTyping(){
//        SocketIOManager.sharedInstance.StopTyping(message: JSONSendData.sharedInstance.typing(msgSenderId: receiverData?.u_id ?? ""))
//    }
//}
//
//extension ChatMessages: addLocationDelegate{
//    func addLocation(locImage: UIImage, location: CLLocationCoordinate2D) {
//        let timestamp = NSDate().timeIntervalSince1970
//        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//        timestampname = timestampname + ".png"
//        let imageName = "MAP_00\(timestampname)"
//
//        let compressimg = locImage.checkimgsize()
//        compressimg.writeImageToPath(name: "\(location.latitude)-\(location.longitude)-\(imageName)")
//          APIServices.shared.sendFiles(image: compressimg, fileName: "\(location.latitude)-\(location.longitude)-\(imageName)", audioData: nil, friendId: "\(receiverData?.u_id ?? "")", messageType: 7, receiptStatus: 1, receiverId: "\(receiverData?.u_id ?? "")") { response, Progress, errorMessage in
//            if response != nil{
//                print("Upload")
//            }
//            else{
//
//            }
//        }
//    }
//}
//
//
//
//extension ChatMessages: sendMessageDelegate{
//    func sendAudioMessage(messageData: Any) {
//        print("??")
//    }
//
//    func sendTextMessage(messageData: Any, msg_id: String) {
//        print("??")
//    }
//
//    func sendTextMessage(messageData: Any) {
//        //parseSocketMsg(messag: [messageData], isProgress:false)
//    }
//
//    func sendMessage(messageData: Any) {
//        print("Run")
//        parseSocketMsg(messag: [messageData], isProgress:false)
//        //parseMsgs(messag: [messageData], isProgress: true)
//    }
//}
//
//
//extension ChatMessages: imagesViewDelegate{
//
//    func didSelectImage(cell: PhotoMsgCell) {
//        print(select)
//        if let indexPath = tblChat?.indexPath(for: cell){
//            viewImage(indexPath: indexPath)
//        }
//
//    }
//}
//extension ChatMessages : vedioViewDelegate {
//    func reloadSelectVedio(cell: VideoMsgCell, indexSection: String, indexRow: String) {
//        print(indexSection)
//        print(indexRow)
//        let indexPath = IndexPath(item: 26, section: 3)
//        self.tblChat?.reloadData()
//    }
//
//    func didSelectVedio(cell: VideoMsgCell, VedioUrl: String) {
//        if let indexPath = tblChat?.indexPath(for: cell){
//            //viewImage(indexPath: indexPath)
//            print(VedioUrl)
//            self.pushTo(viewController: playVedioVC(data: nil, index: 0, vedioUrl: VedioUrl))
//        }
//
//    }
//}
//
//
//extension ChatMessages{
//    func parseMsgs(messag: Any, isProgress:Bool) {
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
//        do{
//            let msgObject = try JSONDecoder().decode(Array<MessageResponseData>.self, from: jsonData!)
//
//            for count in 0..<msgObject.count {
//                if msgObject[count].msgData.receiverId?._id == AppUtils.shared.senderID && msgObject[count].msgData.senderId?._id == receiverData?.u_id ?? "" || msgObject[count].msgData.senderId?._id == AppUtils.shared.senderID && msgObject[count].msgData.receiverId?._id == receiverData?.u_id ?? "" {
//
//                    var messageDate = ""
//                    if msgObject[count].msgData.createdAt != "" {
//                        messageDate = msgObject[count].msgData.createdAt!.getActualDate()
//                    }
//
//                    if chatMessagesArr.count == 0 {
//                        chatMessagesArr.insert(NewChatMessages(isDowloading: false, date: "", messages: [msgObject[count].msgData]), at: 0)
//                    }
//
//                    DispatchQueue.main.async { [self] in
//
////                        msgObject[count].msgData.isProgress = true
//
//                        if let filteredIndex = chatMessagesArr.firstIndex(where: {$0.date == messageDate}) {
//                            chatMessagesArr[filteredIndex].messages.append(contentsOf: [msgObject[count].msgData])
//
//                            let indexPath = IndexPath(row: chatMessagesArr[filteredIndex].messages.count - 1, section: filteredIndex)
//
//                            self.tblChat!.insertRows(at: [indexPath], with: .none)
//
//                            self.tblChat!.scrollToBottom()
//                        }
//                    }
//                }
//            }
//        }catch let error as NSError {
//            print(error)
//        }
//    }
//}
//
//
//
//
//
//
////Audion recording data.
//
////MARK: --Record_View Delegates
//extension ChatMessages: RecordViewDelegate{
//    func onStart() {
//        print("Start")
//        stopSound()
//        self.recordView?.isHidden = false
//        btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .white), for: .normal)
//        self.btnView.backgroundColor = AppColors.primaryColor
//        recordView?.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1)
//        self.startRecording()
//    }
//
//    func onCancel() {
//        print("Cancel")
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] (tim) in
//            self.btnView.backgroundColor = .white
//            self.recordView?.isHidden = true
//            btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
//            self.recordView?.backgroundColor = .clear
//        }
//        audioRecorder?.stop()
//        audioRecorder = nil
//        finishRecording(success: false)
//    }
//
//    func onFinished(duration: CGFloat) {
//        print("Time")
//        self.recordView?.isHidden = true
//        self.btnView.backgroundColor = .white
//        btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
//        self.recordView?.backgroundColor = .clear
//
//        if duration > 0.9{
//            Reachability.isConnectedToNetwork { [self] (isConnected) in
//                if isConnected{
//                    finishRecording(success: true)
//                }else{
//                    finishRecording(success: false)
//                }
//            }
//        }else{
//            finishRecording(success: false)
//        }
//    }
//}
//
//
////MARK: --Start Recording
//extension ChatMessages{
//    func startRecording() {
//        let audioFilename = createFileURL()
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
//        ]
//        do {
//            if #available(iOS 13.0, *) {
//                audioRecorder = AVAudioRecorder()
//            }
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.record()
//        } catch {
//            print(error)
//            finishRecording(success: false)
//        }
//    }
//
//    func createFileURL() -> URL {
//        let timestamp = NSDate().timeIntervalSince1970
//        audiofilename = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//        audiofilename = "Audio_\(audiofilename).m4a"
//        let folderurl = getDocumentsDirectory().appendingPathComponent("Audios")
//        var newUrl:URL?
//        do {
//            try FileManager.default.createDirectory(atPath: folderurl.path, withIntermediateDirectories: true, attributes: nil)
//            newUrl = folderurl.appendingPathComponent(audiofilename)
//        } catch {
//            print(error)
//        }
//        return newUrl! as URL
//    }
//
//    func getFileURL() -> URL {
//        let filepath = "Audios/\(audiofilename)"
//        let path = getDocumentsDirectory().appendingPathComponent(filepath)
//        return path as URL
//
//    }
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func finishRecording(success: Bool) {
//        print(success)
//        if audioRecorder != nil{
//            audioRecorder?.stop()
//            audioRecorder = nil
//        }
//        if success == true{
//            print("Success")
//            voicemsgstatus = 1
//            do{
//                let audioData = try Data(contentsOf: getFileURL() as URL)
//                //database save recording
//                APIServices.shared.sendFiles(image: nil, fileName: "\(audiofilename)", audioData: audioData, friendId: "\(receiverData?.u_id ?? "")", messageType: 6, receiptStatus: 1, receiverId: "\(receiverData?.u_id ?? "")") { response, progress, errorMessage in
//                    if response != nil{
//
//                    }else{
//
//
//                    }
//                }
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            voicemsgstatus = 0
//        }
//    }
//}
//
////Send Vedio to the server...... triming Vedio.....
//extension ChatMessages : videoTrimDelegate {
//    func didgetTrimedvideoduet(url: URL) {
//        hideCustomLoading()
//        do{
//            let videoData = try Data(contentsOf: url)
//            let timestamp = NSDate().timeIntervalSince1970
//            var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//            timestampname = timestampname + ".mp4"
//
//            DispatchQueue.main.async { [self] in
//
//                APIServices.shared.sendFiles(image: nil , fileName: "Video_\(timestampname)",audioData : nil , videoData: videoData, friendId: "\(receiverData?.u_id ?? "")", messageType: 5, receiptStatus: 0, receiverId: "\(receiverData?.u_id ?? "")") { response, Progress, errorMessage in
//                    if response != nil{
//                        print(response)
//                    }
//                    else{
//                        print(errorMessage)
//                    }
//                }
//
//            }
//        }catch let error as NSError{ print(error.localizedDescription) }
//    }
//
//}
//
//
////Pick file and writ it locally...
//
//extension ChatMessages: UIDocumentPickerDelegate {
//
//    public func folderAction(){
//        var types: [String] = [kUTTypePDF as String]
//        types.append(kUTTypeText as String)
//        types.append(kUTTypeJSON as String)
//        types.append(kUTTypeFolder as String)
//        types.append(kUTTypeDirectory as String)
//        types.append(kUTTypePDF as String)
//        types.append(kUTTypeContent as String)
//        types.append(kUTTypeData as String)
//        types.append(kUTTypeItem as String)
//        types.append(kUTTypeZipArchive as String)
//        self.pickerController = UIDocumentPickerViewController(documentTypes: types, in: .open)
//        self.pickerController!.delegate = self
//        self.present(self.pickerController!, animated: true)
//    }
//
//    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let url = urls.first else { return }
//        let res = url.absoluteString.split(separator: ".")
//        documentFromURL(pickedURL: url)
//        let timestamp = NSDate().timeIntervalSince1970
//        let timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//        let fileName = "File_\(timestampname)." + String(res.last!)
//
//        self.writeFileToPath(name: fileName, data: nil, fileFolderName: "Document", destinationUrl: urls[urls.count - 1])
//
//        APIServices.shared.sendFile(receiverId: "\(receiverData?.u_id ?? "")", document: documents[documents.count - 1], docName: fileName, filesurl: urls[urls.count - 1], isGroup: false, receiptStatus: false, isSeen: false) { response, Progress, errorMessage in
//            if response != nil{
//                print(response)
//                print(urls[urls.count - 1])
//                self.writeFileToPath(name: fileName, data: nil, fileFolderName: "Document", destinationUrl: urls[urls.count - 1])
//
//            }
//            else{
//                print(errorMessage)
//            }
//        }
//    }
//
//    private func documentFromURL(pickedURL: URL) {
//        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
//        defer {
//            if shouldStopAccessing {
//                pickedURL.stopAccessingSecurityScopedResource()
//            }
//        }
//        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
//            let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
//            let fileList =  FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
//            let document = Document(fileURL: pickedURL)
//            documents.append(document)
//            switch sourceType {
//            case .files:
//                let document = Document(fileURL: pickedURL)
//                documents.append(document)
//            case .folder:
//                for case let fileURL as URL in fileList! {
//                    if !fileURL.isDirectory {
//                        let document = Document(fileURL: fileURL)
//                        documents.append(document)
//                    }
//                }
//            case .none:
//                break
//            }
//        }
//    }
//    //write file to pateh
//
//    func writeFileToPath(name:String,data:Data?,fileFolderName:String,destinationUrl:URL?) {
//        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
//        var folderURL = documentsUrl.appendingPathComponent(fileFolderName)
//        var fileUrl = folderURL.appendingPathComponent(name)
//        if !FileManager.default.fileExists(atPath: fileUrl.path) {
//            do{
//                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
//            }
//            catch {
//                print("Error Writing Image: \(error)")
//            }
//            print("File does NOT exist1 -- \(fileUrl) -- is available for use")
//            let data = data
//            do {
//                print("Write file")
//                if let url = destinationUrl{
//                    try FileManager.default.copyItem(at: url, to: fileUrl)
//                    return
//                }
//                try data!.write(to: fileUrl)
//            } catch {
//                print("Error Writing Image: \(error)")
//            }
//        } else {
//            print("This file exists -- something is already placed at this location")
//        }
//    }
//
//}
//
//
//
////Preveiw file on Selection..
//extension ChatMessages : QLPreviewControllerDataSource {
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        return 1
//    }
//
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        return fileUrl2!
//    }
//}
//
//extension ChatMessages : UIContextMenuInteractionDelegate {
//
//
//
//
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        let location = interaction.location(in: tblChat!)
//           guard let indexPath = tblChat?.indexPathForRow(at: location) else {
//               return nil
//           }
//        print(indexPath.row)
//        print(indexPath.section)
//
//        print(chatMessagesArr[indexPath.section].messages[indexPath.row].messageType)
//
////        if chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0//
//
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] _ -> UIMenu? in
//
//
//            return self.createContextMenu(stringTocpy: chatMessagesArr[indexPath.section].messages[indexPath.row].message ?? "no", messageType: chatMessagesArr[indexPath.section].messages[indexPath.row].messageType ?? 0, indexRow: indexPath)
//    }
//
//    }
//    func createContextMenu(stringTocpy: String, messageType : Int, indexRow : IndexPath) -> UIMenu {
//
//            let image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
//
//
//        let Edit = UIAction(title: "Edit", image: UIImage(named: "Edit")) { [self] _ in
//                print("Share")
//
//            self.txtMessage?.becomeFirstResponder()
//            EditingEnable = stringTocpy
//          print(EditingEnable)
//            }
//
//        let reply = UIAction(title: "Reply", image: UIImage(named: "Reply-1")) { [self] _ in
//                print("Copy")
//            isReply = true
//                setUpReplayView(index: indexRow)
//
//            }
//
//        let Forward = UIAction(title: "Forward", image: UIImage(named: "Forward")) { [self] _ in
//                print("Save to Photos")
//            arraySelected.removeAll()
//
//            isdeleted = false
//                inputBottomOperationView?.isHidden = false
//                inputBottomView?.isHidden = true
//                tblCHatBottomConstraint?.isActive = false
//                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomOperationView!.topAnchor, constant: -20)
//                tblCHatBottomConstraint?.isActive = true
//
//            lblForDel?.text = "Forward"
//
//            BtnForDel?.setImage(UIImage(systemName: "arrow.turn.up.right"), for: .normal)
//            BtnForDel?.setImageTintColor(.white)
//            isdelForward = true
//            tblChat?.reloadData()
//
//            }
//            let Copy = UIAction(title: "Copy", image: UIImage(named: "Copy")) { _ in
//                  UIPasteboard.general.string = stringTocpy
//            }
//            let Delete = UIAction(title: "Delete", image: UIImage(named: "trash")) { [self] _ in
//                print("Save to Photos")
//                arraySelected.removeAll()
//                isdeleted = true
//                inputBottomOperationView?.isHidden = false
//                inputBottomView?.isHidden = true
//                tblCHatBottomConstraint?.isActive = false
//                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomOperationView!.topAnchor, constant: -20)
//                tblCHatBottomConstraint?.isActive = true
//
//                BtnForDel?.setImage(UIImage(systemName: systemImage.delete), for: .normal)
//
//                lblForDel?.text = "Delete"
//                isdelForward = true
//                tblChat?.reloadData()
//
//             }
//        if messageType == 0 {
//            return UIMenu( options: .displayInline, children: [Edit, reply, Forward, Copy , Delete ])
//        }
//        else {
//            return UIMenu( options: .displayInline, children: [reply, Forward, Delete])
//        }
//
//        }
//    }
//
//
//
//
//
//
//
