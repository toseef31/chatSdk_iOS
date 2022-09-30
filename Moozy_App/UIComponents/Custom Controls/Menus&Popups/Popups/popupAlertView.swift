//
//  PopupAlertView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

protocol userDetailProtocol {
    func yesAction(isTrue: Bool)
}

class PopupAlertView: UIViewController {
    
    var titleImge: UIImageView?
    var lblTitle: UILabel?
    var lblSubTitle: UILabel?
    var btnYes: MoozyActionButton?
    var btnCancel: MoozyActionButton?
    var popView = UIView(backgroundColor: UIColor.white, cornerRadius: 12)
    
    var imgView: UIView?
    
    var imageName: UIImage?
    var titles: String?
    var subTitle: String?
    
    var delegate: userDetailProtocol?
    var reciverId = ""
    var actionClicked = 0
    var muted_id = ""
    var ismuted = 0
    init(imageName: UIImage? = nil, title: String? = "", subTitle: String? = "",ReciverId : String? = "", cases : Int, muteId: String? = "" , ismuted : Int? = 0 ){
        self.imageName = imageName
        self.titles = title
        self.subTitle = subTitle
        self.reciverId = ReciverId ?? ""
        self.actionClicked = cases
        self.muted_id = muteId ?? ""
        self.ismuted = ismuted ?? 0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func initializedControls(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        imgView = UIView(backgroundColor: UIColor.white, cornerRadius: 80/2, borderColor: UIColor.black.cgColor, borderWidth: 2, maskToBounds: true)
        
        titleImge = UIImageView(image: imageName!, contentModel: .scaleAspectFit)
        titleImge?.setImageColor(color: AppColors.primaryColor)
        
        lblTitle = UILabel(title: titles!, fontColor: AppColors.primaryColor, alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Bold, size: 12))
        
        lblSubTitle = UILabel(title: subTitle!, fontColor: UIColor.black, alignment: .center, numberOfLines: 2, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        btnYes = MoozyActionButton(title: "Yes", font: UIFont.font(.Poppins, type: .Bold, size: 12), foregroundColor: AppColors.secondaryColor, backgroundColor: AppColors.primaryColor, cornerRadius: 15, borderColor: AppColors.primaryColor, borderWidth: 1){ [self] in
            delegate?.yesAction(isTrue: true)
          
        switch actionClicked {
            case 0:
            
                if ismuted == 1  {
                    APIServices.shared.muteFriend(muteId: muted_id, muteType: 0, muteStatus: 0) { response, data in
                        print(response)
                        NotificationCenter.default.post(name: Notification.Name("muteNotificationName"), object: nil,userInfo: nil)
                        
                    }
                    //updata mute in coredatabase
                }
                else{
                    APIServices.shared.muteFriend(muteId: muted_id, muteType: 0, muteStatus: 1) { response, data in
                        print(response)
                        NotificationCenter.default.post(name: Notification.Name("muteNotificationName"), object: nil,userInfo: nil)
                      
                    }
                }
                
            case 1:
                print("Hide Fried")
            APIServices.shared.hideFriend(hideUserId: reciverId, hideStatus: 1) { (response, errorMesage) in
                print(response)
                   NotificationCenter.default.post(name: Notification.Name("hideNotificationName"), object: nil,userInfo: nil)
//               }
            }
           
            
            case 2:
            
                APIServices.shared.blockUser(blockStatus: 1, blockUserId: muted_id) { response, data in
                     self.dismiss(animated: true, completion: nil)
                    
                    NotificationCenter.default.post(name: Notification.Name("hideNotificationName"), object: nil,userInfo: nil)
                    //updata unblock in coredatabase
                }
                
            case 3:
                APIServices.shared.deleteAllChat(receiverId: reciverId) { Response, Error in
                    UserDefaults.removeSpecificKeys(key: "\(AppUtils.shared.user?._id ?? "")\(reciverId)")
                  
                    NotificationCenter.default.post(name: Notification.Name("hideNotificationName"), object: nil,userInfo: nil)
                }
                
            default:
                print(" Fried")
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        btnCancel = MoozyActionButton(title: "Cancel", font: UIFont.font(.Poppins, type: .Bold, size: 12), foregroundColor: AppColors.secondaryFontColor, backgroundColor: UIColor.clear, cornerRadius: 15, borderColor: UIColor.gray, borderWidth: 1){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI(){
        initializedControls()
        
        view.addSubview(popView)
        popView.addMultipleSubViews(views: imgView!, lblTitle!, lblSubTitle!, btnYes!, btnCancel! )
        imgView?.addSubview(titleImge!)
        popView.constraintsWidhHeight(size: .init(width: totalWidth - 50, height:  290))
        popView.centerSuperView()
        
        imgView?.anchor(top: popView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        imgView?.horizontalCenterWith(withView: popView)
        
        titleImge?.fillSuperView(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        
        lblTitle?.anchor(top: imgView?.bottomAnchor, leading: popView.leadingAnchor, bottom: nil, trailing: popView.trailingAnchor, padding: .init(top: 18, left: 12, bottom: 0, right: 12))
        
        lblSubTitle?.anchor(top: lblTitle?.bottomAnchor, leading: popView.leadingAnchor, bottom: nil, trailing: popView.trailingAnchor, padding: .init(top: 15, left: 12, bottom: 0, right: 12))
        
       
        btnCancel?.anchor(top: nil, leading: nil, bottom: popView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 196, height: 45))
        
        btnYes?.anchor(top: nil, leading: nil, bottom: btnCancel?.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 196, height: 45))
        
        btnCancel?.horizontalCenterWith(withView: popView)
        btnYes?.horizontalCenterWith(withView: popView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
