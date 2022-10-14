//
//  replyViewCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 20/05/2022.
//

import Foundation
import UIKit
import SwipyCell

class ReplyViewCell: SwipyCell {
    
    var mainView: UIView?
    var replyView: UIView?
    
    var lbltitleName: UILabel?
    var lblReplyMessage: UILabel?
    var lblmessage: UILabel?
    var imageMsg: UIImageView?
    
    var statusView: UIImageView?
    var lblDatetTimeDay: UILabel?
    var stack: UIStackView?
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    var isdelForward : Bool? = false
    var commentSms : String? = ""
    
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var ImgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var isSmsSelected: Bool?  = false
  
    var heightBackView: NSLayoutConstraint!
    
    var dataSet: chat_data? = nil {
        didSet{
            mainView?.backgroundColor = dataSet?.receiverId == AppUtils.shared.senderID ? AppColors.outgoingMsgColor : AppColors.incomingMsgColor
            
            replyView?.backgroundColor = dataSet?.receiverId == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor
            
            lblmessage?.textColor = dataSet?.receiverId == AppUtils.shared.senderID ? AppColors.secondaryFontColor : AppColors.secondaryFontColor
            
            lblDatetTimeDay?.text = getMsgDate(date: dataSet?.createdAt ?? "")
            
            lbltitleName?.text = dataSet?.receiverId == AppUtils.shared.senderID ? "\(dataSet?.senderId.name ?? "")" : "You"
          
         //   lblReplyMessage?.text = "\(dataSet?.commentId.message ?? "\(commentSms ?? "")")"
            lblmessage?.text = "\(dataSet?.message ?? "")"
            if dataSet?.repliedTo != nil {
                
            switch dataSet?.repliedTo.messageType ?? 0 {
             case 0 :
                lblReplyMessage?.text = "\(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")"
             case 1:
                lblReplyMessage?.attributedText = Data.SetImageWithLabel(LabelText: " \(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")", LabelImage: "GalleryIcon", isSystemImage: false, Size: CGSize(width: 15, height: 15))
            case 2:
                
                lblReplyMessage?.attributedText = Data.SetImageWithLabel(LabelText: " \(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")", LabelImage: "folder", isSystemImage: false, Size: .init(width: 15, height: 15))
                case 5:
                lblReplyMessage?.attributedText = Data.SetImageWithLabel(LabelText: " \(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")", LabelImage: "video", isSystemImage: true, Size: .init(width: 15, height: 12))
              case 6:
                lblReplyMessage?.attributedText = Data.SetImageWithLabel(LabelText: " \(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")", LabelImage: "mic", isSystemImage: false, Size: .init(width: 12, height: 15))
         
            case 7:
                lblReplyMessage?.attributedText = Data.SetImageWithLabel(LabelText: " \(dataSet?.repliedTo.message ?? "\(commentSms ?? "")")", LabelImage: "Location", isSystemImage: false, Size: .init(width: 15, height: 15))
                 
             default :
                 break
             }
            
            }
            
            if dataSet?.receipt_status == 1 {
                statusView?.image = UIImage(systemName: "clock")
            }else{
                if dataSet?.seen == 0 && dataSet?.receipt_status == 1 {
                    statusView?.image = UIImage(systemName: "checkmark")
                }else{
                    statusView?.image = UIImage(named: "seen_double_check")
                    statusView?.setImageColor(color: AppColors.primaryColor)
                }
            }
            
            if  isSmsSelected == true {
                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
                ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
            } else {
                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
                ImgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
                
            }
            
            if dataSet?.receiverId == AppUtils.shared.senderID {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
                stackLeadingConstraint.isActive = true
                stackTrailingConstraint.isActive = false
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 17, clipToBonds: true)
                statusView?.isHidden = true
                
                
                
                if isdelForward! {
                ImgRecivedSlected.isHidden = false
                imgSendSlected.isHidden = true
                    leadingConstraint.isActive = false
                    leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
                    leadingConstraint.isActive = true
                    
                }
                else{
                    leadingConstraint.isActive = false
                    leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
                    leadingConstraint.isActive = true
                   
                    ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
                
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                stackLeadingConstraint.isActive = false
                stackTrailingConstraint.isActive = true
                
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 17, clipToBonds: true)
                statusView?.isHidden = false
               
                if isdelForward! {
                    
                ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = false
                    //ImgRecivedSlected.isHidden = false
                    
                    trailingConstraint.isActive = false
                    trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
                    trailingConstraint.isActive = true
                } else
                {
                    trailingConstraint.isActive = false
                    trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
                    trailingConstraint.isActive = true
                    
                    ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
                
            }
            imageMsg?.isHidden = true
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    func initializedControls(){
        
        mainView = UIView(backgroundColor: UIColor.gray)
        
        lbltitleName = UILabel(title: "name??", fontColor: AppColors.primaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .Medium, size: 12))
        
        lblReplyMessage = UILabel(title: "message??", fontColor: AppColors.secondaryFontColor, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        imageMsg = UIImageView(image: UIImage(named: "profile3")!, contentModel: .scaleAspectFill)
        imageMsg?.constraintsWidhHeight(size: .init(width: 20, height: 20))
        
        replyView = {
            let view = UIView(backgroundColor: UIColor.brown, cornerRadius: 10)
            
            let stack1 = UIStackView(views: [imageMsg!, lblReplyMessage!], axis: .horizontal, spacing: 8)
            let stack2 = UIStackView(views: [lbltitleName!, stack1], axis: .vertical, spacing: 4)
            
            view.addSubview(stack2)
            stack2.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 8))
            stack2.verticalCenterWith(withView: view)
            
            return view
        }()
        
        lblmessage = UILabel(title: "name???", fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        lblDatetTimeDay = UILabel(title: "date??", fontColor: UIColor.gray, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
        stack = UIStackView(views: [lblDatetTimeDay!], axis: .horizontal, spacing: 5, distribution: .fill)
//        stack = UIStackView(views: [lblDatetTimeDay! , statusView! ], axis: .horizontal, spacing: 5, distribution: .fill)
        
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        lblmessage?.translatesAutoresizingMaskIntoConstraints = false
        lblmessage?.numberOfLines = 0
    }
    
    func configureUI(){
        initializedControls()
        contentView.addSubview(mainView!)
        mainView?.addSubview(replyView!)
        mainView?.addSubview(lblmessage!)
        contentView.addMultipleSubViews(views: stack!,ImgRecivedSlected,imgSendSlected)
        
        heightBackView =   mainView?.widthAnchor.constraint(lessThanOrEqualToConstant: 190)
        heightBackView.priority = UILayoutPriority.init(999)
        heightBackView.isActive = true
        
        ImgRecivedSlected.isHidden = true
        imgSendSlected.isHidden = true
        
        mainView?.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 16, left: 0, bottom: 22, right: 0), size: .init(width: 190, height: 0))
        
        replyView?.anchor(top: mainView?.topAnchor, leading: mainView?.leadingAnchor, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 60))
        
        lblmessage?.anchor(top: replyView?.bottomAnchor, leading: mainView?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 12, bottom: 8, right: 8))
        
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor , padding: .init(top: 5, left: 0, bottom: 3, right: 0))
        
        
        ImgRecivedSlected.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil ,padding: .init(top: 0, left: 16 , bottom: 0, right: 0))
        ImgRecivedSlected.verticalCenterWith(withView: mainView!)
    
        imgSendSlected.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor ,padding: .init(top: 0, left: 0 , bottom: 0, right: 16))
        imgSendSlected.verticalCenterWith(withView: mainView!)
        ImgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
      
       
        
        
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









//class ReplyViewCell: UITableViewCell {
//
//    var mainView: UIView?
//    var replyView: UIView?
//
//    var lbltitleName: UILabel?
//    var lblReplyMessage: UILabel?
//    var lblmessage: UILabel?
//    var imageMsg: UIImageView?
//
//    var statusView: UIImageView?
//    var lblDatetTimeDay: UILabel?
//    var stack: UIStackView?
//
//    var leadingConstraint: NSLayoutConstraint!
//    var trailingConstraint: NSLayoutConstraint!
//
//    var stackLeadingConstraint: NSLayoutConstraint!
//    var stackTrailingConstraint: NSLayoutConstraint!
//    var isdelForward : Bool? = false
//    var commentSms : String? = ""
//
//    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var ImgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var isSmsSelected: Bool?  = false
//    var heightBackView: NSLayoutConstraint!
//
//
//    var dataSet: chatModel? = nil {
//        didSet{
//            mainView?.backgroundColor = dataSet?.receiverId._id == AppUtils.shared.senderID ? AppColors.outgoingMsgColor : AppColors.incomingMsgColor
//
//            replyView?.backgroundColor = dataSet?.receiverId._id == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor
//
//            lblmessage?.textColor = dataSet?.receiverId._id == AppUtils.shared.senderID ? AppColors.secondaryFontColor : AppColors.secondaryFontColor
//
//            lblDatetTimeDay?.text = getMsgDate(date: dataSet?.createdAt ?? "")
//
//            //let senderName = dataSet?.commentId.senderId._id == AppUtils.shared.senderID ? "You" : "\(dataSet?.senderId.name ?? "")"
//
//            lbltitleName?.text = dataSet?.receiverId._id == AppUtils.shared.senderID ? "\(dataSet?.senderId.name ?? "")" : "You"
//            lblReplyMessage?.text = dataSet?.commentId.message ?? "\(commentSms ?? "")"
//            lblmessage?.text = "\(dataSet?.message ?? "")"
//
//            if dataSet?.receiptStatus == 0{
//                statusView?.image = UIImage(systemName: "profile3")
//            }else{
//                if dataSet?.isSeen == 0 && dataSet?.receiptStatus == 1 {
//                    statusView?.image = UIImage(systemName: "checkmark")
//                }else{
//                    statusView?.image = UIImage(named: "seen_double_check")
//                    statusView?.setImageColor(color: AppColors.primaryColor)
//                }
//            }
//
//            if  isSmsSelected == true {
//                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                ImgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            } else {
//                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
//                ImgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
//
//            }
//
//            if dataSet?.receiverId._id == AppUtils.shared.senderID {
//                leadingConstraint.isActive = true
//                trailingConstraint.isActive = false
//
//                stackLeadingConstraint.isActive = true
//                stackTrailingConstraint.isActive = false
//                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 12, clipToBonds: true)
//                statusView?.isHidden = true
//
//                if isdelForward! {
//                ImgRecivedSlected.isHidden = false
//                imgSendSlected.isHidden = true
//                    leadingConstraint.isActive = false
//                    leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
//                    leadingConstraint.isActive = true
//
//                }
//                else{
//                    ImgRecivedSlected.isHidden = true
//                    imgSendSlected.isHidden = true
//                }
//
//            } else {
//                leadingConstraint.isActive = false
//                trailingConstraint.isActive = true
//
//                stackLeadingConstraint.isActive = false
//                stackTrailingConstraint.isActive = true
//
//                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12, clipToBonds: true)
//                statusView?.isHidden = false
//
//                if isdelForward! {
//
//                ImgRecivedSlected.isHidden = true
//                    imgSendSlected.isHidden = false
//                    //ImgRecivedSlected.isHidden = false
//
//                    trailingConstraint.isActive = false
//                    trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
//                    trailingConstraint.isActive = true
//                } else
//                { ImgRecivedSlected.isHidden = true
//                    imgSendSlected.isHidden = true
//                }
//
//            }
//            imageMsg?.isHidden = true
//        }
//    }
//
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//
//
//    func initializedControls(){
//
//        mainView = UIView(backgroundColor: UIColor.gray)
//
//        lbltitleName = UILabel(title: "name??", fontColor: AppColors.primaryColor, alignment: .left, font: UIFont.font(.Poppins, type: .Medium, size: 12))
//
//        lblReplyMessage = UILabel(title: "message??", fontColor: AppColors.secondaryFontColor, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
//
//        imageMsg = UIImageView(image: UIImage(named: "profile3")!, contentModel: .scaleAspectFill)
//        imageMsg?.constraintsWidhHeight(size: .init(width: 20, height: 20))
//
//        replyView = {
//            let view = UIView(backgroundColor: UIColor.brown, cornerRadius: 10)
//
//            let stack1 = UIStackView(views: [imageMsg!, lblReplyMessage!], axis: .horizontal, spacing: 8)
//            let stack2 = UIStackView(views: [lbltitleName!, stack1], axis: .vertical, spacing: 4)
//
//            view.addSubview(stack2)
//            stack2.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 8))
//            stack2.verticalCenterWith(withView: view)
//
//            return view
//        }()
//
//        lblmessage = UILabel(title: "name???", fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
//
//        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
//        statusView?.setImageColor(color: AppColors.primaryColor)
//        lblDatetTimeDay = UILabel(title: "date??", fontColor: UIColor.gray, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 12))
//
//        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//        stack = UIStackView(views: [statusView!, lblDatetTimeDay!], axis: .horizontal, spacing: 5, distribution: .fill)
//
//        mainView?.translatesAutoresizingMaskIntoConstraints = false
//        lblmessage?.translatesAutoresizingMaskIntoConstraints = false
//        lblmessage?.numberOfLines = 0
//    }
//
//    func configureUI(){
//        initializedControls()
//        contentView.addSubview(mainView!)
//        mainView?.addSubview(replyView!)
//        mainView?.addSubview(lblmessage!)
//       // contentView.addSubview(stack!)
//        contentView.addMultipleSubViews(views: stack!,ImgRecivedSlected,imgSendSlected)
//
//        mainView?.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 16, left: 0, bottom: 22, right: 0), size: .init(width: 250, height: 0))
//
//        replyView?.anchor(top: mainView?.topAnchor, leading: mainView?.leadingAnchor, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 60))
//
//
//
//
//        ImgRecivedSlected.isHidden = true
//        imgSendSlected.isHidden = true
//
//        heightBackView =   mainView?.widthAnchor.constraint(lessThanOrEqualToConstant: 650)
//        heightBackView.priority = UILayoutPriority.init(999)
//        heightBackView.isActive = true
//
//
//        mainView?.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 22, right: 0), size: .init(width: 0, height: 0))
//
//        ImgRecivedSlected.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil ,padding: .init(top: 0, left: 16 , bottom: 0, right: 0))
//        ImgRecivedSlected.verticalCenterWith(withView: mainView!)
//
//        imgSendSlected.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor ,padding: .init(top: 0, left: 0 , bottom: 0, right: 16))
//        imgSendSlected.verticalCenterWith(withView: mainView!)
//        ImgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//
//
//     lblmessage?.anchor(top:  mainView?.topAnchor, leading: mainView?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 12, bottom: 8, right: 8))
//
//        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
//
//
//
//
//        leadingConstraint = mainView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
//        leadingConstraint.isActive = false
//
//        trailingConstraint = mainView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
//        trailingConstraint.isActive = true
//
//        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
//        stackLeadingConstraint.isActive = false
//
//        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
//        stackTrailingConstraint.isActive = false
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


extension Data {
    static func SetImageWithLabel (LabelText: String,LabelImage : String, isSystemImage: Bool,Size: CGSize) -> NSMutableAttributedString {
    let attachment = NSTextAttachment()
        if isSystemImage  == true {
                attachment.image = UIImage(systemName: LabelImage)?.imageWithColor(color1: .gray)
        } else { attachment.image = UIImage(named: LabelImage)?.imageWithColor(color1: .gray)  }
        
    let attachmentString = NSAttributedString(attachment: attachment)
        attachment.bounds = CGRect(x: 0, y: 0, width: Size.width, height: Size.height)
    let myString = NSMutableAttributedString(string: "")
    myString.append(attachmentString)
    let myStrings = NSMutableAttributedString(string: LabelText)
    myString.append(myStrings)
        return myString
        
    }
    
}
