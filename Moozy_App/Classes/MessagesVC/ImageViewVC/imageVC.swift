//
//  imageVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 30/05/2022.
//

import Foundation
import UIKit

class ImageVC: UIViewController, playVideoDelegate{
    
    var collImages: UICollectionView?
    
    var imagesArr = [chatModel]()
    var initialScrollDone = false
    var index = Int()
    var playIndex:IndexPath? = IndexPath()
    
    
    init(data : [chatModel]? = nil, index: Int? = 0){
        imagesArr.removeAll()
        self.imagesArr = data ?? []
        self.index = index ?? 0
        super.init(nibName: nil, bundle: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.navigationController?.navigationBar.isHidden = true
        
        let swipeUpDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeUpDown.direction = .down
        self.collImages?.addGestureRecognizer(swipeUpDown)

        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        
        self.collImages?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialScrollDone = false
    }
    
    func initializedControls(){
        ConfigureCollectionView()
    }
    
    func configureUI(){
        initializedControls()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(collImages!)
        collImages?.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func ConfigureCollectionView(){
        collImages = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        collImages?.backgroundColor = .clear
        
        //---CollectionView setLayout
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collImages?.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionViewFlowLayout.minimumInteritemSpacing = 0
//        collectionViewFlowLayout.minimumLineSpacing = 10
        
        //-- Register Cell
        collImages?.register(ImageVideoCell.self, forCellWithReuseIdentifier: "cell")
        
        // CollectionView Delegates
        collImages?.delegate = self
        collImages?.dataSource = self

        collImages?.showsHorizontalScrollIndicator = false
        collImages?.isPagingEnabled = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.collImages {
            if self.initialScrollDone == false
            {
                self.initialScrollDone = true
                let lastIndex = IndexPath(item: self.index, section: 0)
                self.collImages?.isPagingEnabled = false
                self.collImages?.scrollToItem(at: lastIndex, at: .left, animated: false)
                self.collImages?.isPagingEnabled = true
            }
            self.collImages?.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    @objc func back(){
        imagesArr.removeAll()
        if playIndex != nil{
            let cell =  self.collImages?.cellForItem(at: playIndex!) as? ImageVideoCell
            cell?.stop()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func playVideo(indexPath: IndexPath) {
        let cell = self.collImages?.cellForItem(at: indexPath)
        if let cell = cell as? ImageVideoCell {
              //Video player
            let msg = imagesArr[indexPath.row].message
//            if  let url = URL(string: "\(ServiceURL.baseURL)\(msg)"){
//                let avPlayer = AVPlayer(url: url)
//                //cell.videoView?.player = avPlayer
//                //cell.videoView?.player?.play()
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        return CGSize(width: view.frame.width, height:view.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 64)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageVideoCell
        cell.indexPath = indexPath
        cell.videoView?.isHidden = true
        cell.delegate = self
//        cell.imageView?.image = UIImage(named: "profile1")
        cell.dataSet = imagesArr[indexPath.row]
        cell.closeVCBtn = {
            if self.playIndex != nil{
                let cell =  self.collImages?.cellForItem(at: self.playIndex!) as? ImageVideoCell
                cell?.stop()
            }
            self.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.collImages?.cellForItem(at: indexPath)
        if let comedyCell = cell as? ImageVideoCell{
            comedyCell.stop()
            print(indexPath)
            //comedyCell.videoView?.player?.play()
            // comedyCell.videoView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
