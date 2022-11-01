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
  
    func serviceResponseObject(method: HTTPMethod = .get, parameter:[String:Any]? = nil, serviceName: String, header: [String:String] = [ConstantStrings.projectid:ConstantStrings.ProjectId], onComplition : @escaping (JSON?, Error?) -> Void) {
        
        let url = "\(ServiceURL.baseURL)\(serviceName)"
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
    
    
    func returnError (message:String) -> NSError{
        let userInfo: [AnyHashable : Any] =
        [
            NSLocalizedDescriptionKey :  NSLocalizedString(message, value: message, comment: "")
        ]
        let error = NSError(domain: "feed call", code: 1010, userInfo: (userInfo as! [String : Any]))
        return error
    }
}


