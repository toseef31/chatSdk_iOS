////
////  PlayVedioVC.swift
////  Moozy_App
////
////  Created by Toseef Ahmed on 23/06/2022.
//
import AVKit
import Foundation
import UIKit
import SwiftUI



import UIKit


import Foundation
import UIKit
import AVKit

class videoPlayers : UIViewController, AVPlayerViewControllerDelegate {
    
    var topVideoView = UIView()
    
    var videoURL: URL!
    
    var player: AVPlayer!
    var avPlayerViewController: AVPlayerViewController!
    
    init(vedioUrl: String){
           self.videoURL = URL(string: vedioUrl)
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.navigationController?.navigationBar.isHidden = true

        let swipeUpDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeUpDown.direction = .down
        
//        DispatchQueue.global(qos: .background).async {
            self.setupview()
          //  self.videoURL = videoURL //URL(string: videoURL)
             DispatchQueue.main.async {
                // update ui here
                self.videoPlayView()
                self.getVideoTotalTime()
                self.player.play()
            }
//        }
    }
    
    @objc func back(){
        player.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupview(){
        topVideoView.backgroundColor = .black
        view.addSubview(topVideoView)
        topVideoView.fillSuperView()
    }
    
    func videoPlayView(){
        
        let asset = AVAsset(url: videoURL!) // link to some video
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let screenshotTime = CMTime(seconds: 1, preferredTimescale: 1)
        
        if let imageRef = try? imageGenerator.copyCGImage(at: screenshotTime, actualTime: nil) {
            
            let image = UIImage(cgImage: imageRef)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.tag = 666
            
            avPlayerViewController = AVPlayerViewController()
            avPlayerViewController.contentOverlayView?.addSubview(imageView)
            imageView.fillSuperView()
            
            
            
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            avPlayerViewController.player = player
            
            
            addChild(avPlayerViewController)
            topVideoView.addSubview(avPlayerViewController.view)
            avPlayerViewController.view.fillSuperView()
            avPlayerViewController.view.frame = topVideoView.bounds
            avPlayerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            avPlayerViewController.didMove(toParent: self)
            
            NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReadyToPlay(notification:)),
                                                   name: .AVPlayerItemNewAccessLogEntry,
                                                   object: player.currentItem)
            
            
            NotificationCenter.default.addObserver(self,selector: #selector(playedToEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        }
    }
    
    
    func getVideoTotalTime(){
        
        DispatchQueue.global(qos: .background).async { [self] in
            
            let videoURL = URL(string: "\(videoURL!)")
            let asset = AVAsset(url: videoURL!) // link to some video
            
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            let minutes = Int(durationTime)/60
            let seconds = Int(durationTime) % 60
            let videoDuration = "\(minutes):\(seconds) mins"
            
            // do your job here
            DispatchQueue.main.async { [self] in
                // update ui here
             //   timeLabel.text  = "\(videoDuration)"
            }
        }
    }
    
    @objc func playerItemDidReadyToPlay(notification: Notification) {
        if let _ = notification.object as? AVPlayerItem {
            
            // player is ready to play now!!
            let v = avPlayerViewController.contentOverlayView?.viewWithTag(666)
            v?.removeFromSuperview()
        }
    }
    
    @objc func playedToEnd(notification: Notification) {
       print("End Video")
    }
}

//
class playVedioVC: UIViewController, playVideoDelegate {

    var imagesArr = [chatModel]()
    var initialScrollDone = false
    var index = Int()
    var playIndex:IndexPath? = IndexPath()
    var vediour = ""
    var imgVedioView = UIImageView()
    var player:AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerView =  UIView(backgroundColor: .black, maskToBounds: true)
    let cache = NSCache<NSURL, UIImage>()
    var url : URL!
    var btnPlayVedio  : MoozyActionButton?
    var btnHiddenStatus = false

    var timeSlider = UISlider(backgroundColor: .clear, maskToBounds: true)
    var currentTimeLabel = UILabel(title: "00:00", fontColor: AppColors.primaryColor , alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Bold, size: 13), underLine: false)
    init(data : [chatModel]? = nil, index: Int? = 0,vedioUrl: String){
        imagesArr.removeAll()
        self.imagesArr = data ?? []
        self.index = index ?? 0
        self.vediour = vedioUrl
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        url = URL(string: vediour)
        configureUI()

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.navigationController?.navigationBar.isHidden = true

        let swipeUpDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeUpDown.direction = .down

        playerView.addTapGesture(tagId: 0) {_ in
            print("Add Chat")
            if   self.btnHiddenStatus {
                 self.btnPlayVedio?.isHidden = false
                self.btnHiddenStatus = false
            }
            else{
                self.btnPlayVedio?.isHidden = true
                self.btnHiddenStatus = true
            }
        }

        startmusic()
        self.player.play()

        self.btnPlayVedio?.isHidden = true
        btnHiddenStatus = true
        self.player.play()
        self.btnPlayVedio?.setImage(#imageLiteral(resourceName: "pausebtn"), for: .normal)
        self.btnPlayVedio?.setImageTintColor(AppColors.primaryColor)

        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        initialScrollDone = false
    }

    func initializedControls(){

        btnPlayVedio =  MoozyActionButton(image: UIImage(named: "playVideo"), foregroundColor: AppColors.primaryColor, backgroundColor: UIColor.clear, imageSize: .init(width: 60, height: 60)){ [self] in

            if self.player.isPlaying {
                self.player.pause()
                self.btnPlayVedio?.setImage(#imageLiteral(resourceName: "playVideo"), for: .normal)
                self.btnPlayVedio?.setImageTintColor(AppColors.primaryColor)
                self.btnPlayVedio?.isHidden = false
                btnHiddenStatus = false

            }
            else{

                self.btnPlayVedio?.isHidden = true
                btnHiddenStatus = true
                self.player.play()
                self.btnPlayVedio?.setImage(#imageLiteral(resourceName: "pausebtn"), for: .normal)
                self.btnPlayVedio?.setImageTintColor(AppColors.primaryColor)

            }
        }

        DownloadData.sharedInstance.videoPreviewImage(url: URL(fileURLWithPath: vediour),completion: { (videoImage) in
            DispatchQueue.main.async { [self] in
                imgVedioView.image = videoImage
            }
            if let vImg = videoImage{
                self.cache.setObject(vImg, forKey: url as NSURL)
            }
        })
    }

    func configureUI(){
        initializedControls()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(playerView)
        view.addSubview(btnPlayVedio!)
        view.addSubview(timeSlider)
        view.addSubview(currentTimeLabel)

        currentTimeLabel.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 20, right: 20),size: .init(width: 40, height: 0))

        timeSlider.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: currentTimeLabel.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 20, right: 10))

        btnPlayVedio?.constraintsWidhHeight(size: .init(width: 60, height: 60))
        btnPlayVedio?.centerSuperView()
        playerView.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }


    @objc func back(){
        imagesArr.removeAll()
        if playIndex != nil{
            //let cell =  self.collImages?.cellForItem(at: playIndex!) as? ImageVideoCell
            // cell?.stop()
        }
        player.pause()
        self.navigationController?.popViewController(animated: true)
    }

    func playVideo(indexPath: IndexPath) {
        ///  let cell = self.collImages?.cellForItem(at: indexPath)
        //Video player
        let msg = imagesArr[indexPath.row].message
        if  let url = URL(string: vediour){
            let avPlayer = AVPlayer(url: url)
            //                imgVedioView.player = avPlayer
            //                imgVedioView.player?.play()
        }

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
        let w = vediour
        self.player = AVPlayer(url: URL(string: w)!)
        self.playerLayer = AVPlayerLayer(player: self.player)
        let seconds = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if self.playerLayer != nil{
                self.playerLayer.videoGravity = .resizeAspect
                self.playerLayer.frame = self.playerView.bounds
                    self.playerView.layer.addSublayer(self.playerLayer)
                self.btnPlayVedio?.bringSubviewToFront(self.view)
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
                                self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            }
                        if(Float(currentItem.currentTime().seconds) == self?.timeSlider.maximumValue){
                           // self?.timeSlider.value = 0

                            let time: CMTime = CMTimeMake(value: Int64(0*1000), timescale: 1000)
                            self?.player.seek(to: time)

                            self?.btnPlayVedio?.setImage(#imageLiteral(resourceName: "playVideo"), for: .normal)
                            self?.btnPlayVedio?.setImageTintColor(AppColors.primaryColor)
                            self?.btnPlayVedio?.isHidden = false
                            self?.btnHiddenStatus = false

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

    func stop() {
        if player != nil{
            self.player.seek(to: CMTime.zero)
            //sender.tag = 0
            // playBtn?.tag = 0
            player.pause()
            // playBtn?.setImage(UIImage(named: "playVideo"), for: .normal)
            if playerLayer != nil{
                //self.playerLayer.removeFromSuperlayer()
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
