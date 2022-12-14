//
//  commons.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 08/05/2022.
//

import Foundation
import UIKit
import AVKit
import AVFAudio
import AVFoundation


func getMsgDate(date:String) -> String {
    let today = Date()
    let finalDate = date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MMM d, yyyy h:mm a")
    
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "dd-MMM"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
    let msgDate = dateFormatter.date(from: finalDate)
    dateFormatter.dateFormat = "M/d/yy"
    let dateString1 = dateFormatter.string(from: msgDate!)
    dateFormatter.dateFormat = "HH:mm"
    let strTime = dateFormatter.string(from: msgDate!)
    let timeStr = dateFormatter.string(from: msgDate!)
    dateFormatter.dateFormat = "MM/dd"
    _ = dateFormatter.string(from: msgDate!)
    _ = dateFormatter.string(from: msgDate!)
    let diff = today.interval(ofComponent: .day, fromDate: msgDate!)
    if diff == 0{
        return timeStr
    }else if diff == 1 {
        return  timeStr
    }else if diff < 7{
        let day = String(describing: (msgDate?.dayOfWeek()?.prefix(3) ?? ""))
        return timeStr
    }
    return strTime
}

//In Chat The section Used To Display Date Details.
class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect = .zero){
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false // enables auto layout
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Globel Initialized
var audioPlayerSound: AVAudioPlayer?
//Mesage Send OR Recive Sound Stop...
func stopSound(){
    if let audioPlayer = audioPlayerSound, audioPlayer.isPlaying {
        audioPlayer.stop()
       }
    audioPlayerSound = nil
}

//Mesage Send OR Recive Sound Play...
func playSound(sound:String, isRepeat:Bool) {
    if let audioPlayer = audioPlayerSound, audioPlayer.isPlaying { audioPlayer.stop() }
    guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav") else {
        return
    }
    do{
        audioPlayerSound = try AVAudioPlayer(contentsOf: soundURL)
        audioPlayerSound?.enableRate = true
        if isRepeat{
            audioPlayerSound?.numberOfLoops = 10
        }else{
            audioPlayerSound?.numberOfLoops = 0
        }
        audioPlayerSound?.prepareToPlay()
        audioPlayerSound?.play()
        
        print("Sound played")
    }catch let error {
        print("Sound error", error.localizedDescription)
    }
}


//Get the Audio Length Time.
func checkaudiotime(audiourl:URL) -> (audioduration:Float?, audiotimelabel:String?) {
    var audioPLayers = AVAudioPlayer()
    do {
        let audiourl = audiourl
        audioPLayers = try AVAudioPlayer(contentsOf: audiourl)
        let audiodurations = Float((audioPLayers.duration))
        let currentTime1 = Int((audioPLayers.duration))
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        let audiotimestrings = NSString(format: "%02d:%02d", minutes,seconds) as String
        return(audiodurations,audiotimestrings)
    } catch _ as NSError {
        audioPLayers = AVAudioPlayer()
    }
    return(nil,nil)
}
func createImage(txt:String,img:UIImage,size:CGFloat,isRound:Bool,corners: String)->UIImage {
//    let myView = UIView(frame: CGRect(x: 0, y: 0, width: size - 25, height: size - 5))
    let myVieww = UIView(frame: CGRect(x: -50, y: 0, width: size , height: size + 30))
    myVieww.backgroundColor = .white
    let myView = UIView(frame: CGRect(x: 0, y: 0, width: size , height: size + 30))
    myView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) //#colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.937254902, alpha: 1)
    
    if isRound == true {
        
        if corners == "Left" {
           // myView.roundCorners(corners: [.topLeft,.bottomLeft] , radius: 20, borderColor: .black, borderWidth: 2, clipToBonds: true)
                myView.roundCorners(corners: [.topLeft,.bottomLeft], radius: 20)
        } else {
            myView.roundCorners(corners: [.topRight,.bottomRight], radius: 20)
        }
      
    }
    else {
        myView.roundCorners(corners: .allCorners, radius: 0)
        }
    var Xaxix = 3
    if txt == "Delete" {
        Xaxix = -5
    }
  
    let myImgView = UIImageView(frame: CGRect(x: CGFloat(Xaxix), y: 20, width: myView.frame.width, height: myView.frame.height/4))
    myImgView.contentMode = .scaleAspectFit
    myImgView.image = img
    myImgView.backgroundColor = .clear
    let myText = UILabel(frame: CGRect(x: CGFloat(Xaxix), y: myView.bounds.height - 40, width: myView.bounds.size.width, height: 20))
    myText.textAlignment = .center
    myText.text = txt
    myText.font = UIFont.font(.Roboto, type: .Medium, size: 12)
    myText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    myText.minimumScaleFactor = 0.1    //you need
    myText.adjustsFontSizeToFitWidth = true
    myText.lineBreakMode = .byClipping
    myText.numberOfLines = 0
    
    if txt.contains(find: "Read") || txt.contains(find: "Unread"){
       
            myImgView.setImageColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
    }
    myView.addSubview(myImgView)
    myView.addSubview(myText)
    myVieww.addSubview(myView)
    myView.fillSuperView()
    return myVieww.image()!
}

extension UIView{
    func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
