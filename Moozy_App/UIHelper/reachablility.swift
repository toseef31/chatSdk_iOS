//
//  reachablility.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation

public class Reachability {
    
    class func isConnectedToNetwork(onCompletion: @escaping (Bool) -> Void) {
        var Status:Bool = false
        let url = URL(string: "http://google.com/")
        var request = URLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        let session = URLSession.shared

        session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    Status = true
                    onCompletion(Status)
                }else{
                    onCompletion(Status)
                }
            }else{
                onCompletion(Status)
            }
        }).resume()
    }
}
