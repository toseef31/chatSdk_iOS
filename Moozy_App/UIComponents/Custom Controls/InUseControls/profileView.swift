//
//  profileView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import SwiftUI
import SDWebImage
//Custom View
class ProfileView: UIView{
    
    var imgProfile: UIImage?
    var profileTitle: String
    var size: CGSize
    var statusColor: UIColor?
    var BGColor: UIColor = UIColor.white
    var borderColor: CGColor = UIColor.blue.cgColor
    var titleFontColor: UIColor? = UIColor.blue
    var borderWidth: CGFloat?
    var showStatus: Bool? = false
    var font: UIFont?
    var statusView: UIView?
    var userProfileImage: UIImageView?
    var title: UILabel?
    
    var name : String?
    
    let mainView = UIView()
    let view = UIView()

    init(imgProfile: UIImage? = nil, title: String = "", font: UIFont = UIFont.font(.Poppins, type: .Bold, size: 12), statusColor: UIColor = UIColor.red,  BGcolor: UIColor = UIColor.white, titleFontColor: UIColor? = UIColor.blue, borderColor: CGColor = UIColor.blue.cgColor, borderWidth: CGFloat? = 0, showStatus: Bool? = false, size: CGSize, frame: CGRect = .zero) {
        
        self.imgProfile = imgProfile
        self.profileTitle = title
        self.font = font
        self.statusColor = statusColor
        self.size = size
        self.BGColor = BGcolor
        self.titleFontColor = titleFontColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showStatus = showStatus
        
        super.init(frame: frame)
        configureUI()
    }
    
    var status: Bool = false{
        didSet{
            statusView?.backgroundColor = status == true ? #colorLiteral(red: 0, green: 0.8901960784, blue: 0.3725490196, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            statusView?.isHidden = status == true ? false : true
        }
    }
    
    var isBound: Bool = false{
        didSet{
            clipsToBounds = isBound
        }
    }
    
    var profileImage: UIImage? = nil{
        didSet{
            userProfileImage = UIImageView(image: profileImage!, contentModel: .scaleAspectFill)
            view.addSubview(userProfileImage!)
            userProfileImage?.fillSuperView()
        }
    }
    
    
    var profileImagesss : String? = nil{
        didSet{
            userProfileImage = UIImageView(image: UIImage(named: "profile3")! , contentModel: .scaleAspectFill)
           
            let imgUrl = profileImagesss
            if let url = URL(string: imgUrl ?? ""){
                userProfileImage?.sd_setImage(with: url, completed: nil)
            }else {
               
            }
            view.addSubview(userProfileImage!)
            userProfileImage?.fillSuperView()
        }
    }
    
    
    var titleProfile: String? = ""{
        didSet{
            title = UILabel(title: titleProfile ?? "", fontColor: titleFontColor!, alignment: .center, font: font!)
            view.addSubview(title!)
            title?.centerSuperView()
        }
    }

    func configureUI(){
        
        backgroundColor = BGColor
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth!
        constraintsWidhHeight(size: size)
        layer.cornerRadius = size.height/2
        layer.masksToBounds = true
        
        statusView = UIView(backgroundColor: statusColor!, cornerRadius: 8/2)
        self.addSubview(mainView)
        mainView.addSubview(view)
        self.addSubview(statusView!)
        
        view.setGradientBackground(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), colorLeft: AppGradentColor.colorLeft, colorRight: AppGradentColor.colorRight)
        
        statusView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 2.5, bottom: 0, right: 0), size: .init(width: 8, height: 8))
        
        statusView?.isHidden = showStatus == true ? false : true
        
//        title = UILabel(title: profileTitle, fontColor: titleFontColor!, alignment: .center, font: font!)
        
        self.bringSubviewToFront(mainView)
        mainView.bringSubviewToFront(view)
        view.bringSubviewToFront(statusView!)
        self.bringSubviewToFront(statusView!)
//        
//        view.addSubview(title!)
//        title?.centerSuperView()
        
        mainView.fillSuperView()
        view.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


