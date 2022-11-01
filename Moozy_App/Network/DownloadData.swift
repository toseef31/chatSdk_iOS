//
//  DownloadData.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 20/06/2022.
//

import Foundation
import UIKit
import Photos
import CommonCrypto

class DownloadData: NSObject {
    
    var urls = "https://chat.chatto.jp:20000/meetingchat/"
    var downloaddoc = "https://chat.chatto.jp:21000/download/"
 
    static let sharedInstance = DownloadData()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    func downloadaudio(isSent:Bool, name:String,senderId:String, completion: @escaping ((Bool?) -> Void)){
        print(name)
        var url:URL?
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        var newUrl:URL?
        do{
            var  newName = name.replacingOccurrences(of: " ", with: "%20")

             url =  URL(string: "\(downloaddoc)\(newName)")
                newUrl = documentsUrl.appendingPathComponent("Audios")

            try FileManager.default.createDirectory(atPath: newUrl!.path, withIntermediateDirectories: true, attributes: nil)
            let destinationFileUrl = newUrl?.appendingPathComponent(name)
            let fileURL = url
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                  var data = Data()
                var decAudio = Data()
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        do{
                        data = try Data(contentsOf: tempLocalUrl)
                            //New Added
                            let key = senderId // length == 32
                            let test = ""
                            var  ivStr = key ?? "" + test
                            let halfLength = 16 //receiverId.count / 2
                            let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
                            ivStr.insert("-", at: index)
                            let result = ivStr.split(separator: "-")
                            let iv = String(result[0])
                            //New Added
                            decAudio = try data.aesDecryptData(key: key, iv: iv) as! Data
                            let fileSize = Double(decAudio.count / 1048576)
                            print("Audio File size1 in MB Audio Decrypt: ", fileSize , decAudio.count)
                            try decAudio.write(to: destinationFileUrl!)

                        }catch(let error as Error){
                            print(error.localizedDescription)
                        }
                        completion(true)
                        DispatchQueue.main.async {
                           // self.viewController?.view.makeToast("Image Downloaded")
                        }
                    }
                    do {
                        //try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)

                    }catch (let writeError) {
                        print("Error1\(String(describing: destinationFileUrl)) : \(writeError)")
                        DispatchQueue.main.async {
//                            self.viewController?.view.makeToast("Files already exist")
                            completion(false)
                        }
                    }
                    //
                } else {
                    print("Error description: \(error?.localizedDescription ?? "")")
                }
            }
        task.resume()
           // }
        }catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
    }
    
   
    func download(isImage:Bool,isVideo:Bool,isSent:Bool, name:String,senderId:String?, completion : @escaping ((String? ,Bool?) -> Void)){
        var url:URL?
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        var newUrl:URL?
        do{
            if isImage || isVideo{
                url = URL( string:"\(urls)\(name.replacingOccurrences(of: " ", with: "%20"))")
                //                if url != nil{
                if isImage{
                    DownloadData.sharedInstance.downloadImg(url: url!, senderId: senderId ?? "")
                    newUrl = documentsUrl.appendingPathComponent("Images")
                }else{
                    self.saveToAlbum(named: "Moozy Videos", image: nil, isImage: false, url: url!, videoName: name)
                    newUrl = documentsUrl.appendingPathComponent("Videos")
                }
            }else{
                let  newName = name.replacingOccurrences(of: " ", with: "%20")
                let downloaddocs = "https://chat.chatto.jp:20000/meetingchat/"
                url =  URL(string: "\(downloaddocs)\(newName)")
                newUrl = documentsUrl.appendingPathComponent("Document")
            }
            try FileManager.default.createDirectory(atPath: newUrl!.path, withIntermediateDirectories: true, attributes: nil)

            var data = Data()
            var decDoc = Data()
            let nam = String(name.dropFirst(37) )
            let destinationFileUrl = newUrl?.appendingPathComponent(nam)
           
            
            print("ImageSend file name in" , name)
           //print("ImageSend file name url" , destinationFileUrl)
            let fileURL = url
            print(url)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        do{
                        data = try Data(contentsOf: tempLocalUrl)
                            if isVideo{
                                try data.write(to: destinationFileUrl!)
                            }else{
                                //New Added
                                let key = senderId // length == 32
                                let test = ""
                                var  ivStr = key ?? "" + test
                                let halfLength = 16 //receiverId.count / 2
                                let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
                                ivStr.insert("-", at: index)
                                let result = ivStr.split(separator: "-")
                                let iv = String(result[0])
                                decDoc = try data.aesDecryptData(key: key ?? "xc", iv: iv) as! Data
                                let fileSize = Double(decDoc.count / 1048576)
                                print("ImageSend File size1 in MB decDoc Decrypt: ", fileSize , decDoc.count)
                                try decDoc.write(to: destinationFileUrl!)

                                print(destinationFileUrl)
                            }
                            
                            
                        }catch(let error as Error){
                            print(error.localizedDescription)
                            print("error")
                        }
                        DispatchQueue.main.async {
                            completion("Downloaded",true)
                        }
                    }
                    do {
                        //try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                        print(destinationFileUrl)
              
                    }catch (let writeError) {
                        print("Error1\(String(describing: destinationFileUrl)) : \(writeError)")
                        completion("Files already exist",true)
                    }
                    //
                }else{
                    completion((error?.localizedDescription ?? ""),true)
                    print("Error description: \(error?.localizedDescription ?? "")")
                }
            }
        task.resume()
           // }
        }catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            completion((error.localizedDescription ),true)
        }
    }
    
    func downloadImg(url:URL,senderId:String) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                    print(error?.localizedDescription)
                    
                    return }
                
                //New Added
                let key = senderId // length == 32
                //let test = ""
                var  ivStr = key
                let halfLength = 16 //receiverId.count / 2
                let index = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
                ivStr.insert("-", at: index)
                let result = ivStr.split(separator: "-")
                let iv = String(result[0])
                //New Added
                var encImage = UIImage()
                self.utilityQueue.async {
                do{
                        encImage = try data.aesDecrypt(key: key, iv: iv)
                }catch( let error as Error ){
                    print(error.localizedDescription)
                    
                }
               // }
                encImage.imageAsset?.accessibilityLabel = "Ringy"
                    self.saveToAlbum(named: "Ringy Images", image: encImage, isImage: true, url:url, videoName: "")
             }
            }.resume()
            
        }
    // MARK: Save To Album
    func saveToAlbum(named: String, image: UIImage? , isImage:Bool, url:URL,videoName:String) {
        if isImage{
            let album = CustomAlbum(name: named)
            album.save(image: image!) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Completed")
                    case .failure( _):
                        print("Faild error")
                        break
                    }
                }
            }
        }else{
            let album = CustomAlbum(name: named)
            album.saveVideo(videoUrl:  url, videoName: videoName) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                         }
                        break
                    case .failure( _):
                        print("Saved")
                        break
                    }
                }
            }
        }
    }
    
    // MARK: Load Images
     func loadImage(fileName: String) -> UIImage? {
    
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let newUrl = documentsUrl.appendingPathComponent("Images")
        let fileURL = newUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            let image = UIImage(data: imageData)
            return image
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    // MARK: Check File Exist
    func searchFileExist(fileName:String,fileType:Int) -> String?{
        var fileextension = ""
        if fileType == 5
        {
            fileextension = "Videos"
        }
        else if fileType == 6
        {
            fileextension = "Audios"
        }
        else if fileType == 2
        {
            fileextension = "Document"
        }
        print(fileName)
        let dataCompare = fileName.count > 38  ? String(fileName.dropFirst(37) ?? "") : fileName ?? ""
      
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
        let folderUrl = url.appendingPathComponent(fileextension)
        if let pathComponent = folderUrl?.appendingPathComponent(dataCompare) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                    return filePath
                } else {
                    print("FILE NOT AVAILABLE")
                }
            }else{
                print("FILE PATH NOT AVAILABLE")
            }
        return nil
    }
    
    // MARK: Thumbail of video
    func videoPreviewImage(url: URL,completion: (_ image:UIImage?) -> Void) {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 2, preferredTimescale: 60), actualTime: nil) {
            //return UIImage(cgImage: cgImage)
            completion(UIImage(cgImage: cgImage))
        }else{
            completion(nil)
        }
    }
}
