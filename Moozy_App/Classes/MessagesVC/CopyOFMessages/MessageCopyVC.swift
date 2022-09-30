
//
//  chatMessages.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 17/05/2022.
//

import Foundation
import UIKit
import SwiftUI
import SwipyCell
import TLPhotoPicker
import Photos
import Alamofire
import SocketIO
import SimpleTwoWayBinding
import iRecordView
import MobileCoreServices
import QuickLook
import SDWebImage
import AVFoundation
import AVKit
import CryptoSwift
import Imaginary

class MessageVcCopy: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,   AVAudioRecorderDelegate , TLPhotosPickerViewControllerDelegate, TLPhotosPickerLogDelegate {
    //Vrible using to play audion
    var SelectedAudionRow : IndexPath?
    var timeDeactice = 0.00
    var urlPlayed  : String? = ""
    
    
    var navigationView: UIView?
    var profileView: ProfileView?
    var containerView: UIView?
    var tblChat: UITableView?
    
    var inputBottomView: UIView?
    var inputBottomOperationView: UIView?
    var txtMessage: UITextView?
    var recordView: RecordView?
    var btnSend: MoozyActionButton?
    var btnRecoard: RecordButton?
    var replayImage = UIImage()
    var btnView = UIView()
    
    var receiverID: String?
    var receiverData: friendInfoModel?
    var isKeyboardShow = false
    
    var lblOnline: UILabel?
    var online: UIView?
    
    var msgSelectedIndex = IndexPath()
    
    
    var replyView: ReplyView?
    var statusColor: UIColor?
    var searchTimer: Timer?
    
    var audiofilename = ""
    var audioPlayer: AVAudioPlayer?
    var audiotimer:Timer?
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var audioPLayer :AVAudioPlayer?
    
    var voicemsgstatus = 0
    
    var containerViewConstraint: NSLayoutConstraint!
    var inputBottomViewConstraint: NSLayoutConstraint!
    
    var viewModel: ChatDataVM?
    var chatList: [chatMessage_Model] = []
    
    var isReply: Bool? = false
    var isEditeing: Bool? = false
    var Editeingmsg_id : IndexPath?
    var EditingEnable :  String? = ""
    var isdelForward: Bool? = false
    var isdeleted: Bool? = false
    
    var isSend: Bool? = false
    var commentId: String? = ""
    var commentData: [chat_data]? = []
    var commentSms : String? = ""
    
    var imageDictionary = [NSURL: UIImage]()
    
    
    var chatMessagesArr = [NewChatMessages]()
    let HeadercontainerView = UIView()
    var OpenfileUrl :NSURL?
    
    private var sourceType: SourceType!
    
    let chatMessages = ChatMessageModel(user_id: "", frind_id: "", message: "", message_Type: 0, status: nil, isSeen: nil, receiptStatus: nil, createdDate: "", hide: nil, sender_id: "", sender_name: "", sender_image: "", receiver_id: "", receiver_name: "", receiver_image: "")
    
    //Buttom Constraint of Tableview.
    var tblCHatBottomConstraint: NSLayoutConstraint?
    
    //Component to delete or forward sms
    var  BtnForwrdDelete : MoozyActionButton?
    var  btnCancel : MoozyActionButton?
    var lblForwardDelete : UILabel?
    var lblCountSelected : UILabel?
    
    var isLongPressAction : Bool? = false
    
    //new Update
    var chatMsgArr : [ChatMessagesModel]? = []
    //Gallery Open
    var imagePicker: UIImagePickerController?
    var images = [UIImage]()
    var imageName = [String]()
    var selectedAssets = [TLPHAsset]()
    
    
    private var documents = [Document]()
    
    private var pickerController: UIDocumentPickerViewController?
    
    var playstatus = -1
    
    public var btnScrollToBottom : UIView?
    
    //Initilization..
    init(receiverData: friendInfoModel? = nil) {
        if let receiver = receiverData {
            chatMessagesArr.removeAll()
            self.receiverData = receiver
            self.receiverID = receiver.friendId ?? ""
        }
        viewModel = ChatDataVM(receiverId: receiverData?.friendId ?? "")
        
        super.init(nibName: nil, bundle: nil)
        configureUI()
        dataBinding()
        socketConnected()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIServices.shared.sendDelegate = self
        isdelForward = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        notificationListener()
    }
    override func viewDidAppear(_ animated: Bool) {
        //        viewModel?.CancelSelectionMessages()
        //        isdelForward = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isKeyboardShow = false
        self.dismissKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    
    
    //MARK: -- initializedControls--
    func initializedControls(){
        configureNavitionView()
        configureTableView()
        configureInputView()
        
        containerView = UIView(backgroundColor: UIColor.white, maskToBounds: true)
        containerView?.roundCorners(corners: [.topLeft, .topRight], radius: 10, clipToBonds: true)
        self.replyView?.isHidden = true
        
        btnScrollToBottom = {
            let view = UIView(backgroundColor: AppColors.primaryColor, cornerRadius: 40/2)
            let img = UIImageView(image: UIImage(systemName: "chevron.right.2")!, contentModel: .scaleAspectFill)
            img.transform = img.transform.rotated(by: CGFloat(M_PI_2))
            view.addSubview(img)
            img.constraintsWidhHeight(size: .init(width: 20, height: 20))
            img.setImageColor(color: UIColor.white)
            img.centerSuperView()
            return view
        }()
        
    }
    
    //MARK: -- Configure UI
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: navigationView!, containerView!)
        containerView?.addMultipleSubViews(views: tblChat!,inputBottomView!,inputBottomOperationView! , btnScrollToBottom!)
        
        inputBottomOperationView?.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 100))
        
        
        
        navigationView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        navigationView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        containerView?.anchor(top: navigationView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -17, left: 0, bottom: 0, right: 0))
        
        containerViewConstraint = containerView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        containerViewConstraint.isActive = true
        
        inputBottomView?.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 5, right: 12))
        
        inputBottomViewConstraint = inputBottomView?.heightAnchor.constraint(equalToConstant: 50)
        inputBottomViewConstraint.isActive = true
        
        inputBottomOperationView?.isHidden = true
        
        btnScrollToBottom?.anchor(top: nil, leading: nil, bottom: inputBottomView?.topAnchor, trailing: containerView?.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 50, right: 20),size: .init(width: 40, height: 40))
        
        tblChat?.anchor(top: containerView?.topAnchor, leading: containerView?.leadingAnchor, bottom: nil , trailing: containerView?.trailingAnchor, padding: .init(top: -2, left: 0, bottom: 0, right: 0))
        
        tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
        tblCHatBottomConstraint?.isActive = true
        
        view.bringSubviewToFront(containerView!)
        containerView?.bringSubviewToFront(navigationView!)
        
        containerView?.bringSubviewToFront(inputBottomView!)
        inputBottomView?.bringSubviewToFront(tblChat!)
        tblChat?.bringSubviewToFront(btnScrollToBottom!)
        btnScrollToBottom?.isHidden = true
        replayImage = createImage(txt: "", img: UIImage(named: "reply")!, size: 55.0)
        addTapGesture()
    }
    
    private func addTapGesture(){
        btnScrollToBottom?.addTapGesture(tagId: 0, action: { [self] _ in
            print("Add Chat")
            if chatMsgArr?.count ?? 0 > 1 {
                self.tblChat?.scrollToBottom()
            }
        })
    }
    //MARK: -- configure Navigation View
    func configureNavitionView(){
        navigationView = {
            let view = UIView(backgroundColor: AppColors.primaryColor, maskToBounds: true)
            let TopView = UIView(backgroundColor: .clear, cornerRadius: 0, maskToBounds: true)
            
            statusColor = receiverData?.onlineStatus == 1 ? .green : .red
            online = UIView(backgroundColor: statusColor!, cornerRadius: 4)
            let statusOnline = receiverData?.onlineStatus == 0 ?  "\(getMsgDate(date: receiverData?.createdAt ?? ""))" : "online"
            lblOnline = UILabel(title: "\(statusOnline)", fontColor: AppColors.secondaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 9))
            online?.constraintsWidhHeight(size: .init(width: 9, height: 9))
            let stackss = UIStackView(views: [online!, lblOnline!], axis: .horizontal, spacing: 2,distribution: .fill)
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) { [self] in
               var viewModel = ChatDataVM()
                
                if   ((audioPlayer?.isPlaying) != nil) {
                    timeDeactice = 0.00
                    audioPlayer?.stop()
                    audiotimer?.invalidate()
                    playstatus = -1
                }
                
                
                self.pop(animated: true)
            }
            
            profileView = ProfileView(title: "\(receiverData?.name.checkNameLetter() ?? "")", font: UIFont.font(.Poppins, type: .Medium, size: 14), BGcolor: UIColor.clear, titleFontColor: UIColor.white, borderColor: AppColors.secondaryColor.cgColor, borderWidth: 1, size: .init(width: 30, height: 30))
            
            let image =  receiverData?.profile_image ?? nil
            if image != "" && image != nil {
                
                let imgUrl = userImages.userImageUrl
                print(imgUrl)
                if let url = URL(string: imgUrl){
                    profileView?.profileImagesss = "\(url)\(receiverData?.profile_image ?? "")"
                    //imgTitle?.profileImagesss = "\(url)\(dataSet?.friend.user_image ?? "")"
                }else {
                    profileView?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()
                }
                profileView?.titleProfile = ""
            } else {
                profileView?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()
                
            }
            
            
            profileView?.isBound = true
            profileView?.titleProfile = receiverData?.name.checkNameLetter() ?? ""
            
            let lblUserName = UILabel(title: "\(receiverData?.name.capitalizingFirstLetter() ?? "")", fontColor: AppColors.secondaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .SemiBold, size: 12))
            
            let statusOnlineStack = UIStackView(views: [lblUserName, stackss], axis: .vertical, spacing: 2)
            
            let btnOptions = MoozyActionButton(image: UIImage(named: "MoreOption"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear, imageSize: .init(width: 25, height: 15)) { [self] in
                
                self.replyView?.isHidden = true
                //update table view..
                tblCHatBottomConstraint?.isActive = false
                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                tblCHatBottomConstraint?.isActive = true
                self.pushTo(viewController: ChatDetailVC(receiverData: receiverData))
            }
            
            btnOptions.constraintsWidhHeight(size: .init(width: 25, height: 15))
            let stack = UIStackView(views: [btnOptions], axis: .horizontal, distribution: .fill)
            TopView.addTapGesture(tagId: 0, action: { [self] _ in
                
                self.replyView?.isHidden = true
                //update table view..
                tblCHatBottomConstraint?.isActive = false
                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                tblCHatBottomConstraint?.isActive = true
                self.pushTo(viewController: ChatDetailVC(receiverData: receiverData))
            })
            view.addMultipleSubViews(views: btnBack, profileView!, statusOnlineStack, stack,TopView)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: backButtonSize)
            
            profileView?.anchor(top: nil, leading: btnBack.trailingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 24, right: 0), size: .init(width: 30, height: 30))
            btnBack.verticalCenterWith(withView: profileView!)
            
            statusOnlineStack.anchor(top: nil , leading: profileView?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
            
            statusOnlineStack.verticalCenterWith(withView: profileView!)
            
            //stackss.anchor(top: lblUserName.bottomAnchor, leading: lblUserName.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
            
            stack.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12))
            stack.verticalCenterWith(withView: profileView!)
            TopView.anchor(top: view.topAnchor, leading: btnBack.trailingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
            
            return view
        }()
    }
    
    //MARK: configure Input View--
    func configureInputView(){
        
        inputBottomOperationView = {
            let Deleteview = UIView(backgroundColor: #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.7137254902, alpha: 1), cornerRadius: 0, maskToBounds: true)
            BtnForwrdDelete = MoozyActionButton(image: UIImage(systemName: "trash"), foregroundColor: .white ,imageSize: .init(width: 25, height: 25)) { [self] in
                DeleteOrForwardChat()
            }
            
            // (systemName: systemImage.close)
            lblForwardDelete = UILabel(title:  "Delete", fontColor:  .white, alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Medium, size: 14))
            lblCountSelected = UILabel(title:  "1", fontColor:  .white, alignment: .right, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Medium, size: 14))
            btnCancel = MoozyActionButton(image: UIImage(systemName: systemImage.close), foregroundColor: .white ,imageSize: .init(width: 25, height: 25)) { [self] in
                viewModel?.CancelSelectionMessages()
                tblCHatBottomConstraint?.isActive = false
                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                tblCHatBottomConstraint?.isActive = true
                inputBottomOperationView?.isHidden = true
                inputBottomView?.isHidden = false
                isdelForward = false
                isLongPressAction = false
            }
            lblForwardDelete?.addTapGesture(tagId: 0, action: { [self] _ in
                DeleteOrForwardChat()
            })
            let stack = UIStackView(views: [BtnForwrdDelete!, lblForwardDelete!,  btnCancel!], axis: .horizontal, spacing: 8, distribution: .fill)
            
            Deleteview.addMultipleSubViews(views: stack ,lblCountSelected!)
            stack.fillSuperView(padding: .init(top: 10, left: 10, bottom: 20, right: 10))
            lblCountSelected?.anchor(top: Deleteview.topAnchor, leading: Deleteview.leadingAnchor, bottom: nil, trailing: stack.trailingAnchor,padding: .init(top: 5, left: 10, bottom: 0, right: 80), size: .init(width: 0, height: 40))
            
            return Deleteview
            
        }()
        inputBottomView = {
            let view = UIView(backgroundColor: #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1), cornerRadius: 25, maskToBounds: true)
            let userImage = ProfileView(font:  UIFont.font(.Poppins, type: .Medium, size: 14), BGcolor: AppColors.primaryColor, titleFontColor: AppColors.secondaryColor, borderColor: AppColors.primaryFontColor.cgColor , borderWidth: 1,  size: .init(width: 22, height: 22))
            let url = "https://chat.chatto.jp:21000/chatto_images/chat_images/"
            print(userImages.userImage )
            let img = userImages.userImage
            
            let image = "\(url)\(userImages.userImage)"
            if img != "" {
                
                if image != "" && image != nil {
                    
                    let imgUrl = "\(url)\(userImages.userImage)"
                    
                    if let url = URL(string: imgUrl ?? ""){
                        userImage.profileImagesss = imgUrl
                    } else {
                        userImage.isBound = true
                        let name = AppUtils.shared.user?.name ?? ""
                        userImage.titleProfile =  name != "" ? name.checkNameLetter() : "N".checkNameLetter()
                    }
                }
            } else {
                userImage.isBound = true
                let name = AppUtils.shared.user?.name ?? ""
                userImage.titleProfile =  name != "" ? name.checkNameLetter() : "N".checkNameLetter()
                
            }
            
            txtMessage = {
                let txt = UITextView()
                txt.text = "Enter Message"
                txt.textColor = AppColors.primaryColor
                txt.allowsEditingTextAttributes = true
                txt.showsVerticalScrollIndicator = false
                txt.backgroundColor = UIColor.clear
                txt.font = UIFont.font(.Poppins, type: .Regular, size: 12)
                txt.isScrollEnabled = false
                txt.delegate = self
                return txt
            }()
            
            btnSend = MoozyActionButton(image: UIImage(systemName: "paperplane"), imageSize: .init(width: 40, height: 20)) { [self] in
                print("send it...")
                self.inputBottomViewConstraint.isActive = false
                self.inputBottomViewConstraint.constant = 50.0
                self.inputBottomViewConstraint.isActive = true
                DispatchQueue.main.async { [self] in
                    if txtMessage!.text.trimmingCharacters(in: .whitespaces).isEmpty {
                        print("Not send")
                    }else{
                      
                        let chatType = isReply == true ? 1 : 0
                        let commentId = commentId == "" ? "" : commentId
                        commentSms = replyView?.message
                        let Inputtext =  "\(txtMessage?.text ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
                      
                        if isEditeing == true {
                            
                            if txtMessage?.text != ""{
                                if EditingEnable == txtMessage?.text ?? "" {
                                EditingEnable = ""
                                } else {
                                    EditingEnable = ""
                                 viewModel?.UpdateMessage(Messages: chatMsgArr ?? [] , message_Id: Editeingmsg_id!, message: Inputtext, chatType: chatType, messageType: 0, commentId: commentId, selectedUserData: receiverData?.friendId ?? "")
                                }
                                DispatchQueue.main.async { [self] in
                                    txtMessage?.text = ""
                                    btnSend?.isEnabled = true
                                    self.isReply = false
                                    self.commentId = ""
                                    self.replyView?.isHidden = true
                                    //update table view..
                                    tblCHatBottomConstraint?.isActive = false
                                    tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                                    tblCHatBottomConstraint?.isActive = true
                                }
                            }
                            isEditeing = false
                            txtMessage?.text = "Enter Message"
                            self.txtMessage?.textColor = AppColors.primaryColor
                            btnSend?.isHidden = true
                            btnRecoard?.isHidden = false
                            
                        } else {
                            
                            if txtMessage?.text != ""{
                                EditingEnable = ""
                                print("\(txtMessage?.text ?? "")")
                                viewModel?.sendMessage(message: Inputtext, chatType: chatType, messageType: 0, commentId: commentId, commentData: commentData , selectedUserData: receiverData?.friendId ?? "")
                                
                                DispatchQueue.main.async { [self] in
                                    txtMessage?.text = ""
                                    btnSend?.isEnabled = true
                                    self.isReply = false
                                    self.commentId = ""
                                    self.replyView?.isHidden = true
                                    //update table view..
                                    tblCHatBottomConstraint?.isActive = false
                                    tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                                    tblCHatBottomConstraint?.isActive = true
                                    txtMessage?.text = "Enter Message"
                                    self.txtMessage?.textColor = AppColors.primaryColor
                                    btnSend?.isHidden = true
                                    btnRecoard?.isHidden = false
                                }
                            } }
                    }
                    
                }
                
                
            }
            
            recordView = {
                let view = RecordView()
                view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1)
                view.layer.cornerRadius = 5
                view.delegate = self
                return view
            }()
            
            
            btnRecoard = {
                let btn = RecordButton()
                let img = UIImage(named: "mic")?.withRenderingMode(.alwaysTemplate)
                btn.setImage(img, for: .normal)
                btn.tintColor = .gray
                btn.imageView?.contentMode = .scaleAspectFit
                btn.imageView?.centerSuperView()
                btn.imageView?.clipsToBounds = true
              
                //btn.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
                btn.recordView = self.recordView
                return btn
            }()
            
            let btnAttachment = MoozyActionButton(image: UIImage(systemName: "paperclip"), backgroundColor: UIColor.clear, imageSize: .init(width: 40, height: 20)) { [self] in
                self.dismissKeyboard()
                self.replyView?.isHidden = true
                //update table view..
                tblCHatBottomConstraint?.isActive = false
                tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
                tblCHatBottomConstraint?.isActive = true
                self.ShowPopUp(PopView: PopUpAttachmentView())
            }
            
            btnSend?.tint = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            btnRecoard?.constraintsWidhHeight(size: .init(width: 40, height: 40))
            btnSend?.constraintsWidhHeight(size: .init(width: 40, height: 20))
//            btnRecoard?.backgroundColor = .red
            
            btnView = UIView(backgroundColor: .white, cornerRadius: 5)
            let stackButton = UIStackView(views: [btnRecoard!, btnSend!], axis: .horizontal)
            
            view.addMultipleSubViews(views: userImage, txtMessage!, btnAttachment, btnView,recordView!)
//            btnView.addSubview(stackButton)
            btnView.addMultipleSubViews(views: btnRecoard!, btnSend! )
            userImage.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
            
            userImage.verticalCenterWith(withView: view)
            
            btnView.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 35, height: 35))
            btnView.verticalCenterWith(withView: view)
            btnView.layer.cornerRadius = 35/2
            
            btnRecoard?.centerSuperView()
            btnSend?.centerSuperView()
            btnAttachment.anchor(top: nil, leading: nil, bottom: nil, trailing: btnView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 40, height: 20))
            btnAttachment.verticalCenterWith(withView: btnView)
            
            txtMessage?.anchor(top: view.topAnchor, leading: userImage.trailingAnchor, bottom: view.bottomAnchor, trailing: btnAttachment.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
            
            recordView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: btnView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4))
            
            btnSend?.isHidden = true
            recordView?.isHidden = true
            return view
        }()
    }
    
    func DeleteOrForwardChat(){
        if   isdeleted == false {
            print("forwared")
            if viewModel?.selectedMessage.count ?? 0 >= 1 {
                self.pushTo(viewController: NewChatVC(selectedMessages: viewModel?.selectedMessage))
            }
        } else {
            viewModel?.DeleteMessages()
            viewModel?.selectedMessage.removeAll()
        }
        inputBottomOperationView?.isHidden = true
        inputBottomView?.isHidden = false
        tblCHatBottomConstraint?.isActive = false
        tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
        tblCHatBottomConstraint?.isActive = true
        isdelForward = false
        isLongPressAction = false
        viewModel?.CancelSelectionMessages()
        isdelForward = false
    }
    
    //MARK: --Configure TableView--
    func configureTableView(){
        tblChat = UITableView(frame: .zero, style: .plain)
        
        tblChat?.register(DisclaimerCell.self, forCellReuseIdentifier: "Cell")
        tblChat?.register(TextMsgCell.self, forCellReuseIdentifier: "TextMsgCell")
        tblChat?.register(PhotoMsgCell.self, forCellReuseIdentifier: "Cell2")
        tblChat?.register(ReplyViewCell.self, forCellReuseIdentifier: "Cell3")
        tblChat?.register(LocationMsgCell.self, forCellReuseIdentifier: "Cell4")//LocationMsgCell
        tblChat?.register(VideoMsgCell.self, forCellReuseIdentifier: "Cell5")//LocationMsgCell
        tblChat?.register(AudioMsgCell.self, forCellReuseIdentifier: "Cell6")//AudioMsgCell
        tblChat?.register(FileMsgCell.self, forCellReuseIdentifier: "Cell7") //FileMsgCell
        
        tblChat?.delegate = self
        tblChat?.dataSource = self
        tblChat?.backgroundColor = .clear
        tblChat?.separatorStyle = .none
        tblChat?.keyboardDismissMode = .onDrag
        tblChat?.showsVerticalScrollIndicator = false
        tblChat?.allowsMultipleSelectionDuringEditing = true
        
        tblChat?.backgroundView = UIImageView(image: UIImage(named: "Chat_BG"))
    }
    
    //MARK: -- Notification Listener
    func notificationListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVcCopy.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVcCopy.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVcCopy.closeReplyView(_:)), name: .close, object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVcCopy.attchmentIndexreceiver(_:)), name: .selectAttachmentAction, object:nil)
        txtMessage?.addDoneOnKeyboard(withTarget: self, action: #selector(DoneAction))
    }
    
    @objc func DoneAction(){
        txtMessage?.text = ""
        self.inputBottomViewConstraint.isActive = false
        self.inputBottomViewConstraint.constant = 50.0
        self.inputBottomViewConstraint.isActive = true
        txtMessage?.resignFirstResponder()
    }
    
    
    //MARK: --Resize TextView to default size
    private func didFinishedSendingMessage() {
        DispatchQueue.main.async { [self] in
            self.txtMessage?.isScrollEnabled = false
            //            self.replyView?.isHiddenreceiverData = true
            if isKeyboardShow != true{
                self.txtMessage?.text = "Enter Message"
            }
            self.txtMessage?.text = isKeyboardShow == false ? "" : "Enter Message"
            self.txtMessage?.textColor = isKeyboardShow == true ? .black: AppColors.primaryColor
            self.inputBottomViewConstraint.isActive = false
            self.inputBottomViewConstraint.constant = 50.0
            self.inputBottomViewConstraint.isActive = true
            
            self.inputBottomView?.layoutIfNeeded()
            self.inputBottomView?.layoutSubviews()
            self.inputBottomView?.setNeedsDisplay()
            if chatMsgArr?.count ?? 0 > 1 {
                self.tblChat?.scrollToBottom()
            }
        }
    }
    
    func dataBinding(){
        
        //ActivityController.shared.showActivityIndicator(uiView: view)
        viewModel?.getChatMessageLocal()
        viewModel?.AllChatMsg.bind(observer: { [self] (chat, _ )in
            print(viewModel?.selectedMessage.count)
            lblCountSelected?.text =  "\((viewModel?.selectedMessage.count ?? 0))"
            chatMsgArr = chat.value ?? []
            if viewModel?.isSelecting != true {
                if chatMsgArr?.count ?? 0 > 1 {
                    self.tblChat?.scrollToBottom()
                }
            }
          //  ActivityController.shared.hideActivityIndicator(uiView: view)
           
            tblChat?.reloadData()
        })
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -- uitableview Delegates Functions
extension MessageVcCopy: UITableViewDelegate, UITableViewDataSource ,ChatItemSelection {
    func audioCellTap(cell: AudioMsgCell) {
        let index = tblChat?.indexPath(for: cell)
        
        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
         urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
         
         btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
        
    }
    
    func audioValueChange(cell: AudioMsgCell, valeSlider: Float) {
        print(valeSlider)
        let index = tblChat?.indexPath(for: cell)
        audioPlayer?.currentTime = TimeInterval(valeSlider)
        timeDeactice = TimeInterval(valeSlider)
        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
         urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
         
         btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
    }
    
    
    func VideoSelected(cell: VideoMsgCell) {
        let index = tblChat?.indexPath(for: cell)
        
         if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 5 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0)  {
            
             let UrlVedio = "https://chat.chatto.jp:20000/meetingchat/" + (chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? " ")
             self.pushTo(viewController: videoPlayers(vedioUrl: UrlVedio))
            
        }
    }
    
    func IMGorMapSelected(cell: PhotoMsgCell) {
        
        let index = tblChat?.indexPath(for: cell)
        print(chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType)
        print(chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType)
        
         if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 1 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0  || (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 7 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0 )){
            
             let cellImage = AppUtils.shared.loadImage(fileName:chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "")
         
            if cellImage != nil{
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 7 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0 {
                    print("open map")
                    openMap(indexPath: index!)
                } else {
                    pushTo(viewController: previewImageVC(data:chatMsgArr![index!.section].messagesData![index!.row].messages?.message))
                }
                
            }
            else {
                //Start Download
                var isSnetData = false
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    isSnetData = false
                }
                
                else {
                    isSnetData = false        }
                
                viewModel?.StartDownloading(Messages: chatMsgArr!, location: index!)
                
                viewModel?.downloadImage(Messages: chatMsgArr!, imageName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", senderId: chatMsgArr![index!.section].messagesData![index!.row].messages?.senderId._id ?? "" , isSent: isSnetData, indexPath: index!)
                
                
            }
        }
    }
    
    func AudioSelected(cell: AudioMsgCell) {
        let index = tblChat?.indexPath(for: cell)
         if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 6 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0) {
            let cellImage = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", fileType: 6)
            
            if cellImage == nil{
                var isSnetData = false
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    isSnetData = false
                }
                
                else {
                    isSnetData = false        }
                
                viewModel?.StartDownloading(Messages: chatMsgArr!, location: index!)
                
                viewModel?.downloadAudio(Messages: chatMsgArr!, audioName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", senderId: chatMsgArr![index!.section].messagesData![index!.row].messages?.senderId._id ?? "" , isSent: isSnetData, indexPath: index!)
                
            }
            else{
                print("audio is ther just playit")
                
               // let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell6") as! AudioMsgCell
                let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
                urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
                
                btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
            }
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(viewModel?.AllChatMsg.value?.count ?? 0)
        
        print(chatMsgArr ?? [])
        
        if chatMsgArr?.count == 0{
            return 0
        }else{
            return chatMsgArr?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print(section)
        if section == 0 {
            return nil
        }else {
            
            let date = chatMsgArr![section].date
            let label = DateHeaderLabel()
            label.text = "\(date!)"
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerSuperView()
            return containerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMsgArr?[section].messagesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0, indexPath.section == 0 {
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell") as! DisclaimerCell
            cell.selectionStyle = .none
            return cell
        }else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 0 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0) {
            
            
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "TextMsgCell") as! TextMsgCell
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.isdelForward = isdelForward
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.chatData = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages
            cell.backgroundColor = UIColor.clear
            cell.mainView?.applyBottomShadow()
            //For blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            
            return cell
        }
        
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 0 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 1){
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell3") as! ReplyViewCell
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.commentSms = commentSms
            cell.isdelForward = isdelForward
            cell.selectionStyle = .none
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.dataSet = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
            
            cell.backgroundColor = UIColor.clear
            cell.mainView?.applyBottomShadow()
            //For blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            
            return cell
        }
        
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 6 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell6") as! AudioMsgCell
            cell.isdelForward = isdelForward
            cell.selectionStyle = .none
            cell.delegteAudioSelected = self
            cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
          
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.mainView?.applyBottomShadow()
            //for blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            return cell
        }
        
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 1 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
            cell.isdelForward = isdelForward
            cell.selectionStyle = .none
            cell.delegteImgViewSelected = self
            cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
            
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.backgroundColor = UIColor.clear
            //for blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            
            return cell
        }
        
        
        
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 5 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell5") as! VideoMsgCell
            cell.isdelForward = isdelForward
            cell.selectionStyle = .none
            cell.delegteVideoSelected = self
            cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.dataSet =  chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
            
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.backgroundColor = UIColor.clear
            //for blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            return cell
            
        }
        
        
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 2 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell7") as! FileMsgCell
            cell.isdelForward = isdelForward
            cell.selectionStyle = .none
            cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            
            cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
            configureCell(cell, forRowAtIndexPath: indexPath)
          
            cell.backgroundColor = UIColor.clear
            cell.mainView?.applyBottomShadow()
            //for blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            return cell
        }
        
        
        else {
            //used as map
            let cell = tblChat?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
            cell.selectionStyle = .none
            cell.delegteImgViewSelected = self
            cell.isdelForward = isdelForward
            cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
            cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
            cell.chatData = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages
            configureCell(cell, forRowAtIndexPath: indexPath)
            cell.backgroundColor = UIColor.clear
            //for blurr
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.mainView?.addInteraction(interaction)
            cell.mainView?.isUserInteractionEnabled = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  isLongPressAction! {
            viewModel?.updateCustomerSelection(Messages: chatMsgArr ?? [], location: indexPath)
        }
        else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 0 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 1) {
              var Secton = -1
            chatMsgArr?.forEach({ data in
                Secton = Secton + 1
//                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId._id)
//                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId.message)
//                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId.messageType)
//                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId.senderId._id)
//                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId._id)
                //print(data.messagesData?.first?.messages?.commentId._id)
  
                let  CommentSmsIndex =   data.messagesData?.firstIndex(where: {$0.messages?._id ==  (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.repliedTo._id ) })
                    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
                   
                    if CommentSmsIndex != nil {
                        print(Secton)
                        print(CommentSmsIndex)
                        let indexPath = IndexPath(row: CommentSmsIndex!, section: Secton)
                        tblChat?.scrollToRow(at: indexPath, at: .middle, animated: true)
//                        (indexPath , atScrollPosition: .Top, animated: true)
                       
                    }
                    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            })
            
//            chatMsgArr?.firstIndex(where: {$0.messagesData?.first?.messages?.commentId._id == (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId._id ) })

//
//            let filteredIndex = chatMsgArr?.firstIndex(where: {$0.messagesData?.first?.messages?._id == (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.commentId._id ) })
//            print(filteredIndex)
//
           
        }
        else  if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 2 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0) {
            
            let indexPathe = tblChat?.indexPathForSelectedRow //optional, to get from any UIButton for example
            
            let currentCell = tblChat?.cellForRow(at: indexPathe!) as! FileMsgCell
            
            print("oPEN Files Here....")
            let fileis = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
            let dataCompare = fileis.count > 38  ? String(fileis.dropFirst(37) ) : fileis
           
            
            var docPath =  DownloadData.sharedInstance.searchFileExist(fileName: dataCompare, fileType: 2)
            currentCell.imgdownloadFile.isHidden = true
            
            if docPath == "" || docPath == nil {
                var isSnetData = false
                if chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    isSnetData = false
                }
                else {
                    isSnetData = false   }
                
                viewModel?.StartDownloading(Messages: chatMsgArr!, location: indexPath)
                print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? "")
                viewModel?.dowloadFile(Messages: chatMsgArr!, fileName: chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? "", isSent: isSnetData, senderId: chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.senderId._id ?? "", indexPath: indexPath)
                
            }
            else{
                docPath = "file://" + docPath!
                OpenfileUrl = NSURL(string: docPath!)
                let quickLookViewController = QLPreviewController()
                quickLookViewController.dataSource = self
                self.present(quickLookViewController, animated: true, completion: nil)
            }
            
        }
        
        else {
            print("nil")
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset
     
            if distanceFromBottom - 145 <= height {
                btnScrollToBottom?.isHidden = true
            }
        else {
            btnScrollToBottom?.isHidden = false
        }
        
    }
}


//MARK: - UITextView Delegate
extension MessageVcCopy: UITextViewDelegate {
    
    

   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        SocketIOManager.sharedInstance.StartTyping(receiver_id: receiverData?.friendId ?? "")
//
        txtMessage?.text = ""
        textView.textColor = UIColor.black
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        SocketIOManager.sharedInstance.StopTyping(receiver_id: receiverData?.friendId ?? "")
//        if EditingEnable?.range(of:"Enter Message") != nil   {
//            //self.txtMessage?.text =  ""
//            btnRecoard?.isHidden = false
//            btnSend?.isHidden = true
//
//        }
//        else {
//            //self.txtMessage?.text = EditingEnable ?? ""
//            btnRecoard?.isHidden = false
//            btnSend?.isHidden = true
//        }
    }
    func textViewShouldEndEditing(_ textView: UITextView)  {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        SocketIOManager.sharedInstance.StartTyping(receiver_id: receiverData?.friendId ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            SocketIOManager.sharedInstance.StopTyping(receiver_id: self.receiverData?.friendId ?? "")
       })
      
        if txtMessage?.text?.range(of:"Enter Message") != nil   {
            txtMessage?.text = ""
            txtMessage?.textColor = UIColor.black
        }
        txtMessage?.text = "\(textView.text ?? "")"
        print(txtMessage?.text)
        
        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.btnSend?.isEnabled = false
            
            btnSend?.isHidden = true
            btnRecoard?.isHidden = false
            
        }else {
            self.btnSend?.isEnabled = true
          
            btnSend?.isHidden = false
            btnRecoard?.isHidden = true
        }
        
        if textView.contentSize.height >= 100 { // Max height of textView
            textView.isScrollEnabled = true
            
        } else {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
        }
        
        if textView.numberOfLines() < 7 && textView.numberOfLines() > 1 {
            textView.sizeToFit()
            let letterheightheight = textView.frame.height
            inputBottomViewConstraint.constant = letterheightheight + 20
            inputBottomViewConstraint.isActive = true
            textView.isScrollEnabled = true
        }
        else if textView.numberOfLines() == 1{
            textView.isScrollEnabled = false
            inputBottomViewConstraint.constant = 50
            inputBottomViewConstraint.isActive = true
        }else{
            textView.isScrollEnabled = true
        }
    }
}

//MARK: --Keyboard Open/Hide
extension MessageVcCopy {
    @objc func keyboardWillHide(_ sender: Notification) {
        containerViewConstraint.constant = 0
        containerViewConstraint.isActive = true
        isKeyboardShow = false
        print(txtMessage?.text!)
      if !(txtMessage?.text!.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
          if self.txtMessage?.text! != "Enter Message" {
            btnRecoard?.isHidden = true
            btnSend?.isHidden = false
            self.EditingEnable  = txtMessage?.text
          }
        }
        else {
                self.txtMessage?.text = "Enter Message"
                self.txtMessage?.textColor = AppColors.primaryColor
                self.EditingEnable  = ""
        }
        
       
        
       if let userInfo = (sender as NSNotification).userInfo {
            if ((userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height) != nil {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.tblChat?.alpha = 1
        self.tblChat?.isUserInteractionEnabled = true
        self.tblChat?.backgroundView = nil
        self.isKeyboardShow = true
        
        if EditingEnable == "" {
            self.txtMessage?.text = ""
            btnRecoard?.isHidden = false
            btnSend?.isHidden = true
        }
        else if isReply == true && self.txtMessage?.text == "Enter Message" {
            self.txtMessage?.text = ""
            btnRecoard?.isHidden = false
            btnSend?.isHidden = true
        }
        
        else if EditingEnable?.range(of:"Enter Message") != nil   {
            self.txtMessage?.text =  ""
            btnRecoard?.isHidden = true
            btnSend?.isHidden = false
            
        }
        else {
            self.txtMessage?.text = EditingEnable ?? ""
            btnRecoard?.isHidden = true
            btnSend?.isHidden = false
        }
        
        self.txtMessage?.textColor = .black
        if (sender as NSNotification).userInfo != nil {
            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                if self.view.frame.origin.y == 0{
                    self.view.layoutIfNeeded()
                    self.view.layoutSubviews()
                    self.view.setNeedsDisplay()
                    containerViewConstraint.constant = -(keyboardSize.height)
                    containerViewConstraint.isActive = true
                    
                    self.view.layoutIfNeeded()
                    self.view.layoutSubviews()
                    self.view.setNeedsDisplay()
                    if chatMsgArr?.count ?? 0 > 1 {
                        self.tblChat?.scrollToBottom()
                    }
                }
            }
        }
    }
    
    @objc func closeReplyView(_ sender: Notification){
        
        guard let userInfo = sender.userInfo,
              let _ = userInfo["close"] as? Bool else{ return }
        isReply = false
        commentId = ""
        
        tblCHatBottomConstraint?.isActive = false
        tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomView!.topAnchor, constant: -10)
        tblCHatBottomConstraint?.isActive = true
    }
}

extension MessageVcCopy: sendMessageDelegate{
    
    func sendAudioMessage(messageData: Any) {
        DispatchQueue.main.sync {
            messagesData(messag: [messageData], isProgress: true)
            // InsertFiledata(messag: [messageData], isProgress: true) }
        }
    }
    func sendTextMessage(messageData: Any) {
        
        messagesData(messag: [messageData], isProgress: true)
    }
    
    func sendMessage(messageData: Any) {
        print("Run")
        messagesData(messag: [messageData], isProgress: true)
        
    }
    
}

extension MessageVcCopy{
    func socketConnected(){
        SocketIOManager.sharedMainInstance.establishConnection()
        SocketIOManager.sharedInstance.addHandlers()
        SocketIOManager.sharedInstance.ConnectSocket()
        //MARK: -- GetChatMessages
        SocketIOManager.sharedInstance.getChatdumy()
        SocketIOManager.sharedInstance.getChatMessage { messageInfo in
            self.messagesData(messag: messageInfo, isProgress: false)
        }
        SocketIOManager.sharedInstance.StartTypingFriend { [self] data in
            print(data)
            lblOnline?.text = "typing..."
        }
        SocketIOManager.sharedInstance.StopTypingFriend { data in
            self.lblOnline?.text = "online"
        }
        
        
        SocketIOManager.sharedInstance.onlinestatus { [self] data in
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do{
                let jsonData = try decoder.decode([userOnlineStatus].self, from: jsonData!)
                let  usersObject = jsonData[0]
                statusColor = usersObject.status ?? 0 == 0 ?  .red : .green
                online?.backgroundColor = statusColor
                self.lblOnline?.text = usersObject.status ?? 0 == 0 ? "\(getMsgDate(date: receiverData?.createdAt ?? ""))" : "online"
            } catch let error as NSError{
                print(error)}
            
        }
        
        SocketIOManager.sharedInstance.receiveupdatedsms { [self] data in
            //chatMsgArr?[section].messagesData?.
            
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            do{
            let msgObject = try JSONDecoder().decode(Array<UpdateMessage>.self, from: jsonData!)
             
                if let filteredIndex = self.chatMsgArr?.firstIndex(where: {$0.date == msgObject.first?.createdAT }) {
                print(filteredIndex)
                    if let filerrow =  chatMsgArr?[filteredIndex].messagesData?.firstIndex(where: {$0.messages?._id == msgObject.first?.messageId }) {
                    print( chatMsgArr?[filteredIndex].messagesData?[filerrow].messages?.message = msgObject.first?.message)
                    let getindex = IndexPath(row: filerrow, section: filteredIndex)
                        tblChat?.reloadRows(at: [getindex], with: .none) }
                }
              
            }
            catch let error as NSError {
                print(error) }
            
        }
        
        
    }
}

extension MessageVcCopy {
    func messagesData(messag: Any, isProgress:Bool ){
        print(messag)
        let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
        do{
            
            let msgObject = try JSONDecoder().decode(Array<MessageResponseData>.self, from: jsonData!)
            print(msgObject)
            let count = 0
            
            let msgname = msgObject[count].msgData.message ?? ""
            switch msgObject[count].msgData?.messageType {
           
            case  1:
                let cellImage = AppUtils.shared.loadImage(fileName: msgObject[count].msgData.message ?? "")
                
            if cellImage == nil{
                DownloadData.sharedInstance.download(isImage: true, isVideo: false, isSent: false, name: msgObject[count].msgData.message ?? "" , senderId: msgObject[count].msgData.senderId?._id  ?? "" ) { (response, isDownloaded) in
                    self.tblChat?.reloadData()
                }
                    }
                
                break
            case  7:
                
                let dataCompare = msgname.count ?? 0 > 50  ? String(msgname.dropFirst(37) ?? "") : msgname ?? ""
               
                let cellImage = AppUtils.shared.loadImage(fileName: dataCompare)
                
            if cellImage == nil{
                DownloadData.sharedInstance.download(isImage: true, isVideo: false, isSent: false, name: msgObject[count].msgData.message ?? "" , senderId: msgObject[count].msgData.senderId?._id  ?? "" ) { (response, isDownloaded) in
                    self.tblChat?.reloadData()
                }
                    }
                
                break
            case  2:
            
                let dataCompare = msgname.count ?? 0 > 38  ? String(msgname.dropFirst(37) ?? "") : msgname ?? ""
                
               let docPath =  DownloadData.sharedInstance.searchFileExist(fileName: msgname, fileType: 2) ?? ""
                if docPath == "" {
                    
                    DownloadData.sharedInstance.download(isImage: false, isVideo: false, isSent: false, name: msgname , senderId: msgObject[count].msgData.senderId?._id  ?? "" ) { [self] (response, isDownloaded) in
                        DispatchQueue.main.async { [self] in
                            self.tblChat?.reloadData() }
                    }
                    
                }
                break
            
            case  6:
                
                let dataCompare = APIServices.shared.searchFileExist(fileName: msgObject[count].msgData.message ?? "", fileType: 6)
               
                APIServices.shared.downloadaudio(isSent: true, name: dataCompare ?? "", senderId: msgObject[count].msgData.senderId?._id  ?? "" ){ (response) in
                   
                        self.tblChat?.reloadData() }
                
                break
           
            default:
                break
            }
            
            
            
            if msgObject[count].msgData.receiverId ?? "" == "" {
                return
            }
            
            var messageDate = ""
            if msgObject[count].msgData.createdAt != "" {
                messageDate = msgObject[count].msgData.createdAt!.getActualDate()
            }
            
            if msgObject[count].msgData.senderId?._id == AppUtils.shared.senderID {
                print("it's updateing ")
            }
            else {
                print("it's not updateing ")
                
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    
                    chatMsgArr?[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: isProgress, isDownloading: false, messages: msgObject[count].msgData)])
                    
                    let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                    self.tblChat!.insertRows(at: [indexPath], with: .none)
                    self.tblChat!.scrollToBottom() }
            }
            
            if msgObject[count].msgData._id ==  "msgIDLocal" {
                print("Append Locaalyy")
//                if msgObject[0].msgData.receiverId?._id == AppUtils.shared.senderID {
//                    playSound(sound: "RecMessage", isRepeat: false)
//                }else{
//                    playSound(sound: "SendMessage", isRepeat: false)
//                }
                
//                if msgObject[count].msgData?.receiverId != receiverData?.friendId {
//                    return
//                }
                
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    chatMsgArr?[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: isProgress, isDownloading: false, messages: msgObject[count].msgData)])
                    
                    let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                    self.tblChat!.insertRows(at: [indexPath], with: .none)
                    self.tblChat!.scrollToBottom()
                    
                }
                else {
                    chatMsgArr?.append(ChatMessagesModel(isSelected: false, date: messageDate, messagesData: [ChatMessageModelselection(isSelected: false, isSending: isProgress , isDownloading: false, messages: msgObject[count].msgData)]))
                    
                    self.tblChat!.reloadData()
                    self.tblChat!.scrollToBottom()
                }
            }
            else {
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    playSound(sound: "RecMessage", isRepeat: false)
                    if let index = chatMsgArr![filteredIndex].messagesData!.firstIndex(where: {$0.messages?._id == msgObject[count].msgData._id})
                    {
                        print(index)
                        print("id is alredy there")
                        
                    }
                    
                    else {
                        
                        if let  index = chatMsgArr![filteredIndex].messagesData!.firstIndex(where: {$0.messages?._id == "msgIDLocal"})
                        {
                            playSound(sound: "SendMessage", isRepeat: false)
                            print(msgObject[count].msgData._id)
                            chatMsgArr![filteredIndex].messagesData![index].messages?._id = msgObject[count].msgData._id
                            chatMsgArr![filteredIndex].messagesData![index].messages?.message = msgObject[count].msgData.message

                            chatMsgArr![filteredIndex].messagesData![index].messages?.receipt_status = 0
                            chatMsgArr![filteredIndex].messagesData![index].messages?.seen = 0
                            chatMsgArr![filteredIndex].messagesData![index].messages?.isProgress = false
                            
                            chatMsgArr![filteredIndex].messagesData![index].isSending = true
                            
                            self.tblChat!.reloadRows(at: [IndexPath(row: index, section: filteredIndex)], with: .none)
                            self.tblChat!.scrollToBottom()
                            
                        }
                        else {
                            chatMsgArr?[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: isProgress, isDownloading: false, messages: msgObject[count].msgData)])
                            
                            let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                            self.tblChat!.insertRows(at: [indexPath], with: .none)
                            self.tblChat!.scrollToBottom()
                        }
                    }
                }
            }
        }catch let error as NSError {
            print(error)
        }
    }
    
    
}


extension MessageVcCopy {
    func InsertFiledata(messag: Any, isProgress:Bool ){
        print(messag)
        print(isProgress)
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
        do{
            let msgObject = try JSONDecoder().decode(Array<MessageResponseData>.self, from: jsonData!)
            
            let count = 0
            
            print(msgObject[0].msgData.repliedTo._id ?? "")
            
            if msgObject[count].msgData == nil{
                return
            }
            
            if msgObject[count].msgData.receiverId ?? "" == "" {
                return
            }
            
            var messageDate = ""
            if msgObject[count].msgData.createdAt != "" {
                messageDate = msgObject[count].msgData.createdAt!.getActualDate()
            }
            
            if msgObject[count].msgData.senderId?._id == AppUtils.shared.senderID {
                print("it's updateing ")
            }
            else {
                print("it's not updateing ")
                
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    
                    chatMsgArr?[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: false, isDownloading: false, messages: msgObject[count].msgData)])
                    
                    let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                    self.tblChat!.insertRows(at: [indexPath], with: .none)
                    self.tblChat!.scrollToBottom() }
            }
            
            if msgObject[count].msgData._id ==  "msgIDLocal" {
                print("Append Locaalyy")
                if msgObject[count].msgData?.receiverId != receiverData?.friendId {
                    return
                    
                }
                
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    chatMsgArr?[filteredIndex].messagesData?.append(contentsOf: [ChatMessageModelselection(isSelected: false, isSending: false, isDownloading: false, messages: msgObject[count].msgData)])
                    
                    
                    
                    let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                    self.tblChat!.insertRows(at: [indexPath], with: .none)
                    self.tblChat!.scrollToBottom()
                    
                }
                else {
                    chatMsgArr?.append(ChatMessagesModel(isSelected: false, date: messageDate, messagesData: [ChatMessageModelselection(isSelected: false, isSending: false, isDownloading: false,messages: msgObject[count].msgData)]))
                    self.tblChat!.reloadData()
                    self.tblChat!.scrollToBottom()
                }
            }
            else {
                if let filteredIndex = chatMsgArr?.firstIndex(where: {$0.date == messageDate}) {
                    
                    if let index = chatMsgArr![filteredIndex].messagesData!.firstIndex(where: {$0.messages?._id == msgObject[count].msgData._id}) {
                        print("id is alredy there")
                        
                    }
                    else {
                        print("id is not there update id..")
                        chatMsgArr![filteredIndex].messagesData!.last?.messages?._id = msgObject[count].msgData._id
                        chatMsgArr![filteredIndex].messagesData!.last?.messages?.receipt_status = 0
                        chatMsgArr![filteredIndex].messagesData!.last?.messages?.seen = 0
                        chatMsgArr![filteredIndex].messagesData!.last?.messages?.isProgress = false
                        
                        let indexPath = IndexPath(row: chatMsgArr![filteredIndex].messagesData!.count - 1, section: filteredIndex)
                         
                        self.tblChat!.reloadRows(at: [IndexPath(row: indexPath.row, section: filteredIndex)], with: .none)
                        self.tblChat!.scrollToBottom()
                    }
                }
            }
        }catch let error as NSError {
            print(error)
        }
    }
    
    
}




//Reply View...

//MARK: - ReplyView setUp UI
extension MessageVcCopy {
    
    func setUpReplayView(index: IndexPath){
        txtMessage?.text = ""
        commentId = ""
        self.replyView?.isHidden = true
        self.txtMessage?.becomeFirstResponder()
        let data = chatMsgArr![index.section].messagesData?[index.row]
        
        var decMessage = ""
        let msg = data?.messages?.message ?? ""+""
        let key = data?.messages?.senderId._id ?? ""  // length == 32
        let test = ""
        var  ivStr = key + test
        let halfLength = 16 //receiverId.count / 2
        let index1 = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
        ivStr.insert("-", at: index1)
        let result = ivStr.split(separator: "-")
        let iv = String(result[0])
        let s =  msg
        print("my sec id is auvc \(s)")
        do{
            decMessage = try s.aesDecrypt(key: key, iv: iv)
        }catch( let error ){
            print(error)}
        print("DENCRYPT",decMessage)
        commentData?.removeAll()
        commentData?.append((chatMsgArr![index.section].messagesData?[index.row].messages)!)
        
        commentId = chatMsgArr![index.section].messagesData?[index.row].messages?._id ?? ""
        
        let lblUserName = receiverData?.name != data?.messages?.senderId.name  ? "You" : "\(data?.messages?.senderId.name?.capitalizingFirstLetter() ?? "You")"
       
        switch data?.messages?.messageType {
        case 0 :
            replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: nil, titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                self.replyView?.isHidden = true }
        case 1:
            replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: UIImage(named: "GalleryIcon")?.imageWithColor(color1: .gray), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                      self.replyView?.isHidden = true
                  }
        case 2:
            replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: UIImage(named: "folder")?.imageWithColor(color1: .gray), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                      self.replyView?.isHidden = true
                  }
        case 5:
            replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: UIImage(systemName : "video")?.imageWithColor(color1: .gray), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                      self.replyView?.isHidden = true
                  }
        case 6:
                  replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: UIImage(named: "mic")?.imageWithColor(color1: .gray), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                        self.replyView?.isHidden = true
                    }
        case 7:
            replyView = ReplyView(title: lblUserName, message: "\(data?.messages?.message ?? "")", image: UIImage(named: "Location")?.imageWithColor(color1: .gray), titleColor: UIColor.red, messageColor: UIColor.black, BGColor: AppColors.incomingMsgColor, font: UIFont.font(.Poppins, type: .Medium, size: 12)){
                      self.replyView?.isHidden = true
                  }
            
        default :
            break
        }
        
        ReplyView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: { [self] in
            self.containerView?.addSubview(self.replyView!)
            replyView?.anchor(top: nil, leading: inputBottomView?.leadingAnchor, bottom: inputBottomView?.topAnchor, trailing: inputBottomView?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 0), size: .init(width: 0, height: 60))
            //update table view..
            tblCHatBottomConstraint?.isActive = false
            tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: replyView!.topAnchor, constant: -20)
            tblCHatBottomConstraint?.isActive = true
            
        })
    }
}

//MARK: - --Swip TableViewCell Delegate
extension MessageVcCopy: SwipyCellDelegate{
    
    func swipyCellDidStartSwiping(_ cell: SwipyCell) {
        
    }
    
    func swipyCellDidFinishSwiping(_ cell: SwipyCell, atState state: SwipyCellState, triggerActivated activated: Bool) {
        if activated{
            if let indexPath = tblChat?.indexPath(for: cell) {
                print(indexPath)
                isReply = true
                setUpReplayView(index: indexPath)
            }
        }
    }
    
    func swipyCell(_ cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat, currentState state: SwipyCellState, triggerActivated activated: Bool) {
        
    }
    
    func configureCell(_ cell: SwipyCell, forRowAtIndexPath indexPath: IndexPath) {
        let checkView = viewWithImageName("reply")
        let clearColor = UIColor.white
        cell.delegate = self
        cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: clearColor, completion: { cell, trigger, state, mode in
        })
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)?.imageWithColor(color1: AppColors.primaryColor)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
}




extension MessageVcCopy : UIContextMenuInteractionDelegate {
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let location = interaction.location(in: tblChat!)
        guard let indexPath = tblChat?.indexPathForRow(at: location) else {
            return nil
        }
        print(indexPath.row)
        print(indexPath.section)
        
        //        print(chatMessagesArr[indexPath.section].messages[indexPath.row].messageType)
        
        //        if chatMessagesArr[indexPath.section].messages[indexPath.row].messageType == 0//
        
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] _ -> UIMenu? in
//                smsStatus is used to indicate that sms send or recived.
            var issmsRecived = false
            if  chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                issmsRecived = true
            }
            else {
                issmsRecived = false
                
            }
            return self.createContextMenu(issmsRecived: issmsRecived, stringTocpy: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.message ?? "0", messageType: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.messageType ?? 0, indexRow: indexPath)
        }
        
    }
    
    func createContextMenu(issmsRecived: Bool,stringTocpy: String, messageType : Int, indexRow : IndexPath) -> UIMenu {
        print(issmsRecived)
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        
        
        let Edit = UIAction(title: "Edit", image: UIImage(named: "Edit")) { [self] _ in
            print("Share")
            isEditeing = true
            Editeingmsg_id = indexRow
            self.txtMessage?.becomeFirstResponder()
            EditingEnable = stringTocpy
            isLongPressAction = true
        }
        
        let reply = UIAction(title: "Reply", image: UIImage(named: "Reply-1")) { [self] _ in
            print("Copy")
            isReply = true
            setUpReplayView(index: indexRow)
            
        }
        
        let Forward = UIAction(title: "Forward", image: UIImage(named: "Forward")) { [self] _ in
            isLongPressAction = true
            isdeleted = false
            inputBottomOperationView?.isHidden = false
            inputBottomView?.isHidden = true
            tblCHatBottomConstraint?.isActive = false
            tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomOperationView!.topAnchor, constant: -20)
            tblCHatBottomConstraint?.isActive = true
            
            lblForwardDelete?.text = "Forward"
            
            BtnForwrdDelete?.setImage(UIImage(systemName: "arrow.turn.up.right"), for: .normal)
            BtnForwrdDelete?.setImageTintColor(.white)
            isdelForward = true
            
            viewModel?.updateCustomerSelection(Messages: chatMsgArr ?? [], location: indexRow)
            
        }
        let Copy = UIAction(title: "Copy", image: UIImage(named: "Copy")) { _ in
            UIPasteboard.general.string = stringTocpy
        }
        let Delete = UIAction(title: "Delete", image: UIImage(named: "trash")) { [self] _ in
            isLongPressAction = true
            isdeleted = true
            inputBottomOperationView?.isHidden = false
            inputBottomView?.isHidden = true
            tblCHatBottomConstraint?.isActive = false
            tblCHatBottomConstraint = self.tblChat?.bottomAnchor.constraint(equalTo: inputBottomOperationView!.topAnchor, constant: -20)
            tblCHatBottomConstraint?.isActive = true
            
            BtnForwrdDelete?.setImage(UIImage(systemName: systemImage.delete), for: .normal)
            
            lblForwardDelete?.text = "Delete"
            isdelForward = true
            
            viewModel?.updateCustomerSelection(Messages: chatMsgArr ?? [], location: indexRow)
        
        }
       
        if messageType == 0  &&  issmsRecived == false {
            return UIMenu( options: .displayInline, children: [Edit, reply, Forward, Copy , Delete ])
        }
        else if messageType == 0  &&  issmsRecived == true {
            return UIMenu( options: .displayInline, children: [reply, Forward, Copy, Delete ])
        }
        else {
            return UIMenu( options: .singleSelection, children: [reply, Forward, Delete])
        }
        
    }
}



//Audion recording data.

//MARK: --Record_View Delegates
extension MessageVcCopy: RecordViewDelegate{
    func onStart() {
        print("Start")
        stopSound()
        self.recordView?.isHidden = false
        btnRecoard?.tintColor = .white
       // btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .white), for: .normal)
        self.btnView.backgroundColor = AppColors.primaryColor
        recordView?.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.968627451, alpha: 1)
        self.startRecording()
    }
    
    func onCancel() {
        print("Cancel")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [self] (tim) in
            self.btnView.backgroundColor = .white
            self.recordView?.isHidden = true
            btnRecoard?.tintColor = .gray
          //  btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
            self.recordView?.backgroundColor = .clear
        }
        audioRecorder?.stop()
        audioRecorder = nil
        finishRecording(success: false)
    }
    
    func onFinished(duration: CGFloat) {
        print("Time")
        self.recordView?.isHidden = true
        self.btnView.backgroundColor = .white
        btnRecoard?.tintColor = .gray
        //btnRecoard?.setBackgroundImage(UIImage(named: "mic")?.imageWithColor(color1: .gray), for: .normal)
        self.recordView?.backgroundColor = .clear
        
        if duration > 0.9{
            Reachability.isConnectedToNetwork { [self] (isConnected) in
                if isConnected{
                    finishRecording(success: true)
                }else{
                    finishRecording(success: false)
                }
            }
        }else{
            finishRecording(success: false)
        }
    }
}


//MARK: --Start Recording
extension MessageVcCopy {
    func startRecording() {
        let audioFilename = createFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        do {
            if #available(iOS 13.0, *) {
                audioRecorder = AVAudioRecorder()
            }
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print(error)
            finishRecording(success: false)
        }
    }
    
    func createFileURL() -> URL {
        
        let timestamp = NSDate().timeIntervalSince1970
        audiofilename = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        audiofilename = "Audio_\(audiofilename).m4a"
        let folderurl = getDocumentsDirectory().appendingPathComponent("Audios")
        var newUrl:URL?
        do {
            try FileManager.default.createDirectory(atPath: folderurl.path, withIntermediateDirectories: true, attributes: nil)
            newUrl = folderurl.appendingPathComponent(audiofilename)
        } catch {
            print(error)
        }
        return newUrl! as URL
    }
    
    func getFileURL() -> URL {
        let filepath = "Audios/\(audiofilename)"
        let path = getDocumentsDirectory().appendingPathComponent(filepath)
        return path as URL
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        print(success)
        if audioRecorder != nil{
            audioRecorder?.stop()
            audioRecorder = nil
        }
        if success == true{
            print("Success")
            voicemsgstatus = 1
            do{
                let audioData = try Data(contentsOf: getFileURL() as URL)
                //database save recording
                
                viewModel?.sendFile(fileName : "\(audiofilename)", audioData: audioData , friendId: "\(receiverData?.friendId ?? "")", messageType: 6, receiptStatus: 0, receiverId: "\(receiverData?.friendId ?? "")")
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            voicemsgstatus = 0
        }
    }
}



extension MessageVcCopy {
    
    @objc func attchmentIndexreceiver(_ sender: Notification){
        guard let userInfo = sender.userInfo,
              let index = userInfo["select"] as? Int else{ return }
        
        switch index {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker = UIImagePickerController()
                imagePicker?.delegate = self
                imagePicker?.sourceType = .camera;
                imagePicker?.allowsEditing = false
                self.present(imagePicker!, animated: true, completion: nil)
            }
            break
        case 1:
            imagesConfig()
            break
        case 2:
            isSend = true
            perform(#selector(MapVC), with: nil, afterDelay: 0)
            break
        case 3:
            self.folderAction()
            print("filess")
        default:
            break
        }
    }
    
    @objc func MapVC(){
        let vc = LocationVC()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        self.images.removeAll()
        
        picker.dismiss(animated: true, completion: nil)
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        let fixOrientationImage = selectedImage.fixedOrientation()
        let timestamp = NSDate().timeIntervalSince1970
        print(timestamp)
        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        timestampname = timestampname + ".png"
        
        let resizedImage = fixOrientationImage.sd_resizedImage(with: CGSize(width: 900, height: 900), scaleMode: .aspectFill)
        
        
        let compt = UIImage(data: (resizedImage?.jpegData(compressionQuality: 0)!)!)
        
        if let data = compt?.jpegData(compressionQuality: 0) {
            let filesize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
            print(filesize)
            
        }
        
        
        compt?.writeImageToPath(name: timestampname)
        
        viewModel?.sendFile(image: compt!, fileName: timestampname, audioData: nil, friendId: "\(receiverData?.friendId ?? "")", messageType: 1, receiptStatus: 0, receiverId: "\(receiverData?.friendId ?? "")")
        
        
        self.images.removeAll()
        
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func imagesConfig(){
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        viewController.didExceedMaximumNumberOfSelection = { (picker) in
            self.ShowMessageAlert(inViewController: self, title: "", message: ConstantStrings.alertMessage.alert)
        }
        //        viewController.customDataSouces = CustomDataSources()
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.groupByFetch = .day
        configure.allowedLivePhotos = true
        configure.allowedPhotograph  = true
        configure.maxSelectedAssets = 10
        configure.maxVideoDuration = 150.0
        configure.selectedColor = AppColors.primaryColor
        configure.allowedVideoRecording = true
        configure.allowedAlbumCloudShared = false
        configure.allowedVideo = true
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        self.images.removeAll()
        // self.imageName.removeAll()
        var isSelectedImage = false
        let mutableImages: NSMutableArray! = []
        
        for asset: PHAsset in withPHAssets {
            if asset.mediaType == .video{
                self.encodePhasset(ivasset:asset)
                
            }else{
                isSelectedImage = true
                let targetSize = CGSize(width: 910 , height: 1500)
                print(targetSize.width)
                print(targetSize.height)
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.isNetworkAccessAllowed = true
                let phImage = asset.image(targetSize: targetSize, contentMode: .aspectFit, options: option)
                mutableImages.add(phImage)
            }
        }
        
        if isSelectedImage{
            if withPHAssets.count > 0{
                self.images = mutableImages.copy() as? NSArray as! [UIImage]
                if self.images.count > 0{
                    for i in 0..<self.images.count{
                        
                        let resizedImage = self.images[i].sd_resizedImage(with: CGSize(width: 910, height: 1700), scaleMode: .aspectFill)
                        let compt = UIImage(data: (resizedImage?.jpegData(compressionQuality: 0)!)!)
                        if let data = compt?.jpegData(compressionQuality: 0) {
                            let filesize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
                            print(filesize)
                            
                        }
                        
                        //                        let compressimg = self.images[i].checkimgsize()
                        let timestamp = NSDate().timeIntervalSince1970
                        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
                        timestampname = timestampname + ".png"
                        print(timestampname)
                        compt?.writeImageToPath(name: "\(timestampname)")
                        //   let imageData = compressimg.compressimage(.low)
                        
                        viewModel?.sendFile(image: compt!, fileName: timestampname, audioData: nil, friendId: "\(receiverData?.friendId ?? "")", messageType: 1, receiptStatus: 0, receiverId: "\(receiverData?.friendId ?? "")")
                        
                    }
                }
            }
        }
    }
    
    //Get Vedio details
    
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
    
    func hideCustomLoading(){
        DispatchQueue.main.async(execute: {
            print("Hide Loading Called.")
            //  hud.hide(animated: true)
            print("Hide Loading Called. hiden")
        })
    }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        self.ShowMessageAlert(inViewController: self, title: "", message: ConstantStrings.alertMessage.alert)
    }
    
    func selectedCameraCell(picker: TLPhotosPickerViewController) {}
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {}
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {}
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {}
    
}

//Location DELegate

extension MessageVcCopy: addLocationDelegate{
    func addLocation(locImage: UIImage, location: CLLocationCoordinate2D) {
        print("run")
        
        let timestamp = NSDate().timeIntervalSince1970
        var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        timestampname = timestampname + ".png"
        let imageName = "MAP_00\(timestampname)"
        let compressimg = locImage.checkimgsize()
        
        compressimg.writeImageToPath(name: "\(location.latitude)&\(location.longitude)&\(imageName)")
        print("\(location.latitude)-\(location.longitude)-\(imageName)")
        
        viewModel?.sendFile(image: compressimg, fileName: "\(location.latitude)&\(location.longitude)&\(imageName)", audioData: nil, friendId: "\(receiverData?.friendId ?? "")", messageType: 7
                            , receiptStatus: 0, receiverId: "\(receiverData?.friendId ?? "")")
        
        
        
    }
    
    func openMap(indexPath: IndexPath) {
        let message = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages?.message.split(separator: "&")
        print(chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages?.message)
        print(message?.count)
        if message?.count ?? 0 > 1{
            let latVal =   Double((message?[0])!)
            let longVal =   Double((message?[1])!)
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.canOpenURL(NSURL(string:
                                                        "comgooglemaps://?saddr=&daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)&directionsmode=driving")! as URL)
            }else{
                var direction:String = ""
                direction = "http://maps.apple.com/?daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)"
                let directionsURL = URL(string: direction)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(directionsURL!)
                } else {
                    UIApplication.shared.openURL(directionsURL!)
                }
            }
        }
    }
    
    
    
}



//Send Vedio to the server...... triming Vedio.....
extension MessageVcCopy : videoTrimDelegate {
    
    //Get Vedio details
    
    func encodePhasset(ivasset:PHAsset){
        if ivasset.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.deliveryMode = .automatic
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: ivasset, options: options) { [self] (asset, audiomix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    self.gotoVideoTrim(vidUrl:localVideoUrl)
                } else{
                    hideCustomLoading()
                    print("Asset is of not kind of AvUrlAsset.")
                }
            }
        }else if ivasset.mediaType == .image {
            let option = PHImageRequestOptions.init()
            PHImageManager.default().requestImage(for: ivasset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: option) { [self] (result, info) in
                if result != nil {
                    if (String(describing: info!["PHImageResultIsDegradedKey"]!) == "0"){
                    }
                }else{
                    hideCustomLoading()
                }
            }
        }
    }
    
    
    func gotoVideoTrim(vidUrl:URL){
        //   isImageCapturing = true
        DispatchQueue.main.async(execute: { [self] in
            hideCustomLoading()
            let asset = AVURLAsset.init(url: vidUrl as URL)
            let viewcontroller = VideoTrim_ViewController(nibName: "VideoTrim_ViewController", bundle: nil)
            viewcontroller.delegate = self
            viewcontroller.url = vidUrl
            viewcontroller.asset = asset
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        })
    }
    
    func didgetTrimedvideoduet(url: URL) {
        hideCustomLoading()
        do{
            let videoData = try Data(contentsOf: url)
            let timestamp = NSDate().timeIntervalSince1970
            var timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            timestampname = timestampname + ".mp4"
            print(url)
            print(videoData)
            DispatchQueue.main.async { [self] in
                
                
                viewModel?.sendFile(image: nil, fileName: "Video_\(timestampname)", audioData: nil, videoData: videoData, friendId: "\(receiverData?.friendId ?? "")", messageType: 5, receiptStatus: 0, receiverId: "\(receiverData?.friendId ?? "")")
                
                
            }
        }catch let error as NSError{ print(error.localizedDescription) }
    }
    
}

extension MessageVcCopy : QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return OpenfileUrl!
    }
}



//Pick file and writ it locally...

extension MessageVcCopy : UIDocumentPickerDelegate {
    
    public func folderAction(){
        var types: [String] = [kUTTypePDF as String]
        types.append(kUTTypeText as String)
        types.append(kUTTypeJSON as String)
        types.append(kUTTypeFolder as String)
        types.append(kUTTypeDirectory as String)
        types.append(kUTTypePDF as String)
        types.append(kUTTypeContent as String)
        types.append(kUTTypeData as String)
        types.append(kUTTypeItem as String)
        types.append(kUTTypeZipArchive as String)
        self.pickerController = UIDocumentPickerViewController(documentTypes: types, in: .open)
        self.pickerController!.delegate = self
        self.present(self.pickerController!, animated: true)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        let res = url.absoluteString.split(separator: ".")
        documentFromURL(pickedURL: url)
        let timestamp = NSDate().timeIntervalSince1970
        let timestampname = "\(timestamp)".replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        let fileName = "File_\(timestampname)." + String(res.last!)
        
        self.writeFileToPath(name: fileName, data: nil, fileFolderName: "Document", destinationUrl: urls[urls.count - 1])
        
        APIServices.shared.sendFile(receiverId: "\(receiverData?.friendId ?? "")", document: documents[documents.count - 1], docName: fileName, filesurl: urls[urls.count - 1], isGroup: false, receiptStatus: false, isSeen: false) { response, Progress, errorMessage in
            if response != nil{
                print(response)
                print(urls[urls.count - 1])
                //  self.writeFileToPath(name: fileName, data: nil, fileFolderName: "Document", destinationUrl: urls[urls.count - 1])
                
            }
            else{
                print(errorMessage)
            }
        }
    }
    
    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
            let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
            let fileList =  FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
            let document = Document(fileURL: pickedURL)
            documents.append(document)
            switch sourceType {
            case .files:
                let document = Document(fileURL: pickedURL)
                documents.append(document)
            case .folder:
                for case let fileURL as URL in fileList! {
                    if !fileURL.isDirectory {
                        let document = Document(fileURL: fileURL)
                        documents.append(document)
                    }
                }
            case .none:
                break
            }
        }
    }
    //write file to pateh
    func writeFileToPath(name:String,data:Data?,fileFolderName:String,destinationUrl:URL?) {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        var folderURL = documentsUrl.appendingPathComponent(fileFolderName)
        var fileUrl = folderURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            do{
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Error Writing Image: \(error)")
            }
            print("File does NOT exist1 -- \(fileUrl) -- is available for use")
            let data = data
            do {
                print("Write file")
                if let url = destinationUrl{
                    try FileManager.default.copyItem(at: url, to: fileUrl)
                    return
                }
                try data!.write(to: fileUrl)
            } catch {
                print("Error Writing Image: \(error)")
            }
        } else {
            print("This file exists -- something is already placed at this location")
        }
    }
    
}


extension MessageVcCopy: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(SelectedAudionRow?.row)
        print(SelectedAudionRow?.section)
        
        let visibleIndexPaths = tblChat?.indexPathsForVisibleRows
        let res = visibleIndexPaths?.contains(SelectedAudionRow!)
        if res == false {
            timeDeactice = 0.00
            audiotimer?.invalidate()
             timeDeactice = 0.00
            let setindexpath = IndexPath(row: 0, section:  0)
           
            SelectedAudionRow = setindexpath
           print("finishedPlayed audion")
             playstatus = -1
            return
      
        }
        let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
        let dummycell = self.tblChat?.cellForRow(at: indexpath) as! AudioMsgCell
        dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
        audiotimer?.invalidate()
        dummycell.audioslider?.value =  Float(0.0)
        timeDeactice = 0.00
        let setindexpath = IndexPath(row: 0, section:  0)
       
        SelectedAudionRow = setindexpath
       print("finishedPlayed audion")
         playstatus = -1
    }
    
    @objc func btnPlayAction(url: String, IndexpateRow : IndexPath){
    
        if audioPlayer?.isPlaying == true {
            if URL(string: url) != audioPlayer?.url! {
                timeDeactice = 0.00
                audioPlayer?.stop()
                audiotimer?.invalidate()
                playstatus = -1
                
                let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
             
                let visibleIndexPaths = tblChat?.indexPathsForVisibleRows
                let res = visibleIndexPaths?.contains(SelectedAudionRow!)
                if res == true {
                let dummycell = self.tblChat?.cellForRow(at: indexpath) as! AudioMsgCell
                dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
                dummycell.audioslider?.value =  Float(0.0)
                }
                
            }
            
        }
        
        else if URL(string: url) != audioPlayer?.url!  &&   SelectedAudionRow?.row  != nil {
            timeDeactice = 0.00
            audioPlayer?.stop()
            audiotimer?.invalidate()
            playstatus = -1
            
            let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
         
            let visibleIndexPaths = tblChat?.indexPathsForVisibleRows
            let res = visibleIndexPaths?.contains(SelectedAudionRow!)
            if res == true {
            let dummycell = self.tblChat?.cellForRow(at: indexpath) as! AudioMsgCell
            dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
            dummycell.audioslider?.value =  Float(0.0)
            }
            
        }
        
        else {
            print("not plauing")
        }
        
        print("Play/Puse")
        let stopCurrent = false
//        audioPlayer?.currentTime = 5
        let indexpath = IndexPath(row: IndexpateRow.row, section: IndexpateRow.section)
        let dummycell = self.tblChat?.cellForRow(at: indexpath) as! AudioMsgCell
       
        SelectedAudionRow = IndexpateRow
        print(url)
        print(IndexpateRow.row)
        if url != nil{
            
            if playstatus < 0{
                var error: NSError?
                do {
                    guard let audiourl = URL(string: url) else {return}
                    if audioPlayer != nil {
                        audioPlayer?.stop()
                        audiotimer?.invalidate()
                    }
                    audioPlayer = try AVAudioPlayer(contentsOf: audiourl)
                } catch let err as NSError {
                    error = err
                    self.audioPlayer = nil
                }
                if let err = error {
                    print("AVAudioPlayer error: \(err.localizedDescription)")
                }else {
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
                    
                    audioPlayer?.play()
                    audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
                }
                
                playstatus = 1
            }else if playstatus > 0{
               // timeDeactice = 0.00
                if ((audioPlayer?.isPlaying) == true){
                    audiotimer?.invalidate()
                    dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
                    self.audioPlayer?.pause()
                }else{
                    dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
                    audiotimer?.invalidate()
                    self.audioPlayer?.play()
                    audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
                }
            }else {
                timeDeactice = 0.00
                audioPlayer?.stop()
                playstatus = -1
              //  checckcellplaystatus(index: playcellindex, status: -1)
            }
        }
        
    }
   
    
        @objc func updateslider(sender:UISlider) {
            
            var clrimg = UIImage()
          
        print(urlPlayed!)
            print(SelectedAudionRow?.row ?? 0)
            print(SelectedAudionRow?.section ?? 0)
            var audioduration:Float? = 0
            var audiotimestring:String? = ""
            (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: urlPlayed!)!)
            let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
            if indexpath.section == 0 {
                audiotimer?.invalidate()
                return
            }
            
            let visibleIndexPaths = tblChat?.indexPathsForVisibleRows
            let res = visibleIndexPaths?.contains(indexpath)
            if res == false {
                
                timeDeactice += 0.01
                return
            }
            
            let dummycell = self.tblChat?.cellForRow(at: indexpath) as! AudioMsgCell
            dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
            dummycell.audioslider?.maximumValue = audioduration ?? 0.0
            print(audioduration)
            print(TimeInterval.self)


            dummycell.audioslider?.value =  Float(timeDeactice) //4.0//Float(audioPlayer!.currentTime)
            let currentTime1 = Int((audioPlayer?.currentTime)!)
            let minutes = currentTime1/60
            let seconds = currentTime1 - minutes * 60
            dummycell.audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String

            timeDeactice += 0.01
            print(timeDeactice)
            print(( dummycell.audioslider?.maximumValue ?? 0) + 1.00)
            if Float(timeDeactice)  >= ( dummycell.audioslider?.maximumValue ?? 0) + 1.00 {
                audiotimer?.invalidate()
                dummycell.audioslider?.value =  Float(0.0)
            }
        }
    
    
    
    
    //New Code OF THE Audeio Poalyere
    
    @objc func playAudio(url: String, IndexpateRow : IndexPath) {
        print("playAudio and  updata sliders..")
    }
    
    
    
    
    
    
}


