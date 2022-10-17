//
//  newChatVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 27/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class NewChatVC: UIViewController, UISearchBarDelegate {
    
    var topHeaderView: UIView?
    var tblChatList: UITableView?
   public var searchBar: UISearchBar?
    
    var lblAllFrinds: UILabel?
    var sortedContacts :[Friend_DataModel]!
    var userInfo :[Friend_DataModel]!
    var users = [Friend_DataModel]()
    
    var userDictionary = [String:[Friend_DataModel]]()
    var  isSearching = false
    var userSection = [String]()
    var isForwardOperation = false
    var btnForward : MoozyActionButton?
    var viewModel: AllFriendsVM?
    var selecteMessage : [chat_data]? = []
    var addItemsView = emptyView(title: "No Friends Available")
    init(selectedMessages: [chat_data]? = []) {
        viewModel = AllFriendsVM()
        selecteMessage = selectedMessages
        if selectedMessages?.count != 0 {
            isForwardOperation = true
        }
        else { isForwardOperation = false}
        super.init(nibName: nil, bundle: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        
        dataBinding()
       searchBar?.delegate = self
        
    }
    func dataBinding() {
        viewModel?.allFriendList.bind(observer: { [self] (data, _ )in
            
            userDictionary = data.value!
            tblChatList?.reloadData()
          
        })
        
        viewModel?.userSections.bind(observer: { [self] observable,_ in
            userSection = observable.value ?? []
        })
    }
    
    
    func initializedControls(){
        view.backgroundColor = UIColor.white
        
        topHeaderView = {
            let view = UIView(backgroundColor: AppColors.secondaryColor)
            
            btnForward = MoozyActionButton(title: "Forward", font: UIFont.font(.Roboto, type: .Medium, size: 12), foregroundColor: AppColors.BlackColor, backgroundColor: .clear ) { [self] in
                print("Forward click")
                if viewModel?.selecteFriends.count ?? 0 >= 1 {
                    viewModel?.sendMessage(message: selecteMessage ?? [])
                }
                self.pop(animated: true)
            }
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.BlackColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                print("Back")
                
                self.pop(animated: true)
            }
            var Tittleis = ""
            if isForwardOperation != true {
                Tittleis = "Chats"
                btnForward?.isHidden = true
            }
            else {
                Tittleis = "Select Friends"
                btnForward?.isHidden = false
            }
            let lblTitle = UILabel(title: Tittleis , fontColor: AppColors.BlackColor, alignment: .center, font: UIFont.font(.PottaOne, type: .Medium, size: 16))
            
            view.addMultipleSubViews(views: btnBack, lblTitle,btnForward!)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 25))
            btnBack.verticalCenterWith(withView: lblTitle)
            
            lblTitle.centerSuperView(xPadding: 0, yPadding: 20)
            btnForward?.verticalCenterWith(withView: lblTitle)
            btnForward?.anchor(top: nil, leading: nil , bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 75, height: 25))
            return view
        }()
        
        
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
        
        
        lblAllFrinds = UILabel(title: "All Friends", fontColor: UIColor.gray, alignment: .left, font: UIFont.font(.Poppins, type: .Bold, size: 16))
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: topHeaderView!, searchBar!, lblAllFrinds!, tblChatList!)
       
        topHeaderView?.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.width/4.8))
        
        searchBar?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 55))
       lblAllFrinds?.anchor(top: searchBar?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 12))
        
        tblChatList?.anchor(top: lblAllFrinds?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var array = viewModel?.Allusers //dbHelper.shareInstance.getFriendsData()
        viewModel?.userInfo.removeAll()
        array = (searchText.isEmpty ? array : array?.filter { $0.name?.range(of: searchText, options: .caseInsensitive) != nil })
        array?.forEach { data in
            viewModel?.userInfo.append(Friend_DataModel(isSelected: false, FrienList: data))
        }

        viewModel?.sorting()
        tblChatList?.reloadData()
    }
    
    //MARK: ---Configure Tableview
    func configureTableView(){
        tblChatList = UITableView(frame: .zero, style : .plain)
        tblChatList?.register(NewChatCell.self, forCellReuseIdentifier: ConstantStrings.cell)  ///Register TableView Cell
        tblChatList?.delegate = self
        tblChatList?.dataSource = self
        tblChatList?.backgroundColor = AppColors.secondaryColor
        tblChatList?.separatorStyle = .none
        tblChatList?.allowsMultipleSelectionDuringEditing = true
        tblChatList?.showsVerticalScrollIndicator = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      print(userSection.count)
        if userSection.count == 0 {
            tblChatList?.backgroundView = addItemsView
            return userSection.count
        }
        tblChatList?.backgroundView = nil
        
       
        return userSection.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if userSection.count == 0 {
            return 0
        }
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let lblTitle = UILabel(title: userSection[section].uppercased(), fontColor: UIColor.gray, alignment: .left, font: UIFont.font(.Poppins, type: .Bold, size: 12))
        
        view.addSubview(lblTitle)
        lblTitle.fillSuperView(padding: .init(top: 1, left: 12, bottom: 1, right: 4))
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        let userKey = userSection[section]
        tblChatList?.backgroundView = nil
       if isSearching{
            return 1
        }else{
            if let users = userDictionary[userKey] {
                return users.count
            }
        }
        if let users = userDictionary[userKey] {
            return users.count
        }
       return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantStrings.cell) as! NewChatCell
        
        
        let userKey = userSection[indexPath.section]
        if let users = userDictionary[userKey.uppercased()] {
            let data = users
            cell.dataSet = data[indexPath.row]
            cell.isSelectedFriend = data[indexPath.row].isSelected ?? false
            cell.selectionStyle = .none
            return cell
        }
        
        
        let data = sortedContacts
        cell.dataSet = data?[indexPath.row]
        cell.isSelectedFriend = data?[indexPath.row].isSelected
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userKey = userSection[indexPath.section]
        if let users = userDictionary[userKey.uppercased()] {
            let data = users //ConstantStrings.Frinds.friendList[indexPath.section].names[indexPath.row]
            let receiverData = data[indexPath.row]
            
            if isForwardOperation == true {
                
                viewModel?.updateCustomerSelection(userKey: userKey, location: indexPath)
            }
            else {
                let inputFriend = friendInfoModel()
                              
                inputFriend.message = ""
                inputFriend.messageType  = 0
                inputFriend.receipt_status  = 0
                inputFriend.createdAt = ""
                inputFriend.messageCounter  = 0
                inputFriend.friendId = receiverData.FrienList?._id ?? ""
                inputFriend.name = receiverData.FrienList?.name ?? ""
                inputFriend.profile_image = receiverData.FrienList?.profile_image ?? ""
                inputFriend.onlineStatus  = receiverData.FrienList?.onlineStatus ?? 0
                inputFriend.ismute  = 1
               
                pushTo(viewController: MessageVcCopy(receiverData: inputFriend, ChatMessages: []))
                
            }
        }
    }
}
