//
//  audioMsgCell.swift
//  Chat_App
//
//  Created by Ali Abdullah on 19/04/2022.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import SwipyCell
var isAudioPlaying : String?  = ""
typealias indexDetails = ((_ index: Int) -> Void)?

class AudioMsgCell: SwipyCell, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
   
    var storeindexNo :indexDetails?
    var delegteAudioSelected : ChatItemSelection?
    
    private var fileName : String?
 //   private var audioRecorder : AVAudioRecorder!
    private var audioSession : AVAudioSession = AVAudioSession.sharedInstance()
    private var settings =   [  AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                AVSampleRateKey: 12000,
                                AVNumberOfChannelsKey: 1,
                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ]
    var recordingName : String?
    
    var timeDeactice = 0.00
    var audiotime: UILabel?
    var lblDatetTimeDay: UILabel?
    var audioslider: UISlider?
    var downloadbtn = UIImageView(image: #imageLiteral(resourceName: "download"), contentModel: .scaleAspectFit)
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
   
    var progressview: UIView?
    var imgChecked: UIImageView?
    var mainView: UIView?
    
    var statusView: UIImageView?
    var stack: UIStackView?
    
    
    
    var sliderimage: UIImageView?
    
    
    var playcellindex = -1
    var playstatus = -1
    var audiotimer:Timer?
    var updateaudiocellui:Timer?
    var downloadtimer:Timer?
    var voicemsgstatus = 0
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var audioPLayer :AVAudioPlayer?
    
    var randomIndex = -1
    var randomSection = -1
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var stackLeadingConstraint: NSLayoutConstraint!
    var stackTrailingConstraint: NSLayoutConstraint!
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    //let statusView = UIImageView(image: UIImage(named: "logo")!, contentModel: .scaleAspectFill)
    let datetTimeDay = UILabel()
    
    
    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var imgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
    var stackeContent : UIStackView?
    var isdelForward : Bool? = false
    var isSmsSelected: Bool?  = false
    var isdownloading : Bool?  = false
    
    var chatData: chat_data? = nil{
        didSet{
          
            let AudioUrl = APIServices.shared.searchFileExist(fileName: chatData?.message ?? "", fileType: 6)
          print(AudioUrl ?? "not fount")
            if AudioUrl == nil {
                downloadbtn.image = UIImage(named: "download")
                
                if  isdownloading == true {
                    downloadbtn.isHidden = true
                      activityIndicator.startAnimating()

                } else {
                    downloadbtn.isHidden = false
                    if activityIndicator.isAnimating == true {
                   
                      activityIndicator.stopAnimating()
                    }
                    
                }
                
                
                }
            else {
                if chatData?.isProgress ?? false == true {
                   activityIndicator.startAnimating()
                    downloadbtn.isHidden = true
               } else {
                       activityIndicator.stopAnimating()
                        downloadbtn.isHidden = false
               }
                //activityIndicator.stopAnimating()
                
                downloadbtn.image = UIImage(named: "play_circle")
                 
                var audioduration:Float? = 0
                var audiotimestring:String? = ""
                (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: AudioUrl ?? "")!)
                
                let currentTime1 = Int((audioduration ?? 0.0)!)
                let minutes = currentTime1/60
                let seconds = currentTime1 - minutes * 60
                audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
                
              //  audiotime?.text = String(audioduration ?? 0.0)
                
            }
            mainView?.backgroundColor =
            chatData?.receiverId == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor
            
            audioslider?.maximumTrackTintColor =  chatData?.receiverId == AppUtils.shared.senderID ? #colorLiteral(red: 1, green: 0.7803921569, blue: 0.7882352941, alpha: 1) : #colorLiteral(red: 0.9215686275, green: 0.6901960784, blue: 0.2666666667, alpha: 0.5)
            
            lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
            
            if chatData?.receipt_status == 1   {
                statusView?.image = UIImage(systemName: "clock")
                activityIndicator.startAnimating()
                 downloadbtn.isHidden = true
                if chatData?.receiverId == AppUtils.shared.senderID && isdownloading != true {
                    activityIndicator.stopAnimating()
                    downloadbtn.isHidden = false
                }
            }else{
                if chatData?.seen == 0 && chatData?.receipt_status == 1 {
                    statusView?.image = UIImage(systemName: "checkmark")
                    activityIndicator.stopAnimating()
                     downloadbtn.isHidden = false
                }else{
                    statusView?.image = UIImage(named: "seen_double_check")
                    statusView?.setImageColor(color: AppColors.primaryColor)
                }
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
                
                if isdelForward! {
                    imgRecivedSlected.isHidden = true
                imgSendSlected.isHidden = false
                }  else {
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
                if isdelForward! {
                imgRecivedSlected.isHidden = false
                imgSendSlected.isHidden = true
                }  else {
                    imgRecivedSlected.isHidden = true
                    imgSendSlected.isHidden = true
                }
            }
        }
       
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializedControls(){
        
        sliderimage = UIImageView(image: UIImage(named: "sliderTint")!.imageWithColor(color1: .clear))
        
        audiotime = UILabel(title: "0.0", fontColor: AppColors.primaryColor, alignment: .left, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Regular, size: 7))
        
        lblDatetTimeDay = UILabel(title: "---", fontColor: UIColor.gray, alignment: .left, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        audioslider = UISlider()
        audioslider?.setThumbImage(sliderimage?.image, for: .normal)
        audioslider?.setThumbImage(sliderimage?.image, for: .highlighted)
        
        audioslider?.maximumTrackTintColor =  chatData?.receiverId == AppUtils.shared.senderID ? #colorLiteral(red: 1, green: 0.7803921569, blue: 0.7882352941, alpha: 1) : #colorLiteral(red: 0.9215686275, green: 0.6901960784, blue: 0.2666666667, alpha: 0.5)
        
        //UIImageView(image: UIImage(named: "sliderTint")!.imageWithColor(color1: recvColor))
        
        //downloadbtn = UIButton(image: UIImage(named: "play-circle-1"), target: self, action: #selector(btnDownloadAction), foregroundColor: AppColors.primaryColor, backgroundColor: .clear)
        
       
        progressview = UIView()
        
        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
        statusView?.setImageColor(color: AppColors.primaryColor)
        mainView = UIView(backgroundColor: AppColors.outgoingMsgColor)
       
       // mainView?.addBorders(edges: .all, color:  #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1), thickness: 1)
        
        mainView?.layer.cornerRadius = 8
        mainView?.layer.masksToBounds = true

        mainView?.layer.masksToBounds = false
     //   mainView?.layer.shadowOffset = CGSizeMake(0, 0)
       // mainView?.layer.shadowColor = UIColor.black
        mainView?.layer.shadowOpacity = 0.23
        mainView?.layer.shadowRadius = 4
        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
        stack = UIStackView(views: [lblDatetTimeDay!], axis: .horizontal, spacing: 5, distribution: .fill)
//        stack = UIStackView(views: [lblDatetTimeDay!,statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
    }

    
    func configureUI(){
        initializedControls()
        
        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        imgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
        mainView?.constraintsWidhHeight(size: .init(width: 230, height: 240))
     
         stackeContent = UIStackView(views: [imgSendSlected,mainView!,imgRecivedSlected], axis: .horizontal, spacing: 3, distribution: .fill)
        imgRecivedSlected.isHidden = true
            imgSendSlected.isHidden = true
      
        contentView.addMultipleSubViews(views: stackeContent!, stack!)
        
        mainView?.addMultipleSubViews(views: downloadbtn, audioslider! , audiotime! ,activityIndicator)
        
        stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 230, height: 45))
        
        downloadbtn.anchor(top: nil, leading: mainView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 7, bottom: 0, right: 0), size: .init(width: 25, height: 25))
        audiotime?.anchor(top: downloadbtn.bottomAnchor, leading: audioslider?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: nil,padding: .init(top: 2, left: 2, bottom: 2, right: 2),size: .init(width: 85, height: 0))
        
        downloadbtn.verticalCenterWith(withView: mainView!)
        
        activityIndicator.anchor(top: nil, leading: mainView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0), size: .init(width: 25, height: 25))
        activityIndicator.verticalCenterWith(withView: mainView!)
       
        
        audioslider?.anchor(top: nil, leading: downloadbtn.trailingAnchor, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 15))
        
        audioslider?.verticalCenterWith(withView: mainView!)
        
         
        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 6, left: 0, bottom: 6, right: 0))
        
        leadingConstraint = stackeContent!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = false
        
        trailingConstraint = stackeContent!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
        stackLeadingConstraint.isActive = false
        
        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
        stackTrailingConstraint.isActive = false
        actionButtons()
    }
    
    func actionButtons(){
        downloadbtn.addTapGesture(tagId: 0, action: { [self] _ in
            delegteAudioSelected?.AudioSelected(cell: self)
        })
        audioslider?.addTarget(self, action: #selector(audiosliderhandle), for: .valueChanged)
        audioslider?.addTarget(self, action: #selector(handleTouchdown), for: .touchDown)
       
       // audioslider?.addTarget(self, action: #selector(audiosliderhandle(sender:)), for: .valueChanged)
    }
    @objc func handleTouchdown(){
        delegteAudioSelected?.audioCellTap(cell: self)
       // player.pause()
//        func audioCellTap(cell: AudioMsgCell)
//        func audioValueChange(cell: AudioMsgCell,valeSlider: String)
    }
    @objc func audiosliderhandle(sender:UISlider) {
        
        print(audioslider?.value)
        delegteAudioSelected?.audioValueChange(cell: self, valeSlider: audioslider?.value ?? 0.0)
    }
    
//    @objc func audiosliderhandle(sender:UISlider) {
//        if audioPLayer != nil && ((audioPLayer?.isPlaying) != nil){
//            audioPLayer?.stop()
//            audiotimer?.invalidate()
//            audioPLayer!.currentTime = TimeInterval(sender.value)
//            audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
//        //    audioPLayer?.volume = 4.0
//            audioPLayer?.play()
//        }else {
//            audioPLayer?.currentTime = TimeInterval(sender.value)
//            self.updateslider(sender: sender)
//        }
//    }
    
//    @objc func updateslider(sender:UISlider) {
//
//        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatData?.message ?? "", fileType: 6)
//
//        var btnclr = AppColors.primaryColor
//        let array = NewMessages(date: "", messages: [])
//        if let _ = array.messages.firstIndex(where: {$0.sender_id == AppUtils.shared.senderID} ) {
//            btnclr = UIColor.white
//        }
//
//        var clrimg = UIImage()
//        if audioPLayer != nil && ((audioPLayer?.isPlaying) == true){
//            clrimg = (UIImage(named: "pausebtn")?.imageWithColor(color1: btnclr))!
//        }else {
//            clrimg = (UIImage(named: "play-circle-1")?.imageWithColor(color1: btnclr))!
//        }
//        downloadbtn?.setImage(clrimg, for: .normal)
//        downloadbtn?.setImageTintColor(btnclr)
//
//        var audioduration:Float? = 0
//        var audiotimestring:String? = ""
//        (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: AudioUrl ?? "")!)
//
//        audioslider?.minimumValue = 0.0
//        audioslider?.maximumValue = audioduration ?? 0.0
//        print(audioduration)
//
//        audioslider?.value =  Float(audioPLayer!.currentTime)
//        audiotime?.isHidden = false
//        let currentTime1 = Int((audioPLayer?.currentTime)!)
//        let minutes = currentTime1/60
//        let seconds = currentTime1 - minutes * 60
//      //  audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
//
//        timeDeactice += 0.01
//
//        if Float(timeDeactice)  >= (audioslider?.maximumValue ?? 0) + 1.00 {
//            audiotimer?.invalidate()
//
//
//        }
//
//    }
    
//    func changebtnclr(imgname: String) -> UIImage {
//        let origImage = UIImage(named: imgname)
//        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
//        return tintedImage!
//    }


//extension AudioMsgCell{
//   
//   
//    @objc func playwithdownload(sender:UIButton) {
//       // initialstepss()
//    }

}


////
////  audioMsgCell.swift
////  Chat_App
////
////  Created by Ali Abdullah on 19/04/2022.
////
//
//import Foundation
//import UIKit
//import AVFoundation
//import AVKit
//import SwipyCell
//
//typealias indexDetails = ((_ index: Int) -> Void)?
//
//class AudioMsgCell: SwipyCell, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
//
//    var storeindexNo :indexDetails?
//
//    private var fileName : String?
// //   private var audioRecorder : AVAudioRecorder!
//    private var audioSession : AVAudioSession = AVAudioSession.sharedInstance()
//    private var settings =   [  AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                                AVSampleRateKey: 12000,
//                                AVNumberOfChannelsKey: 1,
//                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ]
//    var recordingName : String?
//
//    var timeDeactice = 0.00
//    var audiotime: UILabel?
//    var lblDatetTimeDay: UILabel?
//    var audioslider: UISlider?
//    var downloadbtn: UIButton?
//    var progressview: UIView?
//    var imgChecked: UIImageView?
//    var mainView: UIView?
//
//    var statusView: UIImageView?
//    var stack: UIStackView?
//
//
//
//    var sliderimage: UIImageView?
//
//
//    var playcellindex = -1
//    var playstatus = -1
//    var audiotimer:Timer?
//    var updateaudiocellui:Timer?
//    var downloadtimer:Timer?
//    var voicemsgstatus = 0
//    var audioPlayer: AVAudioPlayer?
//    var recordingSession: AVAudioSession?
//    var audioRecorder: AVAudioRecorder?
//    var audioPLayer :AVAudioPlayer?
//
//    var randomIndex = -1
//    var randomSection = -1
//
//    var leadingConstraint: NSLayoutConstraint!
//    var trailingConstraint: NSLayoutConstraint!
//
//    var stackLeadingConstraint: NSLayoutConstraint!
//    var stackTrailingConstraint: NSLayoutConstraint!
//
//    let messageLabel = UILabel()
//    let bubbleBackgroundView = UIView()
//    //let statusView = UIImageView(image: UIImage(named: "logo")!, contentModel: .scaleAspectFill)
//    let datetTimeDay = UILabel()
//
//
//    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var imgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var stackeContent : UIStackView?
//    var isdelForward : Bool? = false
//    var isSmsSelected: Bool?  = false
//    var isAudioPlaying : String?  = ""
//
//    var chatData: chatModel? = nil{
//        didSet{
//            let AudioUrl = APIServices.shared.searchFileExist(fileName: chatData?.message ?? "", fileType: 6)
//          print(AudioUrl ?? "not fount")
//            if AudioUrl == nil {
//                 downloadbtn?.setImage(UIImage(named: "icon-download3"), for: .normal)
//                }
//            else {
//                downloadbtn?.setImage(UIImage(named: "play-circle-1"), for: .normal)
//
//                var audioduration:Float? = 0
//                var audiotimestring:String? = ""
//                (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: AudioUrl ?? "")!)
//
//                let currentTime1 = Int((audioduration ?? 0.0)!)
//                let minutes = currentTime1/60
//                let seconds = currentTime1 - minutes * 60
//                audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
//
//
//              //  audiotime?.text = String(audioduration ?? 0.0)
//
//            }
//            mainView?.backgroundColor =
//            chatData?.receiverId._id == AppUtils.shared.senderID ? AppColors.incomingMsgColor : AppColors.outgoingMsgColor
//
//            lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
//
//            if chatData?.receiptStatus == 0{
//                statusView?.image = UIImage(systemName: "clock")
//            }else{
//                if chatData?.isSeen == 0 && chatData?.receiptStatus == 1 {
//                    statusView?.image = UIImage(systemName: "checkmark")
//                }else{
//                    statusView?.image = UIImage(named: "seen_double_check")
//                    statusView?.setImageColor(color: AppColors.primaryColor)
//                }
//            }
//
//            if  isSmsSelected == true {
//                imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//                imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//            } else {
//                imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
//                imgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
//
//            }
//
//            if chatData?.receiverId._id == AppUtils.shared.senderID {
//                leadingConstraint.isActive = true
//                trailingConstraint.isActive = false
//                stackLeadingConstraint.isActive = true
//                stackTrailingConstraint.isActive = false
//                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 12, clipToBonds: true)
//                statusView?.isHidden = true
//
//                if isdelForward! {
//                    imgRecivedSlected.isHidden = true
//                imgSendSlected.isHidden = false
//                }  else {
//                    imgRecivedSlected.isHidden = true
//                    imgSendSlected.isHidden = true
//                }
//            } else {
//                leadingConstraint.isActive = false
//                trailingConstraint.isActive = true
//
//                stackLeadingConstraint.isActive = false
//                stackTrailingConstraint.isActive = true
//                mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12, clipToBonds: true)
//                statusView?.isHidden = false
//                if isdelForward! {
//                imgRecivedSlected.isHidden = false
//                imgSendSlected.isHidden = true
//                }  else {
//                    imgRecivedSlected.isHidden = true
//                    imgSendSlected.isHidden = true
//                }
//            }
//        }
//
//    }
//
//
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func dowloadAudio() {
//
//    }
//
//    func initializedControls(){
//
//        sliderimage = UIImageView(image: UIImage(named: "sliderTint")!.imageWithColor(color1: AppColors.primaryColor))
//
//        audiotime = UILabel(title: "0.0", fontColor: AppColors.primaryColor, alignment: .left, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Regular, size: 7))
//
//        lblDatetTimeDay = UILabel(title: "---", fontColor: UIColor.gray, alignment: .left, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Regular, size: 12))
//
//        audioslider = UISlider()
//        audioslider?.setThumbImage(sliderimage?.image, for: .normal)
//        audioslider?.setThumbImage(sliderimage?.image, for: .highlighted)
//
//        //UIImageView(image: UIImage(named: "sliderTint")!.imageWithColor(color1: recvColor))
//
//        downloadbtn = UIButton(image: UIImage(named: "play-circle-1"), target: self, action: #selector(btnDownloadAction), foregroundColor: AppColors.primaryColor, backgroundColor: .clear)
//
//
//        progressview = UIView()
//
//        statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
//        statusView?.setImageColor(color: AppColors.primaryColor)
//        mainView = UIView(backgroundColor: AppColors.outgoingMsgColor)
//
//       // mainView?.addBorders(edges: .all, color:  #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1), thickness: 1)
//
//        mainView?.layer.cornerRadius = 8
//        mainView?.layer.masksToBounds = true
//
//        mainView?.layer.masksToBounds = false
//     //   mainView?.layer.shadowOffset = CGSizeMake(0, 0)
//       // mainView?.layer.shadowColor = UIColor.black
//        mainView?.layer.shadowOpacity = 0.23
//        mainView?.layer.shadowRadius = 4
//        statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//        stack = UIStackView(views: [lblDatetTimeDay!,statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
//    }
//
//    @objc func btnDownloadAction(){
//        print("download")
//        (storeindexNo)!
//    }
//
//    func configureUI(){
//        initializedControls()
//
//        imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//        imgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//        mainView?.constraintsWidhHeight(size: .init(width: 250, height: 240))
//
//         stackeContent = UIStackView(views: [imgSendSlected,mainView!,imgRecivedSlected], axis: .horizontal, spacing: 3, distribution: .fill)
//        imgRecivedSlected.isHidden = true
//            imgSendSlected.isHidden = true
//
//        contentView.addMultipleSubViews(views: stackeContent!, stack!)
//
//        mainView?.addMultipleSubViews(views: downloadbtn!, audioslider! , audiotime!)
//
//        stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 280, height: 45))
//
//        downloadbtn?.anchor(top: nil, leading: mainView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0), size: .init(width: 25, height: 25))
//        audiotime?.anchor(top: downloadbtn?.bottomAnchor, leading: audioslider?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: nil,padding: .init(top: 2, left: 2, bottom: 2, right: 2),size: .init(width: 85, height: 0))
//
//        downloadbtn?.verticalCenterWith(withView: mainView!)
//
//        audioslider?.anchor(top: nil, leading: downloadbtn?.trailingAnchor, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 1))
//
//        audioslider?.verticalCenterWith(withView: mainView!)
//
//
//        stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 4, left: 0, bottom: 8, right: 0))
//
//        leadingConstraint = stackeContent!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
//        leadingConstraint.isActive = false
//
//        trailingConstraint = stackeContent!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
//        trailingConstraint.isActive = true
//
//        stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
//        stackLeadingConstraint.isActive = false
//
//        stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
//        stackTrailingConstraint.isActive = false
//        actionButtons()
//    }
//
//    func actionButtons(){
//        downloadbtn?.addTarget(self, action: #selector(playwithdownload(sender:)), for: .touchUpInside)
//        audioslider?.addTarget(self, action: #selector(audiosliderhandle(sender:)), for: .valueChanged)
//    }
//
//    @objc func audiosliderhandle(sender:UISlider) {
//        if audioPLayer != nil && ((audioPLayer?.isPlaying) != nil){
//            audioPLayer?.stop()
//            audiotimer?.invalidate()
//            audioPLayer!.currentTime = TimeInterval(sender.value)
//            audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
//        //    audioPLayer?.volume = 4.0
//            audioPLayer?.play()
//        }else {
//            audioPLayer?.currentTime = TimeInterval(sender.value)
//            self.updateslider(sender: sender)
//        }
//    }
//
//    @objc func updateslider(sender:UISlider) {
//
//        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatData?.message ?? "", fileType: 6)
//
//        var btnclr = AppColors.primaryColor
//        let array = NewMessages(date: "", messages: [])
//        if let _ = array.messages.firstIndex(where: {$0.sender_id == AppUtils.shared.senderID} ) {
//            btnclr = UIColor.white
//        }
//
//        var clrimg = UIImage()
//        if audioPLayer != nil && ((audioPLayer?.isPlaying) == true){
//            clrimg = (UIImage(named: "pausebtn")?.imageWithColor(color1: btnclr))!
//        }else {
//            clrimg = (UIImage(named: "play-circle-1")?.imageWithColor(color1: btnclr))!
//            //(UIImage(systemName: "play-circle-1")?.imageWithColor(color1: btnclr))
//        }
//        downloadbtn?.setImage(clrimg, for: .normal)
//        downloadbtn?.setImageTintColor(btnclr)
//
//        var audioduration:Float? = 0
//        var audiotimestring:String? = ""
//        (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: AudioUrl ?? "")!)
//
//        //audioslider?.value = 0.0
//        audioslider?.minimumValue = 0.0
//        audioslider?.maximumValue = audioduration ?? 0.0
//        print(audioduration)
//      //  if audioduration
//        print(TimeInterval.self)
//
//
//        audioslider?.value =  Float(audioPLayer!.currentTime)
//        audiotime?.isHidden = false
//        let currentTime1 = Int((audioPLayer?.currentTime)!)
//        let minutes = currentTime1/60
//        let seconds = currentTime1 - minutes * 60
//      //  audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
//
//        timeDeactice += 0.01
//
//        if Float(timeDeactice)  >= (audioslider?.maximumValue ?? 0) + 1.00 {
//            audiotimer?.invalidate()
//
//
//        }
//
//    }
//
//    func changebtnclr(imgname: String) -> UIImage {
//        let origImage = UIImage(named: imgname)
//        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
//        return tintedImage!
//    }
//}
//
//extension AudioMsgCell{
//
//    func getDocumentsDirectory() -> URL {
//         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//         return paths[0]
//     }
//
//   func initialstepss () {
//        fileName = NSUUID().uuidString   ///  unique string value
////
//       let audioFilename = getDocumentsDirectory().appendingPathComponent((recordingName?.appending(".m4a") ?? fileName!.appending(".m4a")))
//
//        do{ /// Setup audio player
//            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
//            audioRecorder = try AVAudioRecorder(url: audioFilename , settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.isMeteringEnabled = true
//            audioRecorder?.prepareToRecord()
//            audioPlayer?.stop()
//        } catch let audioError as NSError {
//            print ("Error setting up: %@", audioError)
//        }
//    }
//
//    @objc func playwithdownload(sender:UIButton) {
//       // initialstepss()
//
//
//        if chatData?.receiverId._id == AppUtils.shared.senderID {
//
//
//        }
//        var btnclr = UIColor.white
//        btnclr = hexStringToUIColor("25A8E0")
//
//        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatData?.message ?? "", fileType: 6)
//
//       // recorder.play(name: AudioUrl ?? "")
//        print(playstatus)
//
//        if AudioUrl != nil{
//            if playstatus < 0{
//                var error: NSError?
//                do {
//                    guard let audiourl = URL(string: AudioUrl!) else {return}
//                    if audioPLayer != nil {
//                        audioPLayer?.stop()
//                        audiotimer?.invalidate()
//                    }
//                    audioPLayer = try AVAudioPlayer(contentsOf: audiourl)
//                } catch let err as NSError {
//                    error = err
//                    self.audioPLayer = nil
//                }
//                if let err = error {
//                    print("AVAudioPlayer error: \(err.localizedDescription)")
//                }else {
//
//                    audioPLayer?.delegate = self
//                    audioPLayer?.prepareToPlay()
//                    audioPLayer?.play()
//                    checckcellplaystatus(index: 0, status: 1)
//                    //}
//
//                }
//                timeDeactice = 0.00
//            }else if playstatus > 0{
//                timeDeactice = 0.00
//                if ((audioPLayer?.isPlaying) == true){
//                    audiotimer?.invalidate()
//                    downloadbtn?.setImage(UIImage(named: "play-circle-1"), for: .normal)
//                   // downloadbtn?.setImageTintColor(btnclr)
//                    self.audioPLayer?.pause()
//                }else{
//
//                    downloadbtn?.setImage(UIImage(named: "playbtn"), for: .normal)
//                   //  downloadbtn?.setImage(UIImage(named: "pausebtn"), for: .normal)
//                    downloadbtn?.setImageTintColor(btnclr)
//                    audiotimer?.invalidate()
//                 //   audioPLayer?.volume = 4.0
//                    self.audioPLayer?.play()
//                    audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
//
//                }
//            }else {
//                timeDeactice = 0.00
//                audioPLayer?.stop()
//                checckcellplaystatus(index: playcellindex, status: -1)
//                playwithdownload(sender: sender)
//            }
//        }
//    }
//
//    @objc func checckcellplaystatus(index:Int,status:Int) {
//        print(status)
//        playstatus = status
//        if status > 0 {
//            playcellindex = index
//            audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider), userInfo: nil, repeats: true)
//        } else {
//            audiotimer?.invalidate()
//
//            playcellindex = -1
//            randomIndex = -1
//            randomSection = -1
//        }
//    }
//
//
//
////    func updateslideraftercomplete() {
////
////        var btnclr = AppColors.primaryColor
////        let array = NewMessages(date: "", messages: [])
////        if let _ = array.messages.firstIndex(where: {$0.sender_id == AppUtils.shared.senderID} ) {
////            btnclr = UIColor.white
////        }
////        downloadbtn?.setImage(self.changebtnclr(imgname: "playbtn"), for: .normal)
////        downloadbtn?.setImageTintColor(btnclr)
////        audioslider?.value = 0.0
////        let currentTime1 = Int((audioPLayer?.duration)!)
////        let minutes = currentTime1/60
////        let seconds = currentTime1 - minutes * 60
////       // audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
////    }
//}
//
