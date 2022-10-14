//
//  replyView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 19/05/2022.
//

import Foundation
import UIKit
import SwiftUI

class ReplyView: UIView{
    
    var BGColor: UIColor?
    var titleName: String?
    var message: String?
    var titleColor: UIColor?
    var messageColor: UIColor?
    var font: UIFont?
    var image: UIImage?
    
    var imageMsg: UIImageView?
    var lblUserName: UILabel?
    var lblMessage: UILabel?
    var btnClose: MoozyActionButton?
    var lineView: UIView?
    var action: onClick
    
    
    init(title: String? = "", message: String? = "", image: UIImage? = nil , titleColor: UIColor? = UIColor.black, messageColor: UIColor? = UIColor.black, BGColor: UIColor? = UIColor.white, font: UIFont = UIFont.font(.Poppins, type: .Regular, size: 12), frame: CGRect = .zero, action: @escaping onClick){
        
        self.titleName = title
        self.message = message
        self.titleColor = titleColor
        self.messageColor = messageColor
        self.BGColor = BGColor
        self.font = font
        self.image = image
        self.action = action
        super.init(frame: frame)
        configureUI()
    }
    
    func initializedControls(){
        self.backgroundColor = BGColor
        self.layer.cornerRadius = 0
        //FCAE00
        lineView = UIView(backgroundColor: AppColors.replyLineColor, cornerRadius: 0)
        
        if let image = image {
            imageMsg = UIImageView(image: image, contentModel: .scaleAspectFit)
            imageMsg?.constraintsWidhHeight(size: .init(width: 20, height: 20))
        }
        
        lblUserName = UILabel(title: titleName!, fontColor: titleColor!, alignment: .left, font: font!)
        
        lblMessage = UILabel(title: message!, fontColor: messageColor!, alignment: .left, font: font!)
        
        btnClose = MoozyActionButton(image: UIImage(named: "close-1"), foregroundColor: #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3764705882, alpha: 1), backgroundColor: UIColor.clear, imageSize: .init(width: 12, height: 12)){ [self] in
            NotificationCenter.default.post(name: .close, object: nil, userInfo: ["close": true])
            action()
        }
    }
    func configureUI(){
        initializedControls()
        addMultipleSubViews(views: lineView!, btnClose!)
        
        lineView?.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 3, height: 0))
        
        btnClose?.anchor(top:  self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 8), size: .init(width: 20, height: 20))
        //btnClose?.verticalCenterWith(withView: self)
        
        if image != nil{
            let stack1 = UIStackView(views: [imageMsg!, lblMessage!], axis: .horizontal, spacing: 8)
            let stack2 = UIStackView(views: [lblUserName!, stack1], axis: .vertical, spacing: 8)
            
            addSubview(stack2)
            stack2.anchor(top: nil, leading: lineView?.trailingAnchor, bottom: nil, trailing: btnClose?.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 8))
            stack2.verticalCenterWith(withView: self)
        }else{
            let stack1 = UIStackView(views: [lblMessage!], axis: .horizontal, spacing: 8)
            let stack2 = UIStackView(views: [lblUserName!, stack1], axis: .vertical, spacing: 3)
            
            addSubview(stack2)
            stack2.anchor(top: nil, leading: lineView?.trailingAnchor, bottom: nil, trailing: btnClose?.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 8))
            stack2.verticalCenterWith(withView: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
