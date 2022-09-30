//
//  moozyActionButton.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import Foundation
import UIKit



struct Shadow {
    var offset: CGSize
    var opacity: Float
    var radius: CGFloat
    var color: UIColor
}

class MoozyActionButton: UIButton{
    
    var title: String
    var image: UIImage?
    var titleFont: UIFont
    var foregroundColor: UIColor
    var cornerRadius: CGFloat
    var borderColor: UIColor
    var borderWidth: CGFloat
    var imageSize: CGSize
    var isSkew: Bool
    var shadow: Shadow?
    var action: onClick
    
    var tint : UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet{
            tintColor = tint
        }
    }
    
    var ForegroundColor : UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet{
            setTitleColor(self.ForegroundColor, for: .normal) //set font color
        }
    }
    
    init(title: String = "", image: UIImage? = nil, font: UIFont = .systemFont(ofSize: 14), foregroundColor: UIColor = .black, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0.0, borderColor: UIColor = .clear, borderWidth: CGFloat = 0.0, isSkew: Bool = false, shadow: Shadow? = nil, imageSize: CGSize = .init(width: 16, height: 16), frame: CGRect = .zero, action: @escaping onClick) {
        self.title = title
        self.image = image
        self.titleFont = font
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.isSkew = isSkew
        self.shadow = shadow
        self.action = action
        self.imageSize = imageSize
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        setTitle(self.title, for: .normal) //set title
        titleLabel?.font = titleFont //set font
        setTitleColor(self.foregroundColor, for: .normal) //set font color
        
        if image != nil{
            let img = image!.withRenderingMode(.alwaysTemplate)
            self.setImage(img, for: .normal)
            self.tintColor = foregroundColor
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.centerSuperView()
            self.imageView?.constraintsWidhHeight(size: imageSize)
        }
        
        clipsToBounds = true
        layer.cornerRadius = self.cornerRadius //corner Radius
        layer.borderColor = self.borderColor.cgColor //border Color
        layer.borderWidth = self.borderWidth //border Width
        
        if isSkew{
            self.transform = __CGAffineTransformMake(1, 0.0, -0.5, 1, 0, 0)
            self.titleLabel?.transform = __CGAffineTransformMake(1, 0.0, 0.5, 1, 0, 0)
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.fillSuperView()
        }
        
        addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside) //add selector
    }
    
    override func layoutSubviews() {
        if shadow != nil{
            let shapeLayer = CAShapeLayer()
            shapeLayer.shadowColor = shadow!.color.cgColor
            shapeLayer.shadowOffset = shadow!.offset
            shapeLayer.shadowOpacity = shadow!.opacity
            shapeLayer.shadowRadius = shadow!.radius
            layer.insertSublayer(shapeLayer, at: 0)
        }
        super.layoutSubviews()
    }
    
    @objc private func onTap(_ sender: UIButton){
        action()
    }
}
