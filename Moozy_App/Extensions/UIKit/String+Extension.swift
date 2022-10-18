//
//  String+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 26/04/2022.
//

import Foundation
import CommonCrypto
import CryptoSwift

extension String{
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var removeWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func checkNameLetter()->String{
        var finalName = ""
        let namesArray = self.split(separator: " ")
        if namesArray.count > 1{
            let firstName = namesArray.first?.description.trimmingCharacters(in: .whitespaces).capitalizingFirstLetter()
            let lastName = namesArray.last?.description.trimmingCharacters(in: .whitespaces).capitalizingFirstLetter()
            if firstName != ""{
                finalName = finalName + firstName!.first!.description.capitalizingFirstLetter().capitalized
            }
            if lastName != ""{
                finalName = finalName + lastName!.first!.description.capitalizingFirstLetter().capitalized
            }
        }else{
            finalName = self.trimmingCharacters(in: .whitespaces).first?.description.capitalizingFirstLetter() ?? "H"
        }
        return finalName
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            if trimmed.isEmpty{
                return false
            }else{
                return true
            }
        }
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
    
    public func isPhone()->Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "[6789][0-9]{6}([0-9]{3})?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    //    func getActualDate() -> String {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    //        let date = dateFormatter.date(from: self)
    //        if let date = date {
    //            return date.getFormattedDate(format: "yyyy-MM-dd")
    //        }else {
    //            return self
    //        }
    //    }
    
    
    func getActualDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        if let date = date {
                let day = String(describing: (date.dayOfWeek()?.prefix(3) ?? ""))
                //"MM/dd"
                return date.getFormattedDateS(format: "MM/dd", day: day)
          //  }
        }else {
            return self
        }
    }
    
    func getExtractedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        if let date = date {
            return date.getFormattedDate(format: "dd/MM (EE)")
        }else {
            return self
        }
    }
    
}



extension String{
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: String.Encoding.utf8)
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data?.bytes)!)
        let encData = Data(bytes: encrypted, count: encrypted.count)
        let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
        let result = String(base64str)
        return result
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)
        if data != nil{
            let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt(data!.bytes)
            let decryptedData = Data(decrypted)
            
            return String(bytes: decryptedData.bytes, encoding: .utf8) ?? self
        }else{
            return  self
        }
    }
}


