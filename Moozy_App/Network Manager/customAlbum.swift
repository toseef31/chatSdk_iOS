//
//  customAlbum.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 20/06/2022.
//


import Foundation

protocol OurErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: OurErrorProtocol {
    
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}


import UIKit
import Photos

struct CustomAlbumError {
    static let notAuthorized = CustomError(title: "Custom Album Error", description: "Not Authorized", code: 0)
}

class CustomAlbum: NSObject {
    var name = "Moozy Images"
    
    private var assetCollection: PHAssetCollection!
    
    init(name: String) {
        self.name = name
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    func checkAuthorizationWithHandler(completion: @escaping (Result<Bool, Error>) -> ()) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.checkAuthorizationWithHandler(completion: completion)
            })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { (success) in
                completion(success)
            }
        }
        else {
            completion(.failure(CustomAlbumError.notAuthorized))
        }
    }
    
    private func createAlbumIfNeeded(completion: @escaping (Result<Bool, Error>) -> ()) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            self.assetCollection = assetCollection
            completion(.success(true))
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.name)
                
                // create an asset collection with the album name
            }) { success, error in
                if let error = error {
                    completion(.failure(error))
                }
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(.success(true))
                } else {
                    // Unable to create album
                    completion(.success(false))
                }
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
               let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", name)
                let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let _: AnyObject = collection.firstObject {
                    return collection.firstObject
                }
                return nil
    }
    
    func save(image: UIImage, completion: @escaping (Result<Bool, Error>) -> ()) {
        self.checkAuthorizationWithHandler { (result) in
            switch result {
            case .success(let success):
                if success, self.assetCollection != nil {
                    PHPhotoLibrary.shared().performChanges({
                        
                        let data = image.pngData()
                        let request = PHAssetCreationRequest.forAsset()
                        if data == nil {
                            
                        }
                        else {
                            request.addResource(with: PHAssetResourceType.photo, data: data!, options: nil) }
                        request.creationDate = Date()
                       
                        let assetPlaceHolder1 = request.placeholderForCreatedAsset
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                            let enumeration: NSArray = [assetPlaceHolder1!]
                            albumChangeRequest.addAssets(enumeration)
                            //albumChangeRequest
                        }
                    
   
                    }, completionHandler: { (success, error) in
                        if let error = error {
                            print("Error writing to image library: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
                        }
                        completion(.success(success))
                    })
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    
    
    func saveVideo(videoUrl:URL ,videoName:String, completion: @escaping (Result<Bool, Error>) -> ()){
        //let videoImageUrl = videoUrl
        self.checkAuthorizationWithHandler { (result) in
            switch result {
            case .success(let success):
                
                if success, self.assetCollection != nil {
                    DispatchQueue.global(qos: .background).async {
                        let url = videoUrl
                        let urlData = NSData(contentsOf: url)
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                        let filePath = "\(documentsPath)/\(videoName)"
                            //videoUrl.absoluteString
                           print(filePath)
                        DispatchQueue.main.async {
                            urlData?.write(toFile: filePath, atomically: true)
                            PHPhotoLibrary.shared().performChanges({
                                    
                                    let assetChangeRequest = PHAssetChangeRequest
                                        .creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                                    let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset
                                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                                        let enumeration: NSArray = [assetPlaceHolder!]
                                        albumChangeRequest.addAssets(enumeration)
                                    }
                                }, completionHandler: { (success, error) in
                                    if let error = error {
                                        print("Error writing to image library: \(error.localizedDescription)")
                                        completion(.failure(error))
                                        return
                                    }
                                    completion(.success(success))
                                })
                            }
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    //
    
    func fetchCustomAlbumPhotos(albumName:String, name:String,  completion: @escaping (UIImage, Bool) -> ()){
        var assetCollection = PHAssetCollection()
        //var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        let image = UIImage()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
           // albumFound = true
        }
        else {/* albumFound = false*/ }
        let data1 = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        var totalImages = 0
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in

            totalImages += 1
            if object is PHAsset{
                let asset = object as! PHAsset
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)

                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                print("1101 \(asset.localIdentifier)      \(name)")
                if name == asset.originalFilename{
                    imageManager.requestImage(for: asset,targetSize: imageSize,
                                        contentMode: .aspectFill, options: options,
                                        resultHandler: {(image, info) -> Void in
                                                        completion(image!,true)
                                                        print(asset.originalFilename)

                    })
                }else{
                    if totalImages == photoAssets.count{
                        completion(image,false)
                        print(totalImages)
                        print(photoAssets.count)
                        print(data1)
                        print(assetCollection.estimatedAssetCount)
                    }
                }

            }
        }
        //completion(image,false)
    }
}

