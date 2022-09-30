//
//  chatListVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import SwiftUI

import SwiftyJSON

public class ChatListVC: UIViewController, UISearchBarDelegate {
    
   var lastsmsid = ""
    var lastsms = ""
    public var topHeaderView: UIView?
    public var tblChatList: UITableView?
    public var searchBar: UISearchBar?
    var btnSearchClose: MoozyActionButton?
    var btnSearch: MoozyActionButton?
    var btnSetting : MoozyActionButton?
    public var btnAddChat: UIView?
    
    var deleteImage = UIImage()
    var hideImage = UIImage()
    var readImage = UIImage()
    var unreadImage = UIImage()
    
    var read: Int = 0
    private let refreshControl = UIRefreshControl()
    private var listChatView: [friendInfoModel] = []
    private var SearchlistChatView: [friendInfoModel] = []
    private var viewModel: ChatListVM?
    var frien = [Friend_Data]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChatListVM()
        UIApplication.shared.statusBarStyle = .lightContent
        dataBinding()
        configureUI()
        addTapGesture()
        tblChatList?.reloadData()
        socketConnected()
        
    }
    
   
    
    func dataBinding() {
        
        listChatView = viewModel?.listOfFriends.value ?? []
        tblChatList?.reloadData()
        viewModel?.listOfFriends.bind(observer: { [self] chat, _  in
            
                if chat.value?.count  != 0 {
                    listChatView = viewModel?.listOfFriends.value ?? []
                    SearchlistChatView = viewModel?.listOfFriends.value ?? []
                    tblChatList?.reloadData()
                }
                else{
                    print("noting is there ")
                }
        })
        
           
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        viewModel = ChatListVM()
        UIApplication.shared.statusBarStyle = .lightContent
        dataBinding()
        configureUI()
        addTapGesture()
        tblChatList?.reloadData()
        socketConnected()
        
        tblChatList?.reloadData()
       
        
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
       // viewModel = ChatListVM()
    }
    
    
    //MARK: -- InitializedControls
    private func initializedControls(){
        view.backgroundColor = UIColor.white
        
        topHeaderView = {
            let view = UIView(backgroundColor: AppColors.secondaryColor)
            let btnLogout = MoozyActionButton(image: UIImage(systemName: systemImage.logOut), foregroundColor: AppColors.primaryColor, imageSize: .init(width: 25, height: 25)){ [self] in
                //Change status to offline..
             let fcmKey =   AppUtils.shared.getFCMToken()
                AppUtils.shared.clearSession()
                AppUtils.shared.saveFCMToken(fcmToken: fcmKey)
               // onlineStatusUpdate(onlineStatus: 0)
                viewModel?.db.DeleteAllFriends()
                pushTo(viewController: LoginVC())
            }
            
            let lblTitle = UILabel(title: "Chats", fontColor: AppColors.primaryColor, alignment: .center, font: UIFont.font(.Poppins, type: .Regular, size: 16))
            
            searchBar = UISearchBar()
            self.searchBar?.delegate = self
            searchBar?.backgroundColor = AppColors.secondaryColor
            searchBar?.searchTextField.textColor = UIColor.black
            searchBar?.searchBarStyle = UISearchBar.Style.minimal
            searchBar?.placeholder = "Search"
            searchBar?.searchTextField.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
            searchBar?.searchTextField.tintColor = AppColors.primaryColor
            searchBar?.setSearchFieldBackgroundImage(UIImage(), for: .normal)
            searchBar?.searchTextField.layer.cornerRadius = 35/2
            
            btnSearch = MoozyActionButton(image: UIImage(systemName: systemImage.search), foregroundColor: AppColors.primaryColor, imageSize: .init(width: 20, height: 20)){ [self] in
                print("Search")
                searchBar?.isHidden = false
                btnSearchClose?.isHidden = false
                btnSearch?.isHidden = true
            }
            btnSetting  = MoozyActionButton(image: UIImage(systemName: systemImage.setting), foregroundColor: AppColors.primaryColor, imageSize: .init(width: 20, height: 20)){ [self] in
                //self.present(settingVC(), animated: true, completion: nil)
                
                self.pushTo(viewController: settingVC())
            }
            
            
            btnSearchClose = MoozyActionButton(image: UIImage(systemName: systemImage.close), foregroundColor: AppColors.primaryColor, imageSize: .init(width: 20, height: 20)){ [self] in
                print("Close")
                searchBar?.text
                listChatView = (true ? SearchlistChatView : listChatView.filter { $0.name.range(of: "", options: .caseInsensitive) != nil })
                
                tblChatList?.reloadData()
                searchBar?.isHidden = true
                btnSearchClose?.isHidden = true
                btnSearch?.isHidden = false
                searchBar?.searchTextField.text = nil
                self.dismissKeyboard()
            }
            
            view.addMultipleSubViews(views: btnLogout, lblTitle, btnSearch!, searchBar!, btnSetting! ,btnSearchClose!)
            lblTitle.centerSuperView(xPadding: 0, yPadding: 20)
            
            btnLogout.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 30))
            btnLogout.verticalCenterWith(withView: btnSearch!)
            
            btnSetting?.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 12), size: .init(width: 30, height: 30))
            
            
            btnSearch?.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: btnSetting?.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 8), size: .init(width: 30, height: 30))
            
            searchBar?.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: btnSearchClose?.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 8, right:  4), size: .init(width: 0, height: 40))
            
            btnSearchClose?.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: btnSetting?.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 8), size: .init(width: 30, height: 30))
            
            searchBar?.isHidden = true
            btnSearchClose?.isHidden = true
            
            return view
        }()
        
        btnAddChat = {
            let view = UIView(backgroundColor: AppColors.primaryColor, cornerRadius: 50/2)
            let img = UIImageView(image: UIImage(systemName: "plus")!, contentModel: .scaleAspectFill)
            view.addSubview(img)
            img.constraintsWidhHeight(size: .init(width: 25, height: 25))
            img.setImageColor(color: UIColor.white)
            img.centerSuperView()
            return view
        }()
        
        configureTableView()
        
        //    refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = AppColors.primaryColor
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        deleteImage = createImage(txt: "Delete", img: UIImage(named: "ic-Delete")!, size: 55.0)
        hideImage = createImage(txt: "Hide", img: UIImage(named: "eye")!, size: 55.0)
        unreadImage = createImage(txt: "Unread", img: UIImage(named: "Unread")!, size: 55.0)
        readImage = createImage(txt: "Read", img: UIImage(named: "Read")!, size: 55.0)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        viewModel = ChatListVM()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.20) {
            self.refreshControl.endRefreshing()
            self.tblChatList?.reloadData()
        }
    }
    
    //MARK: -- Setup UI
    private func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: topHeaderView!, btnAddChat!, tblChatList!)
        
        topHeaderView?.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.width/4.8))
        
        tblChatList?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        btnAddChat?.anchor(top: nil, leading: nil, bottom: tblChatList?.bottomAnchor, trailing: tblChatList?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 35, right: 25), size: .init(width: 50, height: 50))
        
        view.bringSubviewToFront(btnAddChat!)
        tblChatList?.bringSubviewToFront(btnAddChat!)
        // Add Refresh Control to Table View
        tblChatList?.addSubview(refreshControl)
    }
    
    //MARK: ---Configure Tableview
    private func configureTableView(){
        tblChatList = UITableView()
        tblChatList?.register(ChatListCell.self, forCellReuseIdentifier: ConstantStrings.cell)  ///Register TableView Cell
        tblChatList?.delegate = self
        tblChatList?.dataSource = self
        tblChatList?.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        tblChatList?.separatorStyle = .none
        tblChatList?.allowsMultipleSelectionDuringEditing = true
        tblChatList?.showsVerticalScrollIndicator = false
        tblChatList?.reloadData()
    }
    
    private func addTapGesture(){
        btnAddChat?.addTapGesture(tagId: 0, action: { _ in
            print("Add Chat")
            self.pushTo(viewController: NewChatVC())
        })
    }
    
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        listChatView = (searchText.isEmpty ? SearchlistChatView : listChatView.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil })
        tblChatList?.reloadData()
    }
}

//MARK: ---Configure Tableview Delegates
extension ChatListVC: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listChatView.count != 0{
            return listChatView.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantStrings.cell) as! ChatListCell
        
        cell.chatData = listChatView[indexPath.row]
        cell.lblName?.text = listChatView[indexPath.row].name
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let receiverData = listChatView[indexPath.row]
        print("The user name is \(receiverData.name)")
        pushTo(viewController: MessageVcCopy(receiverData: receiverData))
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "", handler: { [self] (action, view, completion) in
           
            let receiverID = listChatView[indexPath.row].friendId ?? ""
            let index = indexPath.row
//            listChatView.remove(at: index)
//            tblChatList?.deleteRows(at: [indexPath], with: .fade)
            listChatView[indexPath.row].message = ""
            tblChatList?.reloadData()
            Reachability.isConnectedToNetwork { isConnected in
                if isConnected{
                    viewModel?.deleteAllChat(receiverId: receiverID, onCompletion: { isDeleted, errorMessage in
                        if isDeleted!{
                            viewModel = ChatListVM()
                            print("delete")

                        }else{
                            viewModel = ChatListVM()

                            print("error")
                        }
                    })
                } else {
                    print("No internet")
                }
            }
            completion(true)
        })
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        let hideAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "", handler: { [self] (action, view, completion) in
            print("Hide Action")
            let index = indexPath.row
            let receiverID = listChatView[indexPath.row].friendId ?? ""
            listChatView.remove(at: index)
            tblChatList?.deleteRows(at: [indexPath], with: .fade)
            
            APIServices.shared.hideFriend(hideUserId: receiverID, hideStatus: 1) { (response, errorMesage) in
                print(response)
                viewModel = ChatListVM()
            }
            
            completion(true)
        })
        
        hideAction.image = hideImage
        hideAction.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,hideAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    public func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        listChatView = (searchBar?.text?.isEmpty ?? true ? listChatView : listChatView.filter { $0.name.range(of: searchBar?.text ?? "", options: .caseInsensitive) != nil })
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantStrings.cell) as! ChatListCell
        //FAFAFA
        let readAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "", handler: { [self] (action, view, completion) in
            print("Read Action")
            
           
            if self.listChatView[indexPath.row].receipt_status == 1  &&  self.listChatView[indexPath.row].messageCounter == 0 {
                 //read chat......
                viewModel?.updateReciptStuts(FriendId: listChatView[indexPath.row].friendId, reciptStatus: 0)
                self.tblChatList!.reloadRows(at: [indexPath], with: .none)
                
            }
            else if self.listChatView[indexPath.row].receipt_status == 0  &&  self.listChatView[indexPath.row].messageCounter == 0 {
                //read chat......
               viewModel?.updateReciptStuts(FriendId: listChatView[indexPath.row].friendId, reciptStatus: 1)
               self.tblChatList!.reloadRows(at: [indexPath], with: .none)
               
           }
            
            else{
                // call on unread chat..
                viewModel?.updateReciptStuts(FriendId: listChatView[indexPath.row].friendId, reciptStatus: 0)
                self.tblChatList!.reloadRows(at: [indexPath], with: .none)
                
            }
            completion(true)
        })
        
        readAction.image = readImage
        readAction.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        if self.listChatView[indexPath.row].receipt_status == 1  || self.listChatView[indexPath.row].messageCounter != 0 {
            readAction.image = readImage
        }
        else{
            readAction.image = unreadImage
        }
        
        
        let pinAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: ConstantStrings.chatString.pin, handler: { (action, view, completion) in
            print("Pin Action")
            completion(true)
        })
        pinAction.image = UIImage(systemName: systemImage.pin)
        pinAction.image?.withTintColor(UIColor.gray)
        pinAction.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [readAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension ChatListVC{
    func socketConnected(){
        SocketIOManager.sharedMainInstance.establishConnection()
        SocketIOManager.sharedInstance.addHandlers()
        SocketIOManager.sharedInstance.ConnectSocket()
        
        SocketIOManager.sharedInstance.getChatMessage { messageInfo in
            self.parseSocketMsg(messag: messageInfo)
        }
        SocketIOManager.sharedInstance.onlinestatus { [self] data in
            print(data)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do{
                let jsonData = try decoder.decode([userOnlineStatus].self, from: jsonData!)
                let  usersObject = jsonData[0]
               
                let index = self.listChatView.firstIndex(where: {$0.friendId == usersObject.userId ?? ""})
               
                if index != nil {
                    print(usersObject.status ?? 0)
                    print(index)
                    listChatView[index!].onlineStatus = usersObject.status ?? 0
                   }
                tblChatList?.reloadData()
                
            
            } catch let error as NSError{
                print(error)}
            
        }
        
        SocketIOManager.sharedInstance.StartTypingFriend { [self]  datas in
            
            let jsonData = try? JSONSerialization.data(withJSONObject: datas, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do{
                let jsonData = try decoder.decode([MessageRe].self, from: jsonData!)
                let  usersObject = jsonData[0]
                print(usersObject.sender_id ?? "")
               let index = self.listChatView.firstIndex(where: {$0.friendId == usersObject.sender_id ?? ""})
               
                if index != nil {
                    if listChatView[index!].message != "typing..." || listChatView[index!].message == "" {
                        lastsms = listChatView[index!].message
                    }
                    
                    listChatView[index!].message = "typing..."
                   
                   }
                tblChatList?.reloadData()
                
            
            } catch let error as NSError{
                print(error)}
        }
        SocketIOManager.sharedInstance.StopTypingFriend { [self]  datas in
            
            let jsonData = try? JSONSerialization.data(withJSONObject: datas, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do{
                let jsonData = try decoder.decode([MessageRe].self, from: jsonData!)
                let  usersObject = jsonData[0]
                print(usersObject.sender_id ?? "")
               let index = self.listChatView.firstIndex(where: {$0.friendId == usersObject.sender_id ?? ""})
               
                if index != nil { listChatView[index!].message = lastsms }
                tblChatList?.reloadData()
                
            } catch let error as NSError{
                print(error)}
        }
        
        
        
     }
    
    func parseSocketMsg(messag: Any){
        print(messag)
        viewModel = ChatListVM()
        let jsonData = try? JSONSerialization.data(withJSONObject: messag, options: .prettyPrinted)
        let decoder = JSONDecoder()
        do{
            let jsonData = try decoder.decode([MessageResponseData].self, from: jsonData!)
            let  usersObject = jsonData[0]
            
            if listChatView.count != 0 {
                var index:Int? = nil
                var sendByMe = false
                
                if usersObject.msgData._id == "" {
                    print("no data")
                    return
                }
                if  lastsmsid == usersObject.msgData._id {
                    return
                }
                else {
                    lastsmsid = usersObject.msgData._id
                }
               
                print(usersObject.msgData.receiverId)
                print(AppUtils.shared.user?._id ?? "")
                if usersObject.msgData.senderId._id == usersObject.msgData.receiverId ?? "" {
                    sendByMe = true
                    return
//                    index = self.listChatView.firstIndex(where: {$0.friendId == usersObject.msgData.senderId?._id})
                }else{
                    sendByMe = false
                    index = self.listChatView.firstIndex(where: {$0.friendId == usersObject.msgData.senderId?._id})
                   // index =  self.listChatView.firstIndex(where: {$0.friendId == usersObject.msgData.receiverId})
                }
                
                let indeex = listChatView.firstIndex(where: {$0.friendId ==  usersObject.msgData.receiverId })
                if index != nil {
                    listChatView[index!].message = usersObject.msgData.message ?? "np"
                    listChatView[index!].messageCounter = listChatView[index!].messageCounter + 1
                    listChatView[index!].createdAt = usersObject.msgData.createdAt ?? ""
                    listChatView[index!].messageType = usersObject.msgData.messageType ?? 0
                    
                   }
                tblChatList?.reloadData()
                
            }
            
            
        }catch let error as NSError{
            print(error)}
    }
    
    
    }
    




