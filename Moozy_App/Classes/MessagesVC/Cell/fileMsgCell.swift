//
//  fileMsgCell.swift
//  Chat_App
//
//  Created by Ali Abdullah on 19/04/2022.
//

import Foundation
import UIKit
import SwipyCell
import CryptoSwift

protocol fileDowloadDelegate {
    func didDowloadFile(cell: FileMsgCell)
}

class FileMsgCell:  SwipyCell {
   
    var docPath = ""
    var actionSetSort : ((_ name : String)->Void)?

    var imgFolder: UIImageView?
   
    var mainView: UIView?
    var statusView: UIImageView?
    var lblDatetTimeDay: UILabel?
    let messageLabel = UILabel(title: "Report_9966.docx", fontColor: UIColor.black, font: UIFont.font(.Poppins, type: .Regular, size: 12))
   
    var stack: UIStackView?
    
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    
    var imgdownloadFile = UIImageView(image: #imageLiteral(resourceName: "icon-download3"), contentModel: .scaleAspectFit)
   
    var isSet =  false
    var nowSending = false
    var iSsent = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
 
    var delegatFileDownload : fileDowloadDelegate?
 
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var imgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var stackeContent : UIStackView?
    var isdelForward: Bool? = false
    
    var isSmsSelected: Bool?  = false
    var isdownloading : Bool?  = false
    
    var chatData: chat_data? = nil{
        didSet{
            
            mainView?.backgroundColor = chatData?.receiverId == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor  //AppColors.primaryColor
            
            messageLabel.textColor = chatData?.receiverId == AppUtils.shared.senderID ? AppColors.secondaryFontColor : AppColors.secondaryFontColor
            let dataCompare = chatData?.message.count ?? 0 > 38  ? String(chatData?.message.dropFirst(37) ?? "") : chatData?.message ?? ""
            
            docPath =  DownloadData.sharedInstance.searchFileExist(fileName: dataCompare, fileType: 2) ?? ""
      
            messageLabel.text =   dataCompare
            if chatData?.receiverId == AppUtils.shared.senderID {
              iSsent = false
                isSet =  true
          }
          else {
              iSsent = true
              isSet = false
          }
            
            
            lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
            
            if chatData?.seen == 0 || chatData?.receipt_status == 1 {
                    statusView?.image = UIImage(systemName: "checkmark")
                }else{
                    statusView?.image = UIImage(named: "seen_double_check")
                    statusView?.setImageColor(color: AppColors.primaryColor)
                }

          
            if docPath == "" || docPath == nil {
                
                imgdownloadFile.isHidden = false
                if  isdownloading == true {
                    imgdownloadFile.isHidden = true
                      activityIndicator.startAnimating()

                } else {
                    imgdownloadFile.isHidden = false
                    if activityIndicator.isAnimating == true {
                   
                      activityIndicator.stopAnimating()
                    }
                    
                }
                
                
            }
            else{
                activityIndicator.stopAnimating()
                imgdownloadFile.isHidden = true
            }
            
            
            if  isSmsSelected == true {
                
                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
                imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
            } else {
                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
                imgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
                
            }
            if chatData?.receiverId == AppUtils.shared.senderID {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
                stackLeadingConstraint.isActive = true
                stackTrailingConstraint.isActive = false
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 20, clipToBonds: true)
                statusView?.isHidden = true
                if  isdelForward! {
                imgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = false }
                else {
                    imgRecivedSlected.isHidden = true
                        imgSendSlected.isHidden = true
                    }
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                stackLeadingConstraint.isActive = false
                stackTrailingConstraint.isActive = true
                
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20, clipToBonds: true)
                statusView?.isHidden = false
                if  isdelForward! {
                imgRecivedSlected.isHidden = false
                    imgSendSlected.isHidden = true }
                else {
                    imgRecivedSlected.isHidden = true
                        imgSendSlected.isHidden = true
                    }
            }
        }
    }
  
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        configureUI()
        mainView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerObjRecevied(_:)), name: .dowloadFile, object:nil)
  
      
    }
    
    
    func initializedControls(){
        
        
        imgFolder = UIImageView(image: #imageLiteral(resourceName: "folder"), contentModel: .scaleAspectFit)
        imgFolder?.setImageColor(color: AppColors.primaryColor)
        mainView = UIView(cornerRadius: 0)
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        
        lblDatetTimeDay = UILabel(title: "12:50 (Fri)", fontColor: UIColor.gray, alignment: .left, font: UIFont.systemFont(ofSize: 12))
        
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
        stack = UIStackView(views: [lblDatetTimeDay! , statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
    }
    
    //ConfigureUI
    func configureUI(){
        initializedControls()
        
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        imgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        mainView?.constraintsWidhHeight(size: .init(width: 250, height: 220))
     
         stackeContent = UIStackView(views: [imgSendSlected,mainView!,imgRecivedSlected], axis: .horizontal, spacing: 5, distribution: .fill)
        imgRecivedSlected.isHidden = true
            imgSendSlected.isHidden = true
      
        
        contentView.addSubview(stackeContent!)
        contentView.addSubview(stack!)
        mainView?.addMultipleSubViews(views: imgFolder!,messageLabel,imgdownloadFile)
        
        
        stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 280, height: 45))
        
        imgFolder?.anchor(top: nil, leading: mainView?.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 8, bottom: 0, right: 0),size: .init(width: 25, height: 25))
        imgFolder?.verticalCenterWith(withView: mainView!)
        messageLabel.anchor(top: nil, leading: imgFolder?.trailingAnchor, bottom: nil, trailing: imgdownloadFile.leadingAnchor,padding: .init(top: 0, left: 8, bottom: 0, right: 5))
        messageLabel.verticalCenterWith(withView: imgFolder)
        imgdownloadFile.verticalCenterWith(withView: imgFolder)
        imgdownloadFile.anchor(top: nil, leading: nil, bottom: nil, trailing: mainView?.trailingAnchor ,padding: .init(top: 0, left: 0, bottom: 0, right: 5),size: .init(width: 25, height: 25))
    
//        progressview?.constraintsWidhHeight(size: .init(width: 50, height: 50))
//        progressview?.centerSuperView()
        
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 16, right: 0))
        
        leadingConstraint = stackeContent!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = false
        
        trailingConstraint = stackeContent!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
        stackLeadingConstraint.isActive = false
        
        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
        stackTrailingConstraint.isActive = false
    }
    
    
    @objc func CustomerObjRecevied(_ sender: Notification)
    {
        
        actionSetSort?("arySortingStyle")
         
        
        guard let minimizerObjInfo = sender.userInfo,
              let minimizerID = minimizerObjInfo["downlaodFile"] as? String else{ return }
        
        guard let minimizerObjInf = sender.userInfo,
        let minimiz = minimizerObjInf["ReciverId"] as? String else{ return }
     
        guard let minimizerObjIn = sender.userInfo,
        let senderId = minimizerObjInf["SenderId"] as? String else{ return }
        
       
        
        if chatData?.receiverId == AppUtils.shared.senderID {
            dowloadFile(fileName: minimizerID, isSent: false, senderId: senderId)
          
         //   downloadImage(imageName: minimizerID, senderId: senderId, isSent: false)
      }
      else {
          //dowloadFile(fileName: minimizerID)
          dowloadFile(fileName: minimizerID, isSent: true, senderId: senderId)
          
      }
        
        
        print("CustomerObjRecevied")
       return
    }
    
    
    func dowloadFile(fileName : String, isSent : Bool, senderId : String) {
        print(chatData?.message ?? "")
        //chatData?.message ?? ""
        DownloadData.sharedInstance.download(isImage: false, isVideo: false, isSent: isSent, name: fileName , senderId: senderId ) { (response, isDownloaded) in
            print(response)
            if isDownloaded!{
               // self.imgdownloadFile.isHidden = true
                DispatchQueue.main.async { [self] in
                    print(response)
                    activityIndicator.stopAnimating()
                    
                    let message = chatData?.message ?? ""
                 return
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
