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


func getDate(date:String) -> String{
    
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
    dateFormatter.dateFormat = "d MMM"
    let dateString11 = dateFormatter.string(from: msgDate!)
    
    let timeString = dateFormatter.string(from: msgDate!)
    let diff = today.interval(ofComponent: .day, fromDate: msgDate!)
    if diff == 0{
        return timeString
    }else if diff == 1 {
        return  "Yesterday"
//        return  timeString + " " + "Yesterday"
    }else if diff < 7 {
        let day = String(describing: (msgDate?.dayOfWeek()?.prefix(3) ?? ""))
//        print(day)
        return timeString  + " (" +  day + ")"
    }
    return timeString
}

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
    let dateString11 = dateFormatter.string(from: msgDate!)
    let timeString = dateFormatter.string(from: msgDate!)
    let diff = today.interval(ofComponent: .day, fromDate: msgDate!)
    if diff == 0{
        return timeStr
    }else if diff == 1 {
        return  timeStr
//        return  timeStr + " " + "Yesterday"
    }else if diff < 7{
        let day = String(describing: (msgDate?.dayOfWeek()?.prefix(3) ?? ""))
        
        print(day)
//        return timeStr  + " (" +  day + ")"
        return timeStr
    }
    //return strTime  + " " + dateString1
    return strTime
}


class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect = .zero){
        super.init(frame: frame)
        backgroundColor = AppColors.incomingMsgColor
        textColor = AppColors.primaryColor
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
func stopSound(){
    print("Stopped Sound")
    if let audioPlayer = audioPlayerSound, audioPlayer.isPlaying {
        audioPlayer.stop()
        
        print("Sound Stopped")
    }
    audioPlayerSound = nil
}

//Mesage Sound Play...
func playSound(sound:String, isRepeat:Bool) {
    if let audioPlayer = audioPlayerSound, audioPlayer.isPlaying { audioPlayer.stop() }
    guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav") else {
        print("Sound not found")
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

func currentDate()-> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    let createdAt = formatter.string(from: date)
    return createdAt
}


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


//Get the string of data and convert into the spesific format.
func getDates(date:String) -> String {
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
    dateFormatter.dateFormat = "MM/dd"
    
    let dateString11 = dateFormatter.string(from: msgDate!)
    let timeString = dateFormatter.string(from: msgDate!)
    let diff = today.interval(ofComponent: .day, fromDate: msgDate!)
   
    let day = String(describing: (msgDate?.dayOfWeek()?.prefix(3) ?? ""))
    
    return timeString  + " (" +  day + ")"
    return dateString1
}



//MARK: -- getAttributedString
func getAttributedString(arrayUnderlinecolor : [UIColor]?,arrayText:[String]?) -> NSMutableAttributedString {
    
    let finalAttributedString = NSMutableAttributedString()
    let font =  UIFont.font(.Poppins, type: .Regular, size: 15)
    for i in 0 ..< (arrayText?.count)! {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.underlineColor: arrayUnderlinecolor?[i] as Any
                          ,NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font! ] as [NSAttributedString.Key : Any]
        
        let attributedStr = (NSAttributedString.init(string: arrayText?[i] ?? "", attributes: attributes as [NSAttributedString.Key : Any]))
        
        if i != 0 {
            
            finalAttributedString.append(NSAttributedString.init(string: " "))
        }
        
        finalAttributedString.append(attributedStr)
    }
    
    return finalAttributedString
}



func createImage(txt:String,img:UIImage,size:CGFloat)->UIImage {
    
    let myView = UIView(frame: CGRect(x: 0, y: 0, width: size - 25, height: size - 5))
    myView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    let myImgView = UIImageView(frame: CGRect(x: 0, y: 15, width: myView.frame.width, height: myView.frame.height/2.5))
    myImgView.contentMode = .scaleAspectFit
    myImgView.image = img
    myImgView.backgroundColor = .clear
    let myText = UILabel(frame: CGRect(x: 0, y: myView.bounds.height - 15, width: myView.bounds.size.width, height: 20))
    myText.textAlignment = .center
    myText.text = txt
    myText.font = UIFont.font(.Poppins, type: .Regular, size: 10)
    myText.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    myText.minimumScaleFactor = 0.1    //you need
    myText.adjustsFontSizeToFitWidth = true
    myText.lineBreakMode = .byClipping
    myText.numberOfLines = 0
    
    if txt.contains(find: "Read") || txt.contains(find: "Unread"){
        if appTheme == .white{
            //            myImgView.setImageColor(color: hexStringToUIColor("25A8E0"))
        }else{
            myImgView.setImageColor(color: appTheme.whiteColor)
        }
    }
    myView.addSubview(myImgView)
    myView.addSubview(myText)
    return myView.image()!
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
