//
//  themeManager.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 13/05/2022.
//

import Foundation
import UIKit

var appTheme = ThemeManager.currentTheme()

enum Themes {
    case app_theme
    case Blue
    case Pink
    case Green
    case Orange
    case Yellow
    case Purple
    case Red
    case Gray
    case LightYellow
    case Brown
    case White
}

enum Theme: Int {

    case blue, pink, green, orange, yellow, purple, red, gray,white
    
    var primaryColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("25A8E0")
        case .pink:
            return hexStringToUIColor("EBA7A7")
        case .green:
            return hexStringToUIColor("#1DB479")
        case .orange:
            return hexStringToUIColor("#F4945A")
        case .yellow:
            return hexStringToUIColor("#FBCF06")
        case .purple:
            return hexStringToUIColor("#C599FF")
        case .red:
            return hexStringToUIColor("#E23348")
        case .gray:
            return hexStringToUIColor("#FFFFFF")
        case .white:
        return hexStringToUIColor("#F8FAFF")
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("FFFFFF")
        case .pink:
            return hexStringToUIColor("FFFFFF")
        case .green:
            return hexStringToUIColor("#FFFFFF")
        case .orange:
            return hexStringToUIColor("#FFFFFF")
        case .yellow:
            return hexStringToUIColor("#000000")
        case .purple:
            return hexStringToUIColor("#FFFFFF")
        case .red:
            return hexStringToUIColor("#FFFFFF")
        case .gray:
            return hexStringToUIColor("#FFFFFF")
        case .white:
        return hexStringToUIColor("#25A8E0")
        }
    }
    
    var primaryTextColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#FFFFFF")
        case .pink:
            return hexStringToUIColor("#FFFFFF")
        case .green:
            return hexStringToUIColor("FFFFFF")
        case .orange:
            return hexStringToUIColor("#FFFFFF")
        case .yellow:
            return hexStringToUIColor("#FFFFFF")
        case .purple:
            return hexStringToUIColor("#FFFFFF")
        case .red:
            return hexStringToUIColor("#FFFFFF")
        case .gray:
            return hexStringToUIColor("#FFFFFF")
        case .white:
           return hexStringToUIColor("#000000")
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#000000")
        case .pink:
            return hexStringToUIColor("#000000")
        case .green:
            return hexStringToUIColor("#000000")
        case .orange:
            return hexStringToUIColor("#000000")
        case .yellow:
            return hexStringToUIColor("#000000")
        case .purple:
            return hexStringToUIColor("#000000")
        case .red:
            return hexStringToUIColor("#000000")
        case .gray:
            return hexStringToUIColor("#000000")
        case .white:
            return hexStringToUIColor("#000000")
        }
    }

    var msgSendColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#98A7E6")
        case .pink:
            return hexStringToUIColor("#EBA7A7")
        case .green:
            return hexStringToUIColor("1DB479")
        case .orange:
            return hexStringToUIColor("#B89B83")
        case .yellow:
            return hexStringToUIColor("#AAAAAF")
        case .purple:
            return hexStringToUIColor("#54C9E2")
        case .red:
            return hexStringToUIColor("#A8A8A8")
        case .gray:
            return hexStringToUIColor("#727273")
        case .white:
            return hexStringToUIColor("#353738")
        }
    }
    
    var msgReceiveColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#98A7E6")
        case .pink:
            return hexStringToUIColor("#EBA7A7")
        case .green:
            return hexStringToUIColor("1DB479")
        case .orange:
            return hexStringToUIColor("#B89B83")
        case .yellow:
            return hexStringToUIColor("#AAAAAF")
        case .purple:
            return hexStringToUIColor("#54C9E2")
        case .red:
            return hexStringToUIColor("#A8A8A8")
        case .gray:
            return hexStringToUIColor("#727273")
        case .white:
            return hexStringToUIColor("#353738")
        }
    }
    
    var statusTickColor: UIColor {
        switch self {
        case .white:
            return appTheme.btnAddColor
        default:
            return appTheme.primaryColor
         
        }
    }
    
    var btnSendColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#5061AC")
        case .pink:
            return hexStringToUIColor("#979FC2")
        case .green:
            return hexStringToUIColor("#626EB1")
        case .orange:
            return hexStringToUIColor("#B89B83")
        case .yellow:
            return hexStringToUIColor("#7B7D8F")
        case .purple:
            return hexStringToUIColor("#54C9E2")
        case .red:
            return hexStringToUIColor("#A8A8A8")
        case .gray:
            return hexStringToUIColor("#727273")
        case .white:
            return hexStringToUIColor("#5061AC")
        }
    }
    
    var btnAddColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#5061AC")
        case .pink:
            return hexStringToUIColor("#384B9E")
        case .green:
            return hexStringToUIColor("101D62")
        case .orange:
            return hexStringToUIColor("#181819")
        case .yellow:
            return hexStringToUIColor("#050506")
        case .purple:
            return hexStringToUIColor("#54C9E2")
        case .red:
            return hexStringToUIColor("#353738")
        case .gray:
            return hexStringToUIColor("#353738")
        case .white:
            return hexStringToUIColor("#5061AC")
        }
    }
    
    var gradientColor: [Any] {
        switch self {
        case .blue:
            return [hexStringToUIColor("#25A8E0").cgColor, hexStringToUIColor("#92D4F0").cgColor]
        case .pink:
            return [hexStringToUIColor("#EBA7A7").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .green:
            return [hexStringToUIColor("#1DB479").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .orange:
            return [hexStringToUIColor("#F4945A").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .yellow:
            return [hexStringToUIColor("#FBCF06").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .purple:
            return [hexStringToUIColor("#C599FF").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .red:
            return [hexStringToUIColor("#E23348").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .gray:
            return [hexStringToUIColor("#FFFFFF").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        case .white:
            return [hexStringToUIColor("#F8FAFF").cgColor, hexStringToUIColor("#80FFFFFF").cgColor]
        }
    }
    
    
    var whiteColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#E5EAF6")
        case .pink:
            return hexStringToUIColor("#FFF1F1")
        case .green:
            return hexStringToUIColor("DEF3EB")
        case .orange:
            return hexStringToUIColor("#F0E9E3")
        case .yellow:
            return hexStringToUIColor("#FFF9D9")
        case .purple:
            return hexStringToUIColor("#F5EDFF")
        case .red:
            return hexStringToUIColor("#FFEDEF")
        case .gray:
            return hexStringToUIColor("#F0F0F0")
        case .white:
            return hexStringToUIColor("#E5EAF6")
        }
    }
    
    
    var blackColor: UIColor {
        switch self {
        case .blue:
            return hexStringToUIColor("#353738")
        case .pink:
            return hexStringToUIColor("#353738")
        case .green:
            return hexStringToUIColor("#353738")
        case .orange:
            return hexStringToUIColor("#353738")
        case .yellow:
            return hexStringToUIColor("#353738")
        case .purple:
            return hexStringToUIColor("#353738")
        case .red:
            return hexStringToUIColor("#353738")
        case .gray:
            return hexStringToUIColor("#353738")
        case .white:
            return hexStringToUIColor("#353738")
        }
    }
    
    
    var MsgPlaceHoldercolor: UIColor {
        switch self {
        case .white:
            return hexStringToUIColor("25A8E0")
        default :
            return appTheme.primaryColor
        }
    }
}






class ThemeManager {
    
    static func currentTheme() -> Theme {
        let storedTheme = UserDefaults.standard.value(forKey: ThemeConstant.app_theme) as? String
        
        if storedTheme == ThemeConstant.Blue{
            return .blue
        }else if storedTheme == ThemeConstant.Pink{
            return .pink
        }else if storedTheme == ThemeConstant.Green{
            return .green
        }else if storedTheme == ThemeConstant.Orange{
            return .orange
        }else if storedTheme == ThemeConstant.Yellow{
            return .yellow
        }else if storedTheme == ThemeConstant.Purple{
            return .purple
        }else if storedTheme == ThemeConstant.Red{
            return .red
        }else if storedTheme == ThemeConstant.Gray{
            return .gray
        }else{
            return .white
        }
    }

    static func currentThemeName() -> String {
        let storedTheme = UserDefaults.standard.value(forKey: ThemeConstant.app_theme) as? String
        
        if storedTheme == ThemeConstant.Blue{
            return ThemeConstant.Blue
        }else if storedTheme == ThemeConstant.Pink{
            return ThemeConstant.Pink
        }else if storedTheme == ThemeConstant.Green{
            return ThemeConstant.Green
        }else if storedTheme == ThemeConstant.Orange{
            return ThemeConstant.Orange
        }else if storedTheme == ThemeConstant.Yellow{
            return ThemeConstant.Yellow
        }else if storedTheme == ThemeConstant.Purple{
            return ThemeConstant.Purple
        }else if storedTheme == ThemeConstant.Red{
            return ThemeConstant.Red
        }else if storedTheme == ThemeConstant.Gray{
            return ThemeConstant.Gray
        }else{
            return ThemeConstant.White
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        if theme == .blue{
            UserDefaults.standard.setValue(ThemeConstant.Blue, forKey: ThemeConstant.app_theme)
        }else if theme == .pink{
            UserDefaults.standard.setValue(ThemeConstant.Pink, forKey: ThemeConstant.app_theme)
        }else if theme == .green{
            UserDefaults.standard.setValue(ThemeConstant.Green, forKey: ThemeConstant.app_theme)
        }else if theme == .orange{
            UserDefaults.standard.setValue(ThemeConstant.Orange, forKey: ThemeConstant.app_theme)
        }else if theme == .yellow{
            UserDefaults.standard.setValue(ThemeConstant.Yellow, forKey: ThemeConstant.app_theme)
        }else if theme == .purple{
            UserDefaults.standard.setValue(ThemeConstant.Purple, forKey: ThemeConstant.app_theme)
        }else if theme == .red{
            UserDefaults.standard.setValue(ThemeConstant.Red, forKey: ThemeConstant.app_theme)
        }else if theme == .gray{
            UserDefaults.standard.setValue(ThemeConstant.Gray, forKey: ThemeConstant.app_theme)
        }else if theme == .yellow{
            UserDefaults.standard.setValue(ThemeConstant.Yellow, forKey: ThemeConstant.app_theme)
        }else{
            UserDefaults.standard.setValue(ThemeConstant.White, forKey: ThemeConstant.app_theme)
        }
        UserDefaults.standard.synchronize()
    }
}

