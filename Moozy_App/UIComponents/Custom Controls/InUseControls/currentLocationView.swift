//
//  currentLocationView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 27/05/2022.
//

import Foundation
import UIKit

class CurrentLocationView: UIView{
    
    var imgLocation: UIImageView?
    var lblTitle: UILabel?
    var lblSubTitle: UILabel?
    
    var font: UIFont?
    
    init(font: UIFont = UIFont.font(.Poppins, type: .Regular, size: 12), frame: CGRect = .zero) {
        self.font = font
        
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        
        imgLocation = UIImageView(image: UIImage(named: "location-1")!, contentModel: .scaleAspectFill)
        lblTitle =  UILabel(title: "Send your current location", fontColor: .black, alignment: .left, font: font!)
        lblSubTitle = UILabel(title: "Accurate in 10 meters", fontColor: .black, alignment: .left, font: font!)
        
        let stack = UIStackView(views: [ lblTitle!, lblSubTitle!], axis: .vertical)
        
        addMultipleSubViews(views: imgLocation!, stack)
        
        imgLocation?.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        
        imgLocation?.verticalCenterWith(withView: self)
        
        stack.anchor(top: nil, leading: imgLocation?.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
        stack.verticalCenterWith(withView: imgLocation!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
