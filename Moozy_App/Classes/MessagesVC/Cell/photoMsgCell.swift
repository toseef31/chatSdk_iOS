//
//  photoMsgCell.swift
//  Chat_App
//
//  Created by Ali Abdullah on 19/04/2022.
//

import Foundation
import UIKit
import SwipyCell
import CircleProgressView
import  SDWebImage
import Kingfisher
import SwipyCell
protocol imagesViewDelegate {
    func didSelectImage(cell: PhotoMsgCell)
}

class PhotoMsgCell: SwipyCell {
    
    var isdelForward :Bool? = false
    var delegteImgViewSelected : ChatItemSelection?
    
    var videoView: UIImageView?
    var blurView: UIView?
    var mainView: UIView?
    var statusView: UIImageView?
    var lblDatetTimeDay: UILabel?
    
    var progressview: CircleProgressView?
    
    var stack: UIStackView?
    
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    
    var delegates: imagesViewDelegate?
    var imgdownloadFile = UIImageView(image: #imageLiteral(resourceName: "download"), contentModel: .scaleAspectFit)
   
    var isSet =  false
    var nowSending = false
    var iSsent = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var ImgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var stackeContent : UIStackView?
    
    var isSmsSelected: Bool?  = false
    var isdownloading : Bool?  = false
    
    var chatData: chat_data? = nil{
        didSet{
            
            mainView?.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)
            if chatData?.receiverId == AppUtils.shared.senderID {
              iSsent = false
                isSet =  true
          }
          else {
              iSsent = true
              isSet = false
          }
            print(chatData?.message)
            let cellImage = AppUtils.shared.loadImage(fileName: chatData?.message ?? "")
            
                if cellImage != nil{
                    if chatData?.isProgress ?? false == true {
                        activityIndicator.startAnimating()
                    } else {
                       // if activityIndicator.isAnimating == true {
                            activityIndicator.stopAnimating() //}
                    }
                    
                    imgdownloadFile.isHidden = true
                    videoView?.image = cellImage
                }else{
                     videoView?.image = UIImage(named: "placeholder")
                    
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
                    
                    if  let url = URL(string: ""){
                        KingfisherManager.shared.retrieveImage(with: url) { [self] result in
                            let image = try? result.get().image
                            if let image = image {
                                videoView?.image = image
                                
                                isSet = true
                            }else{
                                isSet = false
                                videoView?.image = UIImage(named: "placeholder")
                              
                            }
                        }
                    }
                    
                }
            
            lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
            if chatData?.receipt_status == 1   {
                activityIndicator.startAnimating()
                statusView?.image = UIImage(systemName: "clock")
                if chatData?.receiverId == AppUtils.shared.senderID && isdownloading != true {
                    activityIndicator.stopAnimating()
                }
                 
            }else{
                if chatData?.receiverId == AppUtils.shared.senderID && isdownloading != true {
                    activityIndicator.stopAnimating()
                }
               // activityIndicator.stopAnimating()
                if chatData?.seen == 0 && chatData?.receipt_status == 1 {
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
           
            
            
            if chatData?.receiverId == AppUtils.shared.senderID {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
                stackLeadingConstraint.isActive = true
                stackTrailingConstraint.isActive = false
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
                videoView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
                statusView?.isHidden = true
                if isdelForward! {
                ImgRecivedSlected.isHidden = true
                imgSendSlected.isHidden = false
                } else {
                    ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
                
                 
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                stackLeadingConstraint.isActive = false
                stackTrailingConstraint.isActive = true
                
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
                videoView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
                statusView?.isHidden = false
                if isdelForward! {
                ImgRecivedSlected.isHidden = false
                imgSendSlected.isHidden = true
                } else {
                    ImgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
                 
            }
        }
    }
  
    
    func downloadImage(imageName: String, senderId : String,isSent: Bool ){
        print(imageName)
        print(senderId)
        
//        DownloadData.sharedInstance.download(isImage: true, isVideo: false, isSent: iSsent, name: imageName , senderId: chatData?.senderId._id ?? "") { (response, isDownloaded) in
        
            
            DownloadData.sharedInstance.download(isImage: true, isVideo: false, isSent: isSent, name: imageName , senderId: senderId ) { (response, isDownloaded) in
                
                if isDownloaded!{
                    DispatchQueue.main.async { [self] in
                        print(response)
                        
                        
                        let message = chatData?.message ?? ""
                        
                        if chatData?.messageType == 1{
                            
                           let cellImage = AppUtils.shared.loadImage(fileName: chatData?.message ?? "")
                            if cellImage != nil{
                                videoView?.image = cellImage
                            }else{
                                if  let url = URL(string: ""){
                                    KingfisherManager.shared.retrieveImage(with: url) { [self] result in
                                        let image = try? result.get().image
                                        if let image = image {
                                            activityIndicator.stopAnimating()
                                            videoView?.image = image
                                            
                                        }else{
                                            videoView?.image = nil
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
                else{
                    print("Error")
                }
            }
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        configureUI()
        mainView?.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerObjRecevied(_:)), name: .dowloadImage, object:nil)
 
    }
    
    
    //actuonIlister
    @objc func CustomerObjRecevied(_ sender: Notification)
    {
        activityIndicator.startAnimating()
    
        guard let minimizerObjInfo = sender.userInfo,
              let minimizerID = minimizerObjInfo["downlaodImages"] as? String else{ return }
        
        guard let minimizerObjInf = sender.userInfo,
        let minimiz = minimizerObjInf["ReciverId"] as? String else{ return }
     
        guard let minimizerObjIn = sender.userInfo,
        let senderId = minimizerObjInf["SenderId"] as? String else{ return }
         
        if minimiz == AppUtils.shared.senderID {
            downloadImage(imageName: minimizerID, senderId: senderId, isSent: false)
      }
      else {
          downloadImage(imageName: minimizerID, senderId: senderId, isSent: true)
         
      }
        
        print("CustomerObjRecevied")
       return
    }
    
    //Initialized Controls
    func initializedControls(){
       
        
        progressview = CircleProgressView()
        
        progressview?.trackFillColor = AppColors.primaryColor
        progressview?.centerFillColor = .white
        progressview?.backgroundColor = .clear
        
        videoView = UIImageView(image: UIImage(named: "placeholder")!, contentModel: .scaleAspectFill)
        
        blurView = UIView()
        
        mainView = UIView(cornerRadius: 20)
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        
        lblDatetTimeDay = UILabel(title: "12:50 (Fri)", fontColor: UIColor.gray, alignment: .left, font: UIFont.systemFont(ofSize: 12))
        
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        videoView?.layer.cornerRadius = 30
        videoView?.layer.masksToBounds = true
        
        blurView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2813699959)
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//        stack = UIStackView(views: [lblDatetTimeDay! , statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
  
        stack = UIStackView(views: [lblDatetTimeDay! ], axis: .horizontal, spacing: 5, distribution: .fill)
    }
    
    //ConfigureUI
    func configureUI(){
        initializedControls()
        
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        ImgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        mainView?.constraintsWidhHeight(size: .init(width: 160, height: 160))
     
         stackeContent = UIStackView(views: [imgSendSlected,mainView!,ImgRecivedSlected], axis: .horizontal, spacing: 3, distribution: .fill)
        imgSendSlected.isHidden = true
        ImgRecivedSlected.isHidden = true
        contentView.addSubview(stack!)
        contentView.addSubview(stackeContent!)
        mainView?.addMultipleSubViews(views: videoView!)
        
        videoView?.addSubview(imgdownloadFile)
        imgdownloadFile.constraintsWidhHeight(size: .init(width: 40, height: 40))
        imgdownloadFile.centerSuperView()
        
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = AppColors.primaryColor
       
        
        videoView?.addSubview(activityIndicator)
        activityIndicator.constraintsWidhHeight(size: .init(width: 50, height: 50))
        activityIndicator.centerSuperView()
        activityIndicator.tintColor = AppColors.primaryColor
        imgdownloadFile.isHidden = true
        
        
        videoView?.addMultipleSubViews(views: blurView!, progressview!)
        
        stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 190, height: 160))
        
        videoView?.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        blurView?.fillSuperView()
        
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 7, right: 0))
        
        leadingConstraint = stackeContent?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = false
        
        trailingConstraint = stackeContent?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 8)
        stackLeadingConstraint.isActive = false
        
        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: 8)
        stackTrailingConstraint.isActive = false
        
        //TabGesture
        videoView?.addTapGesture(tagId: 0, action: { [self] _ in
            
            delegteImgViewSelected?.IMGorMapSelected(cell: self)
            
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoMsgCell{
    
    private func loadImage(url:URL,completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                if error == nil {
                    if let response = response as? HTTPURLResponse  {
                        if response.statusCode == 200  {
                            if let data = data {
                                let statusCode = (response as HTTPURLResponse).statusCode
                                print("Success: \(statusCode)")
                                
                                let key =  "2eXJiSSZ5uIAeZVs"  // Get_Ring_ID()
                                let iv = "7Hh3tLJKW3PeWO9d"
                                
                                
                                var encImage: UIImage? = UIImage(data: data) ?? nil
                                var encImageData = Data()
//                                do{
//                                    encImageData = try data.aesDecryptData(key: key, iv: iv)
//                                    DispatchQueue.main.async {
//                                        encImage = UIImage(data: data) ?? nil
//                                    }
//                                }catch( let error as NSError ){
//                                    print(error)
//                                }
                                DispatchQueue.main.async {
                                    completion(encImage)
                                }
                            }
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
