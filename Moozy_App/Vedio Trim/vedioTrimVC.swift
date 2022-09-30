//
//  vedioTrimVC.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 22/06/2022.
//

import Foundation
import UIKit
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import AVKit
import mobileffmpeg
import MBProgressHUD

enum mediatypes {
    case image
    case video
}
var isDiscarded:Bool = false
func tempURL_Video() -> URL? {
    let directory = NSTemporaryDirectory() as NSString
    
    let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let tempDocumentsDirectory = tempPath[0] as NSString
    
    let uniqueVideoID = "\(randomString(length: 5)).mp4"
    //        let tempDataPath = tempDocumentsDirectory.appendingPathComponent(uniqueVideoID)
    
    if directory != "" {
        let path = tempDocumentsDirectory.appendingPathComponent(uniqueVideoID)
        return URL(fileURLWithPath: path)
    }
    return nil
}

var hud: MBProgressHUD = MBProgressHUD()

enum loadermodes {
    case progress
    case loading
}

func startCustomLoading(mode:loadermodes,Label:String,DetailLabel:String, intoview:UIView){
    DispatchQueue.main.async(execute: {
        print("Start Loading Called.")
        
        hud = MBProgressHUD.showAdded(to:intoview, animated: true)
        hud.mode = mode == loadermodes.progress ? .determinate : .indeterminate
        hud.label.text = Label //"Please Wait"
        hud.detailsLabel.text = DetailLabel//"Downloading Frame Pack...":"Downloading Sticker Pack..."
        hud.bezelView.style = .solidColor
        hud.bezelView.color =  .red //hexColour(hexValue: 0xFF5A60).withAlphaComponent(0.9) //appTheme.theme_color//
//        if appTheme == .yellowTheme5 || appTheme == .grayTheme8{
//            hud.contentColor = appTheme.theme_Add_Btn_color
//        }else  if appTheme == .whiteTheme {
//            hud.contentColor = hexStringToUIColor("25A8E0")
//        }else{
//            hud.contentColor = UIColor.white
        }
                             )
    }
                             


func resolutionForLocalVideo(url: URL) -> CGSize? {
    if FileManager.default.fileExists(atPath: url.path) {
        let alltracks = AVURLAsset(url: url).tracks
        print("alltracks:\(alltracks)")
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    return nil
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

protocol videoTrimDelegate {
    func didgetTrimedvideoduet(url:URL)
}
//MARK: CROP VIDEO
func getMediaDuration(url: URL!) -> Float{
    let asset : AVURLAsset = AVURLAsset(url: url) as AVURLAsset
    let duration : CMTime = asset.duration
    return Float(CMTimeGetSeconds(duration))
}
class VideoTrim_ViewController: UIViewController {

    var delegate:videoTrimDelegate?
    var DuetSize:CGSize?
    
   @IBOutlet weak var btnplay: UIButton!
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var frameContainerView: UIView!
    @IBOutlet weak var imageFrameView: UIView!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_next: UIButton!

    var isSliderEnd = true
    var playbackTimeCheckerTimer: Timer! = nil
    let playerObserver: Any? = nil

    let exportSession: AVAssetExportSession! = nil
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var asset: AVAsset!

    var totalVid:Int = 0
    var url:URL! = nil
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Float64!

    var videoPlaybackPosition: CGFloat = 0.0
    var cache:NSCache<AnyObject, AnyObject>!
    var rangSlider: RangeSlider! = nil

    var startTimestr = ""
    var endTimestr = ""

//    var optiontype:OptionTypes = .VIDEO

    //MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadViews()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.restorationIdentifier = "VideoTrimVC"
        //if appTheme == .whiteTheme{
        btn_next.backgroundColor = AppColors.primaryColor //hexStringToUIColor("25A8E0")
//        }else if appTheme == .yellowTheme5 || appTheme == .grayTheme8{
//            btn_next.backgroundColor = appTheme.theme_black_Color
//        }else{
//            btn_next.backgroundColor = appTheme.theme_color
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        videoPlayerView.frame = self.view.frame
        if asset != nil
        {
            thumbTime = asset.duration
            thumbtimeSeconds      = CMTimeGetSeconds(thumbTime)

            self.viewAfterVideoIsPicked()

            let item:AVPlayerItem    = AVPlayerItem(asset: asset)
            player                   = AVPlayer(playerItem: item)
            playerLayer              = AVPlayerLayer(player: player)
            playerLayer.frame        = videoPlayerView.bounds
            //            videoPlayerView.backgroundColor = .green
            //            playerLayer.backgroundColor = UIColor.red.cgColor
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            player.actionAtItemEnd   = AVPlayer.ActionAtItemEnd.none

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnvideoPlayerView))
            self.videoPlayerView.addGestureRecognizer(tap)
            self.tapOnvideoPlayerView(tap: tap)
            videoPlayerView.layer.addSublayer(playerLayer)
            player.play()
            setLooper()
        }
    }

    func setLooper(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        hideCustomLoading()
        self.player.pause()
        //        self.player = nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.player.pause()
        hideCustomLoading()
        hideCustomLoading()
        hideCustomLoading()
        print("Trim Loader  viewDidDisappear")
    }

    //Loading Views
    func loadViews(){
        //Whole layout view
        let width = btn_back.frame.size.width
        frameContainerView.isHidden = true
        imageFrameView.layer.cornerRadius = 5.0
        imageFrameView.layer.borderWidth  = 1.0
        imageFrameView.layer.borderColor  = UIColor.white.cgColor
        imageFrameView.layer.masksToBounds = true
        player = AVPlayer()
        //Allocating NsCahe for temp storage
        self.cache = NSCache()
    }
    //MARK:-  Action for crop video
    @IBAction func Action_Play(_ sender: UIButton) {
        self.tapOnvideoPlayerView(tap: UITapGestureRecognizer())
    }

    @IBAction func cropVideo(_ sender: Any)
    {
        print("Video cropVideo")
        let start = Float(startTimestr)
        let end   = Float(endTimestr)
        if Int(end! - start!) > 3 {
          startCustomLoading(mode: .loading, Label: "Please wait", DetailLabel: "Preparing Video", intoview: self.view)
            //SHOW_CUSTOM_LOADER()
            if (Int(end! - start!) != Int(getMediaDuration(url: self.url as URL?)) ){
                self.trimVideo(sourceURL1: self.url! as NSURL, startTime: start!, endTime: end!)
            }else{
                self.reduceVideoSizeffmpeg(videourl: self.url)
            }
        }else{
//            self.view.makeToast("vidmin3sec")
        }
    }

    @IBAction func Action_back(_ sender: Any) {
        isDiscarded = true
        hideCustomLoading()

        self.navigationController?.popViewController(animated: true)
    }
}

//Subclass of VideoMainViewController
extension VideoTrim_ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    func viewAfterVideoIsPicked()
    {
        //Rmoving player if alredy exists
        if(playerLayer != nil)
        {
            playerLayer.removeFromSuperlayer()
        }

        self.createImageFrames()

        //unhide buttons and view after video selection

        frameContainerView.isHidden = false

        isSliderEnd = true
        startTimestr = "\(0.0)"
        endTimestr   = "\(thumbtimeSeconds!)"
        self.createrangSlider()
    }

    //Tap action on video player
    @objc func tapOnvideoPlayerView(tap: UITapGestureRecognizer)
    {
        if self.player.isPlaying
        {
            self.player.pause()
            btnplay.isHidden=false
        }
        else
        {
            self.player.play()
            btnplay.isHidden=true
        }
    }



    //MARK: CreatingFrameImages
    func createImageFrames()
    {
        //creating assets
        let assetImgGenerate : AVAssetImageGenerator    = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter    = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore   = CMTime.zero;

        assetImgGenerate.appliesPreferredTrackTransform = true

        let thumbTime: CMTime = asset.duration
        let thumbtimeSeconds  = CMTimeGetSeconds(thumbTime)
        let maxLength         = "\(thumbtimeSeconds)" as NSString

        let thumbAvg  = thumbtimeSeconds/6
        var startTime = 1
        var startXPosition:CGFloat = 0.0

        //loop for 6 number of frames
        for _ in 0...5
        {
            let imageButton = UIButton()
            let xPositionForEach = CGFloat(self.imageFrameView.frame.width)/6
            imageButton.frame = CGRect(x: CGFloat(startXPosition), y: CGFloat(0), width: xPositionForEach, height: CGFloat(self.imageFrameView.frame.height))
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: Int32(maxLength.length))
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                imageButton.setImage(image, for: .normal)
            }
            catch
                _ as NSError
            {
                print("Image generation failed with error (error)")
            }

            startXPosition = startXPosition + xPositionForEach
            startTime = startTime + Int(thumbAvg)
            imageButton.isUserInteractionEnabled = false
            imageFrameView.addSubview(imageButton)
        }

    }

    //Create range slider
    func createrangSlider()
    {
        //Remove slider if already present
        let subViews = self.frameContainerView.subviews
        for subview in subViews{
            if subview.tag == 1000 {
                subview.removeFromSuperview()
            }
        }

        rangSlider = RangeSlider(frame: frameContainerView.bounds)
        frameContainerView.addSubview(rangSlider)
        rangSlider.tag = 1000
        rangSlider.lowerValue = 0.0
        //Range slider action
        rangSlider.addTarget(self, action: #selector(VideoTrim_ViewController.rangSliderValueChanged(_:)), for: .valueChanged)
        let time = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangSlider.trackHighlightTintColor = UIColor.clear
            self.rangSlider.curvaceousness = 1.0
        }
        //qwerrerqwrqwrerrrerqrwerrqwrrrwerqreqrwerqere c13
    }



    //MARK: rangSlider Delegate
    @objc func rangSliderValueChanged(_ rangSlider: RangeSlider) {
        //        self.player.pause()


        if(isSliderEnd == true)
        {   rangSlider.minimumValue = 0.0
            rangSlider.maximumValue = Double(thumbtimeSeconds)

            rangSlider.upperValue = Double(thumbtimeSeconds)
            rangSlider.lowerValue = 0.0
            isSliderEnd = !isSliderEnd
        }

        startTimestr = "\(rangSlider.lowerValue)"
        endTimestr   = "\(rangSlider.upperValue)"

        print(rangSlider.lowerLayerSelected)
        if(rangSlider.lowerLayerSelected)
        {
            self.seekVideo(toPos: CGFloat(rangSlider.lowerValue))
        }
        else
        {
            self.seekVideo(toPos: CGFloat(rangSlider.upperValue))
        }
        print(startTime)
    }
    //Seek video when slide
    func seekVideo(toPos pos: CGFloat) {
        self.videoPlaybackPosition = pos
        let time: CMTime = CMTimeMakeWithSeconds(Float64(self.videoPlaybackPosition), preferredTimescale: self.player.currentTime().timescale)
        self.player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)

        if(pos == CGFloat(thumbtimeSeconds))
        {
            self.player.pause()

        }
    }

    //Trim Video Function
    func trimVideo(sourceURL1: NSURL, startTime:Float, endTime:Float)
    {
        print("Video trimVideo")
        let manager = FileManager.default

        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {return}

        guard let mediaType = "mp4" as? String else {return}
        guard (sourceURL1 as? NSURL) != nil else {return}

        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String
        {
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("Video length: \(length) seconds")

            let start = startTime
            let end = endTime
            print(documentDirectory)
            let outputURL = tempURL_Video()//getURLPathFor(tool: "Trimmed")


            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4

            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)

            exportSession.timeRange = timeRange
            
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    //hideCustomLoading()

                    print("Video exported at \(outputURL)")
                    self.reduceVideoSizeffmpeg(videourl: outputURL!)

                case .failed:
                    print("Video failed \(exportSession.error)")
                    self.hideCustomLoading()
                case .cancelled:
                    print("Video cancelled \(String(describing: exportSession.error))")
                    self.hideCustomLoading()
                default: break
                }}}}

    //Save Video to Photos Library

    func reduceVideoSizeffmpeg(videourl:URL){
        print("Video reduceVideoSizeffmpeg")
        // -i /Users/cloudus/Downloads/IMG_1335.MOV -vf scale=iw/2:ih/2 -crf 28 /Users/cloudus/Downloads/IMG_out1.MOV
        //hideCustomLoading()
        let V_Size = resolutionForLocalVideo(url: videourl)
        if V_Size!.width>500{
            let iw = Int(V_Size!.width/2) % 2 == 0 ? Int(V_Size!.width/2) : Int(V_Size!.width/2)-1
            let ih = Int(V_Size!.height/2) % 2 == 0 ? Int(V_Size!.height/2) : Int(V_Size!.height/2)-1

            //start writing command
            let out_put_path = tempURL_Video()!.path

            let str_command = "-i \(videourl.absoluteString) -vf scale=\(iw):\(ih) \(out_put_path)"
            print("Video Command:\(str_command)")
            
            
            
            DispatchQueue.global(qos: .background).async(execute: {

                let result = MobileFFmpeg.execute(str_command)
                self.hideCustomLoading()
                DispatchQueue.main.async(execute: {
                    if result == RETURN_CODE_SUCCESS {
                        //
                       
                        self.delegate?.didgetTrimedvideoduet(url: URL(fileURLWithPath: out_put_path))
                        self.hideCustomLoading()
                        print("Trim Loader reduceVideoSizeffmpeg")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.hideCustomLoading()
                        print("Trim Loader Reduce failed reduceVideoSizeffmpeg")
                        print("Video Reduce failed.\n\(result.description)")
                    }
                })
            })
           // ti
        }else{
            delegate?.didgetTrimedvideoduet(url: videourl)
            hideCustomLoading()
            DispatchQueue.main.async {
                self.hideCustomLoading()
                print("Trim Loader  V_Size!.width>500 reduceVideoSizeffmpeg")
                self.navigationController?.popViewController(animated: true)
            }
            //// ///////////////////////////////////////////////////////
//            self.Save_Video_ToLibrary(videourl)
        }
    }
    func goToRecord(videourl:URL){
        hideCustomLoading()
        print("Trim Loader  goToRecord 0")
        DispatchQueue.main.async {
            self.hideCustomLoading()
            print("Trim Loader  goToRecord")
            self.delegate?.didgetTrimedvideoduet(url:videourl)
            self.hideCustomLoading()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func ResizeVideoffmpeg(videourl:URL){

        let vidRes = resolutionForLocalVideo(url: videourl)
        let out_put_path = tempURL_Video()!.path
        let ratio = DuetSize!.width/DuetSize!.height
        let duetwid:Int = 588 //Int(DuetSize!.width)
        let duetheight:Int = Int(588 / ratio) //Int(DuetSize!.height)
       

        let str_command =  "-i \(videourl.path) -filter:v scale=iw*min(\(duetwid)/iw\\,\(duetheight)/ih):ih*min(\(duetwid)/iw\\,\(duetheight)/ih),pad=\(duetwid):\(duetheight):(\(duetwid)-iw*min(\(duetwid)/iw\\,\(duetheight)/ih))/2:(\(duetheight)-ih*min(\(duetwid)/iw\\,\(duetheight)/ih))/2 \(out_put_path)"
        // let str_command = "-i \(videourl.absoluteString) -vf scale=\(duetwid):\(duetheight) \(out_put_path)"
        // let str_command
        print("Video Command:\(str_command)")
        hideCustomLoading()
        DispatchQueue.global(qos: .background).async(execute: {
            let result = MobileFFmpeg.execute(str_command)
            self.hideCustomLoading()
            print("Trim Loader  ResizeVideoffmpeg 0 ")
            DispatchQueue.main.async(execute: {
                if result == RETURN_CODE_SUCCESS {
                    self.hideCustomLoading()
                    self.delegate?.didgetTrimedvideoduet(url: URL(fileURLWithPath: out_put_path))

                    print("Trim Loader  ResizeVideoffmpeg")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("Trim Loader  Resize failed ResizeVideoffmpeg")
                    self.hideCustomLoading()
                    print("Video Resize failed.\n\(result.description)")
                }
            })
        })
        }
    
    func hideCustomLoading(){
        DispatchQueue.main.async(execute: {
            print("Hide Loading Called.")
            hud.hide(animated: true)
            print("Hide Loading Called. hiden")
        })
    }
}

//State preservation and restoration
extension VideoTrim_ViewController {

    // will be called during state preservation
    override func encodeRestorableState(with coder: NSCoder) {
        // encode the data you want to save during state preservation
        // coder.encode(self.username, forkey:"username")

        print("Trim Loader Video encodeRestorableState")
        super.encodeRestorableState(with: coder)
    }

    // will be called during state restoration
    override func decodeRestorableState(with coder: NSCoder) {
        // decode the data saved and load it during state restoration
        print("Video decodeRestorableState")

        super.decodeRestorableState(with: coder)
    }

    override func applicationFinishedRestoringState() {
        // update the UI here
        print("Update Triming UI Here")
        print("Video applicationFinishedRestoringState")
    }
}

extension AVPlayer{
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

