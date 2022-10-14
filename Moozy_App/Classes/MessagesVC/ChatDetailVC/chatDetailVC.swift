//
//  chatDetailVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 28/04/2022.
//

import Foundation
import UIKit
import SDWebImage

class ChatDetailVC: UIViewController{
    
    var topHeaderView: UIView?
    var callView: UIView?
    var optionView: UIView?
    //TopHeaderView
    var btnBack: MoozyActionButton?
    var profileView: ProfileView?
    var lblUserName: UILabel?
    var lblRingName: UILabel?
    var btnRefresh: MoozyActionButton?
    
    var headerStack: UIStackView?
    
    //CallView
    var btnAudioCall: CallView?
    var btnVideoCall: CallView?
    var seperatorView: UIView?
    var callStack: UIStackView?
    
    //OptionView
    var tblOptionList: UITableView?
    var receiverData: friendInfoModel?
    
    let listArray = ConstantStrings.chatOptions.options
    
    init(receiverData: friendInfoModel? = nil) {
        self.receiverData = receiverData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configureUI()
       
    }
    override func viewDidAppear(_ animated: Bool) {
       
//        registerNotification()
//        configureUI()
    }
    
    func registerNotification() {
      
//    NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationFuncName), name: NSNotification.Name(rawValue: "aNotificationName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideFriend), name: NSNotification.Name(rawValue: "hideNotificationName"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlemutenotification), name: NSNotification.Name(rawValue: "muteNotificationName"), object: nil)
      
    }
    
    @objc func handleHideFriend (_ notification: Notification) {
        
        if let viewController = navigationController?.viewControllers.first(where: {$0 is ChatListVC}) {
              navigationController?.popToViewController(viewController, animated: false)
        }
        
       // let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
     // self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
   
    @objc func handleNotificationFuncName(_ notification: Notification) {
        tblOptionList?.reloadData()
    }
    @objc func handlemutenotification(_ notification: Notification) {
        if receiverData?.ismute == 1 {
            receiverData?.ismute = 0
        } else {
            receiverData?.ismute = 1 }
        tblOptionList?.reloadData()
    }
    
    func initializedControls(){
        view.backgroundColor = UIColor.white
        
        topHeaderView = {
            let hView = UIView(backgroundColor: UIColor.black)
            
            btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                print("Back")
                self.pop(animated: true)
            }
            
            profileView = ProfileView(title: "\(receiverData?.name.checkNameLetter() ?? "")", font: UIFont.font(.Roboto, type: .Medium, size: 26), BGcolor: AppColors.primaryColor, titleFontColor: AppColors.secondaryColor, borderColor: AppColors.secondaryColor.cgColor, borderWidth: 2, size: .init(width: 100, height: 100))
            profileView?.isBound = true
            
            let image = receiverData?.profile_image ?? nil
            if image != "" && image != nil {
            
                let imgUrl = "\(profileUrl.Url)\(receiverData?.profile_image ?? "")" //url
                if let url = URL(string: imgUrl){
                    profileView?.profileImagesss = "\(url)"
                   } else {
                    profileView?.profileImage = UIImage(named: "profile3")
                }
            }
            else{
                profileView?.titleProfile = "\(receiverData?.name.checkNameLetter() ?? "")"
            }
            
            lblUserName = UILabel(title: "\(receiverData?.name ?? "")", fontColor: AppColors.secondaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .SemiBold, size: 14))
            
            lblRingName =  UILabel(title: "Taj Ring' Ring", fontColor: AppColors.secondaryColor, alignment: .left)
            lblRingName?.font = UIFont.boldSystemFont(ofSize: 12)
            
            btnRefresh = MoozyActionButton(image: UIImage(systemName: "gobackward"), foregroundColor: AppColors.secondaryColor,imageSize: .init(width: 20, height: 20)) {
                print("refresh")
            }
            
            btnRefresh?.constraintsWidhHeight(size: .init(width: 20, height: 20))
            headerStack = UIStackView(views: [lblRingName!, btnRefresh!], axis: .horizontal, spacing: 10, distribution: .fill)
            
            return hView
        }()
        
        callView = {
            let hView = UIView(backgroundColor: AppColors.primaryColor, maskToBounds: true)

            btnAudioCall = CallView(img: UIImage(systemName: "phone")!, title: "Voice Call", font: UIFont.font(.Poppins, type: .SemiBold, size: 14), fontColor: AppColors.primaryFontColor, BGColor: AppColors.secondaryColor, forgroundColor: AppColors.primaryColor, imageSize: .init(width: 45, height: 45), action: {
                print("Audio Call")
            })
            
            btnVideoCall = CallView(img: UIImage(systemName: "video")!, title: "Video Call", font: UIFont.font(.Poppins, type: .SemiBold, size: 14), fontColor: AppColors.primaryFontColor, BGColor: AppColors.secondaryColor, forgroundColor: AppColors.primaryColor, imageSize: .init(width: 45, height: 45), action: {

                print("video Call")
            })
            seperatorView = UIView(backgroundColor: AppColors.secondaryColor)

            return hView
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
        topHeaderView?.addMultipleSubViews(views: btnBack!, profileView!, lblUserName!)
        
        topHeaderView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.width/1.5))
        
//        callView?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.width/3.5))
        
        optionView?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        //TopHeaderView Constraints
        btnBack?.anchor(top: topHeaderView?.safeAreaLayoutGuide.topAnchor, leading: topHeaderView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: backButtonSize)
        
        profileView?.centerSuperView(xPadding: 0, yPadding: 0)
        
        lblUserName?.anchor(top: profileView?.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        lblUserName?.horizontalCenterWith(withView: profileView!)

        let view1 = UIView(backgroundColor: .clear)
        let view2 = UIView(backgroundColor: .clear)
        
        //CallView Constraints
        callView?.addMultipleSubViews(views: view1, seperatorView!, view2)
        view1.addSubview(btnAudioCall!)
        view2.addSubview(btnVideoCall!)
        
        
        seperatorView?.anchor(top: callView?.topAnchor, leading: nil, bottom: callView?.bottomAnchor, trailing: nil, padding: .init(top: 12, left: 0, bottom: 12, right: 0), size: .init(width: 1, height: 0))
        seperatorView?.horizontalCenterWith(withView: callView!)
        
        view1.anchor(top: callView?.topAnchor, leading: callView?.leadingAnchor, bottom: callView?.bottomAnchor, trailing: seperatorView?.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        view2.anchor(top: callView?.topAnchor, leading: seperatorView?.trailingAnchor, bottom: callView?.bottomAnchor, trailing: callView?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        btnAudioCall?.constraintsWidhHeight(size: .init(width: 80, height: 80))
        btnVideoCall?.constraintsWidhHeight(size: .init(width: 80, height: 80))
        
        btnAudioCall?.centerSuperView()
        btnVideoCall?.centerSuperView()

        //OptionView Constraints
        optionView?.addSubview(tblOptionList!)
        tblOptionList?.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    //Configure Tableview
    func configureTableView(){
        tblOptionList = UITableView()
        tblOptionList?.register(OptionCallCell.self, forCellReuseIdentifier: "cell")
        tblOptionList?.delegate = self
        tblOptionList?.dataSource = self
        tblOptionList?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblOptionList?.showsVerticalScrollIndicator = false
        tblOptionList?.isScrollEnabled = false
    }
}

extension ChatDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OptionCallCell
        cell.ismuted = receiverData?.ismute  ?? 0
        cell.setData = listArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let data = listArray[indexPath.row]
        let value = data.title?.components(separatedBy: " ")
        
        var name = value![0]
        
        switch index {
        case 0:
           
            if receiverData?.ismute == 1 {
                 name = "UnMute Friend"
            }
            else{
                name = value![0]
               print("not found")
            }
           
            ShowPopUp(PopView: PopupAlertView(imageName: data.image, title: name, subTitle: "Do you really want to \(name)?", cases: 0, muteId: receiverData?.friendId  ?? "",ismuted: receiverData?.ismute ?? 0))
            break
        case 1:
            
            ShowPopUp(PopView: PopupAlertView(imageName: data.image, title: name, subTitle: "Do you really want to \(name)?", ReciverId: receiverData?.friendId  ?? "", cases: 1))
            break
        case 2:
            
            let ary = AppUtils.shared.blockUserUsere ?? []
            if ary.contains(receiverData?.friendId  ?? "") {
                 name = "UnBlock Friend"
            }
            else{
                name = value![0]
               print("not found")
            }
            if ary.contains(receiverData?.friendId  ?? "") {
                 name = "UnBlock Friend"
            }
            else{
                name = value![0]
               print("not found")
            }
            
            ShowPopUp(PopView: PopupAlertView(imageName: data.image, title: name, subTitle: "Do you really want to \(name)?", cases: 2 , muteId: receiverData?.friendId  ?? ""))
            break
            
        case 3:
            
            ShowPopUp(PopView: PopupAlertView(imageName: data.image, title: name, subTitle: "Do you really want to \(name)?", ReciverId: receiverData?.friendId  ?? "", cases: 3))
            
        
            
            break
        case 4:
            print("Chat background")
            break
        default:
            break
        }
    }
}

extension ChatDetailVC{
    
//    perform(#selector(MapVC), with: nil, afterDelay: 0)
//
//    @objc func MapVC(){
//        let vc = LocationVC()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        self.present(vc, animated: true, completion: nil)
//    }
    
}
