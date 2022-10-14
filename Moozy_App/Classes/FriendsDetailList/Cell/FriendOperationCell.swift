//
//  FriendOperationCell.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 04/08/2022.
//

import Foundation
import UIKit
import SwiftUI

class friendOperationCell : UITableViewCell{
    var url = "https://chat.chatto.jp:21000/chatto_images/chat_images/"
    var imageDictionary = [NSURL: UIImage]()
    
    var lblProfileTitle: UILabel?
    var imgProfie = UIView(backgroundColor: AppColors.primaryColor , cornerRadius: 25, maskToBounds: true)
    
    var imgTitle :  UIImageView?
    var lblName: UILabel?
    var btnPerformAction : MoozyActionButton?
    var onbtnActionTap: onChangedValue<String>?
    var tittlSetting : String? = nil{
        didSet{
            switch tittlSetting
            {
             case "Muted Friend":
                btnPerformAction?.setTitle("UnMute", for: .normal)
                break
            case "Hidden Fiends":
                btnPerformAction?.setTitle("UnHide", for: .normal)
                break
            case "Blocked Friends":
                btnPerformAction?.setTitle("UnBlock", for: .normal)
                break
            default:
                break
            }
        }}
    
    var dataSet: AllFrind_Data? = nil {
        didSet{
            let image = dataSet?.profile_image ?? nil
            if image != "" && image != nil {
                
                let imgUrl = "\(profileUrl.Url)\(dataSet?.profile_image ?? "")"
                if let url = URL(string: imgUrl ?? ""){
                    imgTitle?.sd_setImage(with: url, completed: nil)
                    lblProfileTitle?.isHidden = true
                    imgTitle?.isHidden = false
                } else {
                    lblProfileTitle?.text = dataSet?.name != "" ? (dataSet?.name?.checkNameLetter()) : "No Name".checkNameLetter()
                    lblProfileTitle?.isHidden = false
                    imgTitle?.isHidden = true
                }
            } else {
                lblProfileTitle?.text = ""
                lblProfileTitle?.text = dataSet?.name != "" ? (dataSet?.name?.checkNameLetter()) : "No Name".checkNameLetter()
                lblProfileTitle?.isHidden = false
                imgTitle?.isHidden = true
             
            }
            lblName?.text = dataSet?.name ?? ""
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func initializedControls(){
      
        lblProfileTitle = UILabel(fontColor: UIColor.white, alignment: .center, font: UIFont.font(.Poppins, type: .Medium, size: 22))
        imgTitle = UIImageView(image: UIImage(named: "profile3")!, contentModel: .scaleAspectFill)
        
        
       // imgTitle = ProfileView(statusColor: UIColor.green, BGcolor: AppColors.primaryColor, titleFontColor: UIColor.white, showStatus: false, size: .init(width: 50, height: 50))
        
        lblName = UILabel(fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Roboto, type: .Medium, size: 12))
    }
    
    func configureUI(){
        initializedControls()
        
        btnPerformAction =  MoozyActionButton(title: "", font: UIFont.font(.Poppins, type: .Medium, size: 12), foregroundColor: AppColors.BlackColor , backgroundColor: .white) { [self] in
            //self.present(settingVC(), animated: true, completion: nil)
            self.onbtnActionTap?(btnPerformAction?.title ?? "")
           }
        let bottomBorder = UIView(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2878406853), maskToBounds: true)
        contentView.backgroundColor =  AppColors.secondaryColor
        contentView.addMultipleSubViews(views: imgProfie, lblName! , bottomBorder , btnPerformAction! )
        imgProfie.addMultipleSubViews(views: imgTitle!, lblProfileTitle!)

        imgTitle?.fillSuperView()
        lblProfileTitle?.fillSuperView()
        imgProfie.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 18, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        imgProfie.verticalCenterWith(withView: contentView)

        lblName?.anchor(top: nil, leading: imgProfie.trailingAnchor, bottom: nil, trailing: btnPerformAction?.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
        btnPerformAction?.verticalCenterWith(withView: imgProfie)
        btnPerformAction?.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 12))
        
        lblName?.verticalCenterWith(withView: imgProfie)
        bottomBorder.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 1, bottom: 1, right: 1),size: .init(width: 0, height: 0.8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
