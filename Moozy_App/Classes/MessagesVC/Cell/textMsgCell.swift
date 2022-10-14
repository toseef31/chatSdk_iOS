//
//  textMsgCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 28/04/2022.
//

import Foundation
import UIKit
import SwipyCell

class TextMsgCell:  SwipyCell {
    
    var mainView: UIView?
    var replyView: UIView?
    
    var lblmessage: UILabel?
    var statusView: UIImageView?
    var lblDatetTimeDay: UILabel?
    var stack: UIStackView?
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    
    var heightBackView: NSLayoutConstraint!
    
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var ImgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var isdelForward : Bool? = false
     var isSmsSelected: Bool?  = false
    var chatData: chat_data? = nil{
        didSet{
            
            mainView?.backgroundColor = chatData?.receiverId == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor
           
            lblmessage?.textColor = chatData?.receiverId == AppUtils.shared.senderID ? AppColors.secondaryFontColor : AppColors.secondaryFontColor
            
             var decMessage = ""
            let msg = chatData?.message ?? ""+""
            let key = chatData?.senderId._id ?? ""  // length == 32
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
            print("\(chatData?.message ?? "")")
            lblmessage?.text = "\(chatData?.message ?? "")"

//            messageLabel.text = chatData?.message ?? ""
            lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
            
            if chatData?.receipt_status == 1 {
                statusView?.image = UIImage(systemName: "clock")
            }else{
                if chatData?.seen == 0 && chatData?.receipt_status == 1 {
                    statusView?.image = UIImage(systemName: "checkmark")
                }else{
                    statusView?.image = nil
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: { [self] in
                        statusView?.image = UIImage(named: "seen_double_check")
                        statusView?.setImageColor(color: AppColors.primaryColor)
                   })
                }
            }

            if  isSmsSelected == true {
                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
                ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
            } else {
                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
                ImgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
                
            }
            
            if chatData?.receiverId == AppUtils.shared.senderID {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                stackLeadingConstraint.isActive = true
                stackTrailingConstraint.isActive = false
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 16, clipToBonds: true)
                statusView?.isHidden = true
                
                leadingConstraint.isActive = false
                leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
                leadingConstraint.isActive = true
               print(isdelForward!)
                if isdelForward! {
                ImgRecivedSlected.isHidden = false
                imgSendSlected.isHidden = true
                    leadingConstraint.isActive = false
                    leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
                    leadingConstraint.isActive = true
                    
                }
                else{
                    ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
                
                
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                stackLeadingConstraint.isActive = false
                stackTrailingConstraint.isActive = true
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16, clipToBonds: true)
                statusView?.isHidden = false
                
                trailingConstraint.isActive = false
                trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
                trailingConstraint.isActive = true
                if isdelForward! {
                    
                ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = false
                    //ImgRecivedSlected.isHidden = false
                    
                    trailingConstraint.isActive = false
                    trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
                    trailingConstraint.isActive = true
                } else
                { ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
              
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    func initializedControls(){
        
        mainView = UIView(backgroundColor: UIColor.gray)
        
        
        lblmessage = UILabel(title: "", fontColor: UIColor.black, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        lblmessage?.numberOfLines = 0
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        lblDatetTimeDay = UILabel(title: "date??", fontColor: UIColor.gray, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//        stack = UIStackView(views: [lblDatetTimeDay!, statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
        stack = UIStackView(views: [lblDatetTimeDay!], axis: .horizontal, spacing: 5, distribution: .fill)
      
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        lblmessage?.translatesAutoresizingMaskIntoConstraints = false
        lblmessage?.numberOfLines = 0
    }
    
    func configureUI(){
        initializedControls()
       
        contentView.addSubview(mainView!)
        mainView?.addSubview(lblmessage!)
        contentView.addMultipleSubViews(views: stack!,ImgRecivedSlected,imgSendSlected)
        
        ImgRecivedSlected.isHidden = true
        imgSendSlected.isHidden = true
        
        heightBackView =   mainView?.widthAnchor.constraint(lessThanOrEqualToConstant: 190)
        heightBackView.priority = UILayoutPriority.init(999)
        heightBackView.isActive = true
        
       
        mainView?.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 0))
      
        ImgRecivedSlected.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil ,padding: .init(top: 0, left: 16 , bottom: 0, right: 0))
        ImgRecivedSlected.verticalCenterWith(withView: mainView!)
    
        imgSendSlected.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor ,padding: .init(top: 0, left: 0 , bottom: 0, right: 16))
        imgSendSlected.verticalCenterWith(withView: mainView!)
        ImgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
      
          
     lblmessage?.anchor(top:  mainView?.topAnchor, leading: mainView?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 15, bottom: 8, right: 15))
        
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 9, left: 0, bottom: 8, right: 0))
        
        leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = false
        
        trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
        stackLeadingConstraint.isActive = false
        
        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
        stackTrailingConstraint.isActive = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset =  CGSize(width: -3.0, height : 5.0) //.zero
        layer.shadowRadius = 0.1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
