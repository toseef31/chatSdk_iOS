//
//  UIFont+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

//Mark: UIFont Extension
extension UIFont{
    public class func font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont! {
        let fontName = name.rawValue + "-" + type.rawValue
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        //That font doens't have that type, try .None
        let fontNameNone = name.rawValue
        if let font = UIFont(name: fontNameNone, size: size) {
            return font
        }
        
        //That font doens't have that type, try .Regular
        let fontNameRegular = name.rawValue + "-" + "Regular"
        if let font = UIFont(name: fontNameRegular, size: size) {
            return font
        }
        print("\(name.rawValue) \(type.rawValue)")
        return nil
    }
    
    //MARK: UIFonts
    public enum FontType: String {
        case Bold = "Bold"
        case Medium = "Medium"
        case Regular = "Regular"
        case SemiBold = "SemiBold"
        case Light = "Light"
       // case potta = "potta_one_regular.ttf"
        case none = ""
    }
    
    public enum FontName: String {
        case Poppins
        case Muli
        case PottaOne
        case Roboto
    }
}


