//
//  imgPreview.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 27/06/2022.
//

import Foundation
import UIKit
import Kingfisher
import Imaginary
import CryptoSwift

class previewImageVC: UIViewController {
    
    var btnCancel: MoozyActionButton?
    var imgVedioView = UIImageView(image: UIImage(named: "placeholder")!, contentModel: .scaleAspectFit)
    var imageData = ""
    init(data : String? = "" ){
        self.imageData = data ?? ""
            print(data)
//        imgVedioView.image = data
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
        loadImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  initialScrollDone = false
    }
    func initilization(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        btnCancel = MoozyActionButton(image: UIImage(systemName: systemImage.close), foregroundColor: .white ,  backgroundColor: AppColors.primaryColor,imageSize: .init(width: 25, height: 25)) { [self] in
            self.pop(animated: true)
        }
    }
    func configureUI(){
        initilization()
       
        view.addMultipleSubViews(views: btnCancel!,imgVedioView )
        view.bringSubviewToFront(btnCancel!)
        imgVedioView.enableZoom()
        imgVedioView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
       // imgVedioView.fillSuperView(padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        btnCancel?.anchor(top: imgVedioView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 15, bottom: 0, right: 0),size: .init(width: 30, height: 30))
        
        }
    
    func loadImage(){
        let cellImage = AppUtils.shared.loadImage(fileName: imageData)
        
        if cellImage != nil{
            imgVedioView.image = cellImage
        }else{
            
            if  let url = URL(string: ""){
                KingfisherManager.shared.retrieveImage(with: url) {  result in
                    let image = try? result.get().image
                    if let image = image {
                        self.imgVedioView.image = image
                    }
                    else{
                        self.imgVedioView.image = nil
                    }
                }
            }
            
        }
    }
    
    @objc func back(){
       
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
