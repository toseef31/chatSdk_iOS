//
//  disclaimerCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 20/05/2022.
//

import Foundation
import UIKit


class DisclaimerCell: UITableViewCell{
    
    var conteteView: UIView?
    var BoottomSheetView: UIView?
  
    var profileDataView : UIView?
    var profileViewe: ProfileView?
    
    var onlineView: UIView?
    var lblOnlineStaus : UILabel?
    
    var viewUserName : UIView?
    var lblUserName : UILabel?
    var statusColor: UIColor?
  
    var receiverData: friendInfoModel? = nil{
        didSet {
            let image =  receiverData?.profile_image ?? nil
            if image != "" && image != nil {
                print(receiverData?.profile_image ?? "")
                let imgUrl = profileUrl.Url
                print(imgUrl)
                if let url = URL(string: imgUrl){
                    profileViewe?.profileImagesss = "\(url)\(receiverData?.profile_image ?? "")"
                    //imgTitle?.profileImagesss = "\(url)\(dataSet?.friend.user_image ?? "")"
                }else {
                    profileViewe?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()
                }
                profileViewe?.titleProfile = ""
            } else {
                profileViewe?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()

            }
            lblUserName?.text = receiverData?.name ?? ""
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    func initilization(){
        print(SceenSize.deviceWidth)
        let statusOnline = receiverData?.onlineStatus == 0 ?  "offline" : "online"
        lblOnlineStaus = UILabel(title: "\(statusOnline)", fontColor: AppColors.BlackColor, alignment: .left, font: UIFont.font(.Roboto, type: .Light, size: 12))
        
        statusColor = receiverData?.onlineStatus == 1 ? .green : .red
        onlineView = UIView(backgroundColor: statusColor!, cornerRadius: 5)
        
        viewUserName = {
            let view = UIView(backgroundColor: #colorLiteral(red: 0.9490196078, green: 0.2078431373, blue: 0.2352941176, alpha: 1), cornerRadius:  SceenSize.deviceWidth/22,borderWidth: 1, maskToBounds: true)
            view.setGradientBackground(frame: CGRect(x: 0, y: 0, width: 1000, height: 20), colorLeft: AppGradentColor.colorLeft, colorRight: AppGradentColor.colorRight)
            
            lblUserName = UILabel(title: "\(receiverData?.name ?? "")", fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), alignment: .center, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Medium, size: 17))
            view.addSubview(lblUserName!)
            lblUserName?.fillSuperView()
            return view
        }()
        
        
       profileDataView = {
           let profileview = UIView()
          
           profileViewe = ProfileView(title: "\(receiverData?.name.checkNameLetter() ?? "")", font: UIFont.font(.Roboto, type: .Medium, size: 40), BGcolor: #colorLiteral(red: 0.04705882353, green: 0.831372549, blue: 0.7843137255, alpha: 1), titleFontColor: UIColor.white, borderColor: #colorLiteral(red: 0.04705882353, green: 0.831372549, blue: 0.7843137255, alpha: 1), borderWidth: 0, size: .init(width: SceenSize.deviceWidth/4, height: SceenSize.deviceWidth/4))
           profileViewe?.applyBottomShadow()
           profileview.addMultipleSubViews(views: profileViewe!)
             profileViewe?.fillSuperView()

           profileViewe?.isBound = true
           profileViewe?.titleProfile = receiverData?.name.checkNameLetter() ?? ""

            return profileview
        }()
        
        
            let image =  receiverData?.profile_image ?? nil
        print(receiverData?.profile_image)
            if image != "" && image != nil {

                let imgUrl = userImages.userImageUrl
                print(imgUrl)
                if let url = URL(string: imgUrl){
                    profileViewe?.profileImagesss = "\(url)\(receiverData?.profile_image ?? "")"
                    //imgTitle?.profileImagesss = "\(url)\(dataSet?.friend.user_image ?? "")"
                }else {
                    profileViewe?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()
                }
                profileViewe?.titleProfile = ""
            } else {
                profileViewe?.titleProfile = receiverData?.name != "" ? (receiverData?.name.checkNameLetter()) : "No Name".checkNameLetter()

            }
            lblUserName?.text = receiverData?.name ?? ""
        
    }
    
    func configureUI(){
        initilization()
      
        contentView.backgroundColor = UIColor.white
      
        conteteView = UIView(backgroundColor: .clear)
        
        conteteView?.translatesAutoresizingMaskIntoConstraints = false
       addMultipleSubViews(views: conteteView!)
        
        BoottomSheetView = UIView(backgroundColor: .white)
        BoottomSheetView?.roundCorners(corners: [.topLeft,.topRight], radius: 32, clipToBonds: false)
        BoottomSheetView?.applyContainerShadowA()
        
        
        conteteView?.addMultipleSubViews(views: profileDataView!,viewUserName!,BoottomSheetView!,onlineView!,lblOnlineStaus!)
        
        conteteView?.constraintsWidhHeight(size: .init(width: 0, height: 196))
     
        conteteView?.fillSuperView(padding: .init(top: 0, left: 0, bottom: 1, right: 0))
        
        
        
        profileDataView?.anchor(top: conteteView?.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 1, left: 0, bottom: 0, right: 0),size: .init(width: SceenSize.deviceWidth/4 , height: SceenSize.deviceWidth/4))
        profileDataView?.horizontalCenterWith(withView: conteteView!)
        
        
        viewUserName?.anchor(top: profileDataView?.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top:  15, left: 0, bottom: 0, right: 0),size: .init(width: SceenSize.deviceWidth/2.5, height: SceenSize.deviceWidth/9 ))
        viewUserName?.horizontalCenterWith(withView: conteteView!)
        
        conteteView?.bringSubviewToFront(viewUserName!)
        BoottomSheetView?.bringSubviewToFront(viewUserName!)
        BoottomSheetView?.anchor(top: viewUserName?.bottomAnchor, leading: conteteView?.leadingAnchor, bottom: conteteView?.bottomAnchor, trailing: conteteView?.trailingAnchor,padding: .init(top: -20, left: 0, bottom: 0, right: 0))
       
        onlineView?.anchor(top: profileDataView?.bottomAnchor, leading: profileDataView?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: -15, left: 0, bottom: 0, right: 0), size: .init(width: 10, height: 10))
        lblOnlineStaus?.anchor(top: nil, leading: onlineView?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 7, bottom: 0, right: 0))
        
        lblOnlineStaus?.verticalCenterWith(withView: onlineView!)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



