//
//  FriendListOperationVC.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 04/08/2022.
//

import Foundation
import UIKit
import SDWebImage

class friendOperationVC: UIViewController{
    
    var topHeaderView: UIView?
    var optionView: UIView?
    //TopHeaderView
    var btnBack: MoozyActionButton?
    var seperatorView: UIView?
    
    //OptionView
    var tblFriendList: UITableView?
    var operationType: String?
    //list of the Friends..
    var listFriendsArr : [AllFrind_Data] = []
    
    private var addItemsView: emptyView?
    var ViewModel : FriendListVM?
    init(OperationType : String) {
        ViewModel = FriendListVM(OperationType: OperationType)
        self.operationType = OperationType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBinding()
        configureUI()
        tblFriendList?.reloadData()
    }
    
    
    func dataBinding() {
        //Loader terminate after the data response
      
        ViewModel?.isLoader.bind { [self] (data, _) in
            if data.value == true {
                ActivityController.shared.showActivityIndicator(uiView: view)
               
            }else{
                ActivityController.shared.hideActivityIndicator(uiView: view)
               
            }
        }
        
        ViewModel?.listFriends.bind(observer: { [self] data, _  in
            
                if data.value?.count  != 0 {
                    listFriendsArr = data.value ?? []
                    tblFriendList?.backgroundView = nil
                    tblFriendList?.reloadData()
                }
                else{
                    print("noting is there ")
                }
        })
        
           
    }
    
    
    func initializedControls(){
        view.backgroundColor = UIColor.white
    addItemsView = emptyView(title: "No Friends Available")
        topHeaderView = {
            let view = UIView(backgroundColor: .white)
            
            let title = UILabel(title: operationType ?? "Friends", fontColor: AppColors.BlackColor, alignment: .center, font: UIFont.font(.Roboto, type: .Medium, size: 14))
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.BlackColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                print("Back")
                self.dismiss(animated: true, completion: nil)
                self.pop(animated: true)
            }
            
            view.addMultipleSubViews(views: title, btnBack)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 14, right: 0), size: backButtonSize)
            
            title.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            title.verticalCenterWith(withView: btnBack)
            
            return view
        }()
        
        
        
        optionView = {
            let hView = UIView(backgroundColor: UIColor.white)
            configureTableView()
            return hView
        }()
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: topHeaderView!, optionView!)
        
        topHeaderView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        topHeaderView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        
        optionView?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        //TopHeaderView Constraints
        btnBack?.anchor(top: topHeaderView?.safeAreaLayoutGuide.topAnchor, leading: topHeaderView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: backButtonSize)
        
        //OptionView Constraints
        optionView?.addSubview(tblFriendList!)
        tblFriendList?.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    //Configure Tableview
    func configureTableView(){
        
        tblFriendList = UITableView(frame: .zero, style: .plain)
        tblFriendList?.delegate = self
        tblFriendList?.dataSource = self
        tblFriendList?.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        tblFriendList?.separatorStyle = .none
        tblFriendList?.showsVerticalScrollIndicator = false
        tblFriendList?.backgroundView = nil
        ///Register TableView Cell
        tblFriendList?.register(friendOperationCell.self, forCellReuseIdentifier: "cell")
        
    }
}

extension friendOperationVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listFriendsArr.count == 0{
          
            tblFriendList?.backgroundView = addItemsView
    
        }
        
        return listFriendsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! friendOperationCell
        
        cell.selectionStyle = .none
        cell.dataSet = listFriendsArr[indexPath.row]
        cell.tittlSetting = operationType
        cell.onbtnActionTap = { [self] tittleAction in
            
            switch operationType
            {
            case "Muted Friend":
                APIServices.shared.muteFriend(muteId: listFriendsArr[indexPath.row]._id ?? "", muteType: 0, muteStatus: 0) { response, data in
                    print(response) }
                //remover from userdefault array
                 break
                
            case "Hidden Fiends":
                APIServices.shared.hideFriend(hideUserId: listFriendsArr[indexPath.row]._id ?? "", hideStatus: 0) { (response, errorMesage) in print("response")}
                break
                
            case "Blocked Friends":
                    APIServices.shared.blockUser(blockStatus: 0, blockUserId: listFriendsArr[indexPath.row]._id ?? "") { response, data in
                         }
                
                break
            default:
                break
            }
            
            //remove and updata data
            listFriendsArr.remove(at: indexPath.row)
            tblFriendList?.deleteRows(at: [indexPath], with: .fade)
            tblFriendList?.reloadData()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(listFriendsArr.count)
        print(listFriendsArr[indexPath.row].name ?? "")
        print(listFriendsArr[indexPath.row]._id ?? "")
        
    }
    
}



