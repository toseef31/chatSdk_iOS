//
//  networkManager.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import SQLite3
import UIKit

class NetworkController{
    static let shared = NetworkController()
    
    let baseURL = "https://chat.chatto.jp:20000/"

    func serviceResponseObject(method: HTTPMethod = .get, parameter:[String:Any]? = nil, serviceName: String, header: [String:String] = ["projectid":"63183b5bb110c06cb4822451"], onComplition : @escaping (JSON?, Error?) -> Void) {
        
        let url = "\(baseURL)\(serviceName)"
        print(url)
        
        Alamofire.request(url, method: method, parameters: parameter, encoding: URLEncoding.httpBody, headers: header).responseJSON(){ response in
            
            switch response.result
            {
            case.success(let data):
                let resp = JSON(data)
                onComplition(resp, nil)
                break
            case.failure(let error):
                let failureError  = self.returnError(message: error.localizedDescription)
                onComplition(nil, failureError)
                break
            }
        }
    }
    
    //Upload Imageseee
    func uploadImage(image: UIImage, imageName: String, parameters:[String:String]? = nil, serviceName: String, header: [String:String] = [:], onCom : @escaping (JSON?, Progress?, Error?) -> Void){
        let url = "\(baseURL)\(serviceName)"
        let imgData = image.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset", fileName: imageName, mimeType: "image/jpg")
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to: url,  headers: header)
        { (result) in
            
            print(result)
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    onCom(nil, progress, nil)
                })
                
                upload.responseJSON { response in
                    print(response)
                    let resp = JSON(response.data)
                    if resp["success"] == true{
                        if resp["data"].exists(){
                            onCom(resp["data"], nil, nil)
                        }else{
                            onCom(["status": true], nil, nil)
                        }
                    }else{
                        let description = resp["message"].stringValue
                        let error  = self.returnError(message: description)
                        onCom(nil, nil, error)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func returnError (message:String) -> NSError{
        let userInfo: [AnyHashable : Any] =
        [
            NSLocalizedDescriptionKey :  NSLocalizedString(message, value: message, comment: "")
        ]
        let error = NSError(domain: "feed call", code: 1010, userInfo: (userInfo as! [String : Any]))
        return error
    }
}


