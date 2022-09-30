//
//  callView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 28/04/2022.
//

import Foundation
import UIKit


class CallView: UIView{
    
    var img: UIImage?
    var title: String?
    var forgroundColor: UIColor?
    var fontColor: UIColor?
    var font: UIFont?
    var BGColor: UIColor?
    var imageSize: CGSize
    var action: onClick
    
    init(img: UIImage, title: String? = "", font: UIFont = UIFont.systemFont(ofSize: 12), fontColor: UIColor = .black, BGColor: UIColor = .clear, forgroundColor: UIColor? = .clear, imageSize: CGSize, frame: CGRect = .zero, action: @escaping onClick) {
        
        self.img = img
        self.title = title
        self.forgroundColor = forgroundColor
        self.fontColor = fontColor
        self.font = font
        self.BGColor = BGColor
        self.imageSize = imageSize
        self.action = action
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        
        backgroundColor = UIColor.clear
        
        let view = UIView(backgroundColor: BGColor!, cornerRadius: imageSize.height / 2, maskToBounds: true)
       
        let image = UIImageView(image: img!, contentModel: .scaleAspectFit)
        let lblTitle = UILabel(title: title!, fontColor: fontColor!, alignment: .center, font: font!)
        
        image.setImageColor(color: forgroundColor!)
        
        addMultipleSubViews(views: view, lblTitle)
        view.addSubview(image)
        
        view.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0), size: imageSize)
        view.horizontalCenterWith(withView: self)
        
        image.centerSuperView(size: .init(width: imageSize.width - 20, height: imageSize.width - 20))
        
        lblTitle.anchor(top: view.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        lblTitle.horizontalCenterWith(withView: view)
        
//        view.layer.cornerRadius = imageSize.height / 2
        
        self.addTapGesture(tagId: 0) { _ in
            self.action()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
