//
//  videoMsgCell.swift
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

import AVKit
import Kingfisher
import Lightbox

import SwipyCell

protocol vedioViewDelegate {
    func didSelectVedio(cell: VideoMsgCell,VedioUrl: String)
    func reloadSelectVedio(cell: VideoMsgCell,indexSection: String,indexRow: String)
}
class VideoMsgCell: SwipyCell {
    
    var delegteVideoSelected : ChatItemSelection?
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let cache = NSCache<NSURL, UIImage>()
   // var viewdioContent = UIView(backgroundColor: .red, cornerRadius: 5, borderWidth: 2, maskToBounds: true)
    
    var videoView: UIImageView?
    var blurView: UIView?
    var mainView: UIView?
    var statusView: UIImageView?
    var lblDatetTimeDay: UILabel?
    
    var btnVideoPlay: MoozyActionButton?
  
    var stack: UIStackView?
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    var delegates: vedioViewDelegate?
    var isdelForward : Bool? = false
    
    var isSmsSelected: Bool?  = false
    var isdownloading : Bool?  = false
   
    
    
    var imgdownloadFile = MoozyActionButton(image: #imageLiteral(resourceName: "download"), foregroundColor: .white, backgroundColor: AppColors.backColorColor, imageSize: .init(width: 35, height: 35)){
    }
    
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var imgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var stackeContent : UIStackView?
  
    var url : URL!
    var vedioUrls : String = ""
    var dataSet: chat_data? = nil{
       
        didSet{

        let urle =     "https://chat.chatto.jp:20000/meetingchat/"
            var dataset = dataSet?.message ?? ""
            let dataCompare = dataset.count ?? 0 > 38  ? dataset : dataset
           
            
            let pathd =   urle + (dataSet?.message ?? "") ?? ""
            print(pathd)
           url = URL(string: pathd )
                //(string: "\(url)\(dataSet?.message ?? "")")
            print(dataSet?.message ?? "")
            print(url)
            let videoUrl = url //DownloadData.sharedInstance.searchFileExist(fileName:  dataSet?.message ?? "", fileType: 5)
            
            if videoUrl != nil{
                imgdownloadFile.isHidden = true
                btnVideoPlay?.isHidden = false
                self.activityIndicator.startAnimating()
                //self.activityIndicator.stopAnimating()
                self.generateThumbnail(url: url!) { image in
                    self.activityIndicator.stopAnimating()
                  
                   self.videoView?.image = image
                }
                
            }else{
                imgdownloadFile.isHidden = false
                btnVideoPlay?.isHidden = true
                
                AVAsset(url: url).generateThumbnail { [weak self] (image) in
                    DispatchQueue.main.async { [self] in
                        guard let image = image else { return }
                        DispatchQueue.main.async {
                            self?.activityIndicator.stopAnimating()
                          
                            self?.videoView?.image  = image
                            
                        }
                        self?.cache.setObject(image, forKey: self!.url as NSURL)
//                        cache.setObject(image, forKey: url as NSURL)
                    }
                }
                var sent = true
//                AppUtils.shared.getAllChat![0].senderId._id == AppUtils.shared.senderID
                
                if AppUtils.shared.senderID != dataSet?.senderId._id ?? "" {
                    sent = false
                }
                
                videoView?.image = UIImage(named: "placeholder")
                }
                
          
            if  isSmsSelected == true {
                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
                imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
            } else {
                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
                imgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
                
            }
            
            mainView?.backgroundColor =  #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)
            
            if dataSet?.receiverId == AppUtils.shared.senderID {
           
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
                stackLeadingConstraint.isActive = true
                stackTrailingConstraint.isActive = false
                statusView?.isHidden = true
                
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
                videoView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
                videoView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
                if isdelForward! {
                imgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = false
                    
                }  else {
                    imgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
            } else {
                
                statusView?.isHidden = false
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                stackLeadingConstraint.isActive = false
                stackTrailingConstraint.isActive = true
                
                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
                videoView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
                if isdelForward! {
                imgRecivedSlected.isHidden = false
                    imgSendSlected.isHidden = true }  else {
                        imgRecivedSlected.isHidden = true
                        imgSendSlected.isHidden = true
                    }
            }
            lblDatetTimeDay?.text = getMsgDate(date: dataSet?.createdAt ?? "")
        }
    }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imgdownloadFile.addBorders(edges: .all, color: AppColors.btnBackColor)
         imgdownloadFile.roundCorners(corners: .allCorners, radius: 25, borderColor:  AppColors.btnBackColor, borderWidth: 1.5, clipToBonds: true)
          backgroundColor = .clear
        configureUI()
        mainView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerObjRecevied(_:)), name: .dowloadVedio, object:nil)
 
    }
    
    //actuonIlister
    @objc func CustomerObjRecevied(_ sender: Notification)
    {
        activityIndicator.isHidden = false
       activityIndicator.startAnimating()
        
        guard let minimizerObjInfo = sender.userInfo,
              let minimizerID = minimizerObjInfo["downlaodVideo"] as? String else{ return }
        
        guard let minimizerObjInf = sender.userInfo,
        let minimiz = minimizerObjInf["ReciverId"] as? String else{ return }
     
        guard let minimizerObjIn = sender.userInfo,
        let senderId = minimizerObjInf["SenderId"] as? String else{ return }
        
        
        guard let minimizerObj = sender.userInfo,
        let indexPathRow = minimizerObjInf["indexPathrow"] as? String else{ return }
    
        print(indexPathRow)
        
        guard let minimizerOb = sender.userInfo,
        let indexPathSection = minimizerObjInf["indexPathSection"] as? String else{ return }
    
        print(indexPathSection)
     
        
        print(minimizerID)
        print(minimiz)
        
        if minimiz == AppUtils.shared.senderID {
            dowloadVideio(imageName: minimizerID, senderId: senderId, isSent: false)
      }
      else {
          dowloadVideio(imageName: minimizerID, senderId: senderId, isSent: true)
         
      }
        
        print("CustomerObjRecevied")
       return
    }
    
    func dowloadVideio (imageName: String, senderId : String,isSent: Bool ) {
        
        var sent = true
        if AppUtils.shared.senderID != dataSet?.senderId._id ?? "" {
            sent = false
        }
        
        
        AVAsset(url: url).generateThumbnail { [weak self] (image) in
            DispatchQueue.main.async { [self] in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self?.videoView?.image  = image
                    
                }
                self?.cache.setObject(image, forKey: self!.url as NSURL)
//                        cache.setObject(image, forKey: url as NSURL)
            }
        }
        
                DownloadData.sharedInstance.download(isImage: false, isVideo: true, isSent: isSent, name: imageName, senderId: senderId ) { (response, isDownloaded) in
                    print(response)
                    if isDownloaded!{
                        DispatchQueue.main.async {
                            print(self.vedioUrls)
                            DownloadData.sharedInstance.videoPreviewImage(url: URL(fileURLWithPath: self.vedioUrls),completion: { (videoImage) in
                                    DispatchQueue.main.async { [self] in
                                        activityIndicator.stopAnimating()
                                        videoView?.image = videoImage
                                        
                                        btnVideoPlay?.isHidden = false
                                        delegates?.reloadSelectVedio(cell: self, indexSection: "3", indexRow: "26")
                                    }
                                
                                if let vImg = videoImage{
                                    self.cache.setObject(vImg, forKey: self.url as NSURL)
                                }
                            })
                            

                        }
                    }
                }
    }
    //Initialized Controls
    func initializedControls(){
        
        videoView = UIImageView(image: UIImage(named: "placeholder")!, contentModel: .scaleAspectFill)
        blurView = UIView()
        mainView = UIView(cornerRadius: 0)
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        
        lblDatetTimeDay = UILabel(title: "12:50", fontColor: UIColor.gray, alignment: .left, font: UIFont.systemFont(ofSize: 12))
        
        btnVideoPlay = MoozyActionButton(image: #imageLiteral(resourceName: "play_circle"), foregroundColor: AppColors.primaryColor, backgroundColor: UIColor.clear, imageSize: .init(width: 50, height: 50)){
            print("Play Vide0")
                var newindex = 0
                LightboxConfig.handleVideo = { from, videoURL in
                    let videoStr = "\(videoURL)"
                    if videoStr.contains("https:"){
                    }
                    let videoController = AVPlayerViewController()
                    videoController.player = AVPlayer(url: videoURL)
                    from.present(videoController, animated: true) {
                        videoController.player?.play()
                    }
                }

        }
        
        
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        videoView?.layer.cornerRadius = 30
        videoView?.layer.masksToBounds = true
        btnVideoPlay?.constraintsWidhHeight(size: .init(width: 50, height: 50))
        btnVideoPlay?.layer.cornerRadius = 25
        
        blurView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2813699959)
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//               stack = UIStackView(views: [lblDatetTimeDay!, statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
        
        stack = UIStackView(views: [lblDatetTimeDay!], axis: .horizontal, spacing: 5, distribution: .fill)
    }
    
    //ConfigureUI
    func configureUI(){
        initializedControls()
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        imgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        mainView?.constraintsWidhHeight(size: .init(width: 160, height: 160))
        stackeContent = UIStackView(views: [imgSendSlected,mainView!,imgRecivedSlected], axis: .horizontal, spacing: 3, distribution: .fill)
        imgRecivedSlected.isHidden = true
            imgSendSlected.isHidden = true
        contentView.addSubview(stackeContent!)
        contentView.addSubview(stack!)
        mainView?.addMultipleSubViews(views: videoView!)
        videoView?.addSubview(btnVideoPlay!)
        videoView?.addSubview(blurView!)
        videoView?.addSubview(imgdownloadFile)
        
        videoView?.addSubview(activityIndicator)
        activityIndicator.constraintsWidhHeight(size: .init(width: 40, height: 40))
        activityIndicator.centerSuperView()
        activityIndicator.isHidden = true
        imgdownloadFile.isHidden = true
        
        
        imgdownloadFile.constraintsWidhHeight(size: .init(width: 40, height: 40))
        imgdownloadFile.centerSuperView()
        imgdownloadFile.isHidden = true
      
        stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 190, height: 160))
        
//        mainView?.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0), size: .init(width: 250, height: 220))
        //viewdioContent.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        videoView?.fillSuperView(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        blurView?.fillSuperView()
        
        btnVideoPlay?.centerSuperView()
        
//        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 25, right: 8))
       
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 6, left: 0, bottom: 8, right: 0))
        
        leadingConstraint = stackeContent!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = false
        
        trailingConstraint = stackeContent!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 8)
        stackLeadingConstraint.isActive = false
        
        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: 8)
        stackTrailingConstraint.isActive = false
        
        //TabGesture
        videoView?.addTapGesture(tagId: 0, action: { [self] _ in
            delegteVideoSelected?.VideoSelected(cell: self)
            
        })
    }
    
    //Generate Thumbnail
    
    func generateThumbnail(url: URL, completion: @escaping ((_ image: UIImage) -> Void)){
        DispatchQueue.global().async {
            let assest = AVAsset(url: url)
            let avAssetImageGeneratior = AVAssetImageGenerator(asset: assest)
            avAssetImageGeneratior.appliesPreferredTrackTransform = true
            let thumnailtime = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgthumbImage = try avAssetImageGeneratior.copyCGImage(at: thumnailtime, actualTime: nil)
                let thumbimage = UIImage(cgImage: cgthumbImage)
                DispatchQueue.main.async {
                    completion(thumbimage)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
