//
//  UIButton+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

extension UIButton{
    convenience init(
        title: String = "",
        image: UIImage? = nil,
        target: Any,
        action: Selector,
        foregroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        font: UIFont = .systemFont(ofSize: 24, weight: .bold),
        backgroundColor: UIColor = UIColor.clear,
        borderColor: CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        borderRadius: CGFloat = 0.0,
        borderWidth: CGFloat = 0.0,
        isSkew: Bool = false,
        isShadow: Bool = false
        ) {
        self.init(type: .system)
        self.setTitle(title, for: .normal) //Set Title
        
        if image != nil{
            
            let image = image?.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .normal)
            self.tintColor = foregroundColor
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.centerSuperView()
            self.imageView?.constraintsWidhHeight(size: .init(width: 20, height: 26))
        }
        
        self.addTarget(target, action: action, for: .touchUpInside) //Set Button Action
        self.setTitleColor(foregroundColor, for: .normal) //Set title Color
        self.titleLabel?.font = font //Set title Fonts
        
        self.layer.cornerRadius = borderRadius //Set Border Radius
        self.layer.borderColor = borderColor //Set Border Color
        self.layer.borderWidth = borderWidth //Set Border Width
        self.backgroundColor = backgroundColor //Set BackgroundColor
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        
        if isSkew{
            self.transform = __CGAffineTransformMake(1, 0.0, -0.5, 1, 0, 0)
            self.titleLabel?.transform = __CGAffineTransformMake(1, 0.0, 0.5, 1, 0, 0)
            self.titleLabel?.fillSuperView()
        }
        
    }
}




//MARK: - Hexa Color String
func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
