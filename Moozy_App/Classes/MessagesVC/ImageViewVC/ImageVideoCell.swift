//
//  ImageVideoCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 30/05/2022.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Kingfisher
import Photos

protocol playVideoDelegate{
    func playVideo(indexPath: IndexPath)
}

class ImageVideoCell: UICollectionViewCell{
    
    var imageView: UIImageView?
    var videoView: AVPlayerLayer?
    var playerView: UIView?
    var playBtn: MoozyActionButton?
    var closeBtn: MoozyActionButton?
    var currentTimeLabel:UILabel?
    var timeSlider: UISlider!
    
    var player:AVPlayer!
    var playerLayer: AVPlayerLayer!
    var indexPath = IndexPath()
    var closeVCBtn : (() -> Void)? = nil
    var playerItem: AVPlayerItem!
    var playerViewController = AVPlayerViewController()
    var playIndex: IndexPath? = IndexPath()
    
    var sender = 0
    
    var delegate:playVideoDelegate?
    
    var dataSet: chatModel? = nil{
        didSet{
            
            //\(API.GET_IMAGE)\(msg)
            
            let message = dataSet?.message ?? ""
            
            if dataSet?.messageType == 1{
                
                videoView?.isHidden = true
                playBtn?.isHidden = true
                playerView?.isHidden = true
                print(dataSet?.message)
                let cellImage = AppUtils.shared.loadImage(fileName: dataSet?.message ?? "")
                if cellImage != nil{
                    imageView?.image = cellImage
                }else{
                    if  let url = URL(string: ""){
                        KingfisherManager.shared.retrieveImage(with: url) { [self] result in
                            let image = try? result.get().image
                            if let image = image {
                                imageView?.image = image
                            }else{
                                imageView?.image = nil
                            }
                        }
                    }
                    
                }
                
            }else if (dataSet?.messageType == 5){
                if  let url = URL(string: ""){
                    playBtn?.isHidden = false
                    videoView?.isHidden = false
                    playerView?.isHidden = false
                    playIndex = indexPath
                    postVideoURL = "\(url)"
                }
            }
        }
    }
    
    
    var postImageURL: String? {
        didSet {
            if let url = postImageURL {
                UIImage.loadImageUsingCacheWithUrlString(url) { image in
                    if url == self.postImageURL {
                        self.imageView?.image = image
                    }
                }
            }else {
                self.imageView?.image = nil
            }
        }
    }
    
    var postVideoURL: String?{
        didSet {
            if postVideoURL != nil {
                startmusic()
            }else {
                //self.imageView?.image = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        playerLayer = nil
//        postImageURL = nil
//        imageView!.image = nil
//        if playerLayer != nil{
//            self.playerLayer.removeFromSuperlayer()
//        }
    }
    
    
    func initializedControls(){
        
        imageView = UIImageView(image: UIImage(named: "placeholder")!, contentModel: .scaleAspectFit)
        
        videoView = AVPlayerLayer()
        
        playerView = UIView()
        
        playBtn = MoozyActionButton(image: UIImage(named: "placeholder"), foregroundColor: UIColor.black, backgroundColor: .blue, cornerRadius: 3, imageSize: .init(width: 40, height: 40), action: { [self] in
            print("PLAY BUTTON")
            
            if sender == 0{
                guard let currentItem = self.player.currentItem else {return}
                if(Float(currentItem.currentTime().seconds) == timeSlider.maximumValue){
                    timeSlider.value = 0
                    let time: CMTime = CMTimeMake(value: Int64(0*1000), timescale: 1000)
                    player.seek(to: time)
                }
                sender = 1
                player.play()
                playBtn?.setImage(nil, for: .normal)
            }else{
                sender = 0
                player.pause()
                playBtn?.setImage(UIImage(named: "playVideo"), for: .normal)
                timeSlider.thumbTintColor = AppColors.primaryColor
                playBtn?.setImageTintColor(AppColors.primaryColor)
                timeSlider.minimumTrackTintColor = AppColors.primaryColor
            }
            
        })
        
        closeBtn = MoozyActionButton(image: UIImage(named: "profile3"), foregroundColor: UIColor.black, backgroundColor: .blue, cornerRadius: 3, imageSize: .init(width: 40, height: 40), action: { [self] in
            print("Close BUTTON")
            
            if player != nil{
                self.player.seek(to: CMTime.zero)
                self.player.pause()
                if playerLayer != nil{
                    self.playerLayer.removeFromSuperlayer()
                }
            }
            
            if let downloadBtnAction = self.closeVCBtn{
                downloadBtnAction()
            }
        })
        
        currentTimeLabel = UILabel(title: "0.00", fontColor: .black, alignment: .center, font: UIFont.font(.Poppins, type: .SemiBold, size: 12))
        
        timeSlider = UISlider()
        timeSlider.minimumTrackTintColor = AppColors.primaryColor
        timeSlider.thumbTintColor = AppColors.primaryColor
        playBtn?.setImageTintColor(AppColors.primaryColor)
        
    }
    
    func configureUI(){
        initializedControls()
        
        contentView.addMultipleSubViews(views: imageView!)
        
        imageView?.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//        playBtn?.centerSuperView()
    }
    
    func startmusic()
    {
        if player != nil{
            self.player.seek(to: CMTime.zero)
            self.player.pause()
            if playerLayer != nil{
                self.playerLayer.removeFromSuperlayer()
            }
        }
        self.player = AVPlayer(url: URL(string: postVideoURL!)!)
        self.playerLayer = AVPlayerLayer(player: self.player)
        let seconds = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if self.playerLayer != nil{
                self.playerLayer.videoGravity = .resizeAspect
                self.playerLayer.frame = self.playerView!.bounds
                self.playerView?.layer.addSublayer(self.playerLayer)
            }
        }
        self.player.pause()
        addTimeObserver()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            print(Float(currentItem.duration.seconds))
            
            if(Float(currentItem.duration.seconds) > 0.0)
            {
                self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
                self?.timeSlider.minimumValue = 0
                self?.timeSlider.value = Float(currentItem.currentTime().seconds)
                self?.currentTimeLabel?.text = self?.getTimeString(from: currentItem.currentTime())
            }
            if(Float(currentItem.currentTime().seconds) == self?.timeSlider.maximumValue){
                self?.timeSlider.value = 0
                
                let time: CMTime = CMTimeMake(value: Int64(0*1000), timescale: 1000)
                self?.player.seek(to: time)
                self?.playBtn?.isHidden = false
                self?.playBtn?.tag = 0
                self?.playBtn?.setImage(#imageLiteral(resourceName: "playVideo"), for: .normal)
            }
        })
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
    
    func stop(){
        if player != nil{
            self.player.seek(to: CMTime.zero)
            //sender.tag = 0
            playBtn?.tag = 0
            player.pause()
            playBtn?.setImage(UIImage(named: "playVideo"), for: .normal)
            if playerLayer != nil{
                //self.playerLayer.removeFromSuperlayer()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

