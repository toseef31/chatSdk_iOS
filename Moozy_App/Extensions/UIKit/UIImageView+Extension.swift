//
//  UIImageView+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import ImageIO
import CryptoSwift
import CommonCrypto

extension UIImageView{
    
    convenience init(image: UIImage, contentModel: UIView.ContentMode, cornerRadius: CGFloat = 0.0, borderColor: CGColor = UIColor.clear.cgColor, borderWidth: CGFloat = 0.0, backgroundColor: UIColor = .clear) {
        self.init(image: image)
        self.contentMode = contentModel
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIImage {
    
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace,
           let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)
            
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let ctxImage: CGImage = ctx.makeImage() {
                return UIImage(cgImage: ctxImage)
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func writeImageToPath(name:String) {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let folderURL = documentsUrl.appendingPathComponent("Images")
        let imageurl = folderURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: imageurl.path) {
            do{
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error Writing Image: \(error)")
            }
            print("File does NOT exist UIIMAge -- \(imageurl) -- is available for use")
            let data = self.pngData()
            do {
                print("ImageSend Write image")
                try data!.write(to: imageurl)
            }
            catch {
                print("Error Writing Image: \(error)")
            }
        }
        else {
            print("This file exists -- something is already placed at this location")
        }
        print("ImageSend Completed writeImageToPath")
    }
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}


extension UIImage{
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 0, height: size.height))//(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func checkimgsize()->UIImage {
        
        var imgData = NSData(data: self.jpegData(compressionQuality: 0.5)!)
        var imageSize: Int = imgData.count
        print(imageSize)
       // round(double)
        let ro = round(Double(imageSize))
        var sizeinkb = ro / 1000.0
        print(sizeinkb)
        if sizeinkb <= 1024 {
            var imgdata = self.jpeg(.medium)!
            var img = UIImage(data: imgdata)!
            imgdata = img.pngData()!
            img = UIImage(data: imgdata)!
            return img
        } else {
            return self
        }
        // print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
    }
    
    func setimgsize()->UIImage {
        var imgData = NSData(data: self.jpegData(compressionQuality: 0.5)!)
        var imageSize: Int = imgData.count
        var sizeinkb = Double(imageSize) / 1000.0
        if sizeinkb > 1024
        {
            var imgdata = self.jpeg(.highest)!
            var img = UIImage(data: imgdata)!
            imgdata = img.pngData()!
            img = UIImage(data: imgdata)!
            return img
        } else {
            return self
        }
        // print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func compressimage(_ jpegQuality: JPEGQuality) -> UIImage {
        
        var imgdata = jpegData(compressionQuality: jpegQuality.rawValue)
        return UIImage(data: imgdata!)!
        
    }
    
}

//Encryption && Decryption Image
extension UIImage{
    func aesEncrypt(key: String, iv: String) throws -> Data {
        let data = self.pngData()
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data?.bytes)!)
        let encData = Data(bytes: encrypted, count: encrypted.count)
        return encData
    }
    
    func aesDecrypt(key: String, iv: String) throws -> Data {
        //do{
        let data = self.pngData()
        if data != nil{
            let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt(data!.bytes)
        let decryptedData = Data(decrypted)
        return decryptedData
        }else{
            return  data! //self
        }
    }
    
    static func loadImageUsingCacheWithUrlString(_ urlString: String, completion: @escaping (UIImage) -> Void) {
        //        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
        //            completion(cachedImage)
        //        }
        //No cache, so create new one and set image
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    //imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    completion(downloadedImage)
                }
            })
            
        }).resume()
    }
}


