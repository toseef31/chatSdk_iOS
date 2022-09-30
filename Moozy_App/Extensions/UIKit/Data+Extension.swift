//
//  Data+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 26/05/2022.
//

import Foundation
import CommonCrypto
import CryptoSwift


extension Data{
    
    func aesEncrypt(key: String, iv: String) throws -> Data {

        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((self.bytes))
        let encData = Data(bytes: encrypted, count: encrypted.count)
        return encData
    }
    
    func aesDecrypt(key: String, iv: String) throws -> UIImage {
        //do{
        let data = self
        let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt(data.bytes)
        
        let decryptedData = Data(decrypted)
        let image = UIImage(data: decryptedData)
        return image ?? UIImage(data: data) ?? UIImage(named: "Bitmap")!
    }
    
    func aesDecryptData(key: String, iv: String) throws -> Data {
        //do{
        let data = self
        if data != nil{
            print("ImageSend start File Encryption")
            //var decrypted = Array<UInt8>'
            do{
             let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt(data.bytes)

                let decryptedData = Data(decrypted)
                print("ImageSend start File Encryption Complete" , decryptedData)
                return decryptedData
            }catch(let error as Error){
                print(error.localizedDescription)
                return self
            }
        }
        return data
    }
}

extension Date {
    var milisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(miliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(miliseconds / 1000))
    }
}
