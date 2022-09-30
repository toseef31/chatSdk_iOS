//
//  moozyTextField.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import Foundation
import UIKit

struct RegexConstants {
    static let nameRegex = "^[\\p{L}'-][\\p{L}' -]{0,50}$"
    static let emailRegex = "^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$"
    static let passwordRegex =  "^.{6,}$"
    static let mobileNumberRegex = "^[0-9+]{0,1}+[0-9]{10,16}$"
    static let htmlRegex = "</?\\w+((\\s+\\w+(\\s*=\\s*(?:\".*?\"|'.*?'|[\\^'\">\\s]+))?)+\\s*|\\s*)/?>"
    static let generalRegex = "(.*?)"
}

enum TextInputType{
    case password
    case email
    case name
    case mobile
    case general
    
    func getRegex() -> String {
        switch self {
            
        case .email:
            return RegexConstants.emailRegex
        case .password:
            return RegexConstants.passwordRegex
        case .general:
            return RegexConstants.generalRegex
        case .name:
            return RegexConstants.nameRegex
        case .mobile:
            return RegexConstants.mobileNumberRegex
        }
    }
    
    func getErrorString() -> String {
        switch self {
            
        case .password:
            return ConstantStrings.ErrorString.passwordError
        case .email:
            return ConstantStrings.ErrorString.emailError
        case .general:
            return ConstantStrings.ErrorString.general
        case .name:
            return ConstantStrings.ErrorString.general
        case .mobile:
            return ConstantStrings.ErrorString.general
        }
    }
}

//
//class MoozyTextField:UIView, UITextFieldDelegate{
//    
//    var placeHolder: String
//    var isSecured: Bool
//    var lblError: UILabel?
//    var textField: UITextField?
//    var icon: UIImage?
//    var keyBoardType: UIKeyboardType = .default
//    var textInputType: TextInputType?
//    var cornerRadius: CGFloat?
//    
//    var error: String = ""{
//        didSet{
//            lblError?.text = error
////            textField?.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius!, error == "" ? #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3607843137, alpha: 1) : #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3607843137, alpha: 1)
//        }
//    }
//    
//    var text: String = ""
//    
//    init(icon: UIImage?, placeHolder: String, textInputType: TextInputType = .general, keyBoardType: UIKeyboardType = .default, isSecured: Bool = false, cornerRadius: CGFloat? = 5, frame: CGRect = .zero) {
//        self.placeHolder = placeHolder
//        self.isSecured = isSecured
//        self.icon = icon
//        self.cornerRadius = cornerRadius
//        self.textInputType = textInputType
//        self.keyBoardType = keyBoardType
//        super.init(frame: frame)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configureUI(){
//        subviews.forEach({$0.removeFromSuperview()})
//        
//        textField = {
//            let textField = UITextField()
//            textField.placeholder = placeHolder
//            textField.isSecureTextEntry = isSecured
//            textField.keyboardType = keyBoardType
//            textField.autocapitalizationType = .none
////            textField.isEnabled = true
//            textField.resignFirstResponder()
//            
//            textField.autocorrectionType = .no
//            textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
//            textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
//            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.font(.Poppins, type: .Regular, size: 17)])
//            
//            textField.font = UIFont.font(.Poppins, type: .Regular, size: 17)
//            
//            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: frame.size.height))
//            let leftImageView = UIImageView(image: icon!, contentModel: .scaleAspectFit)
//            leftPaddingView.addSubview(leftImageView)
//            leftImageView.anchor(top: leftPaddingView.topAnchor, leading: leftPaddingView.leadingAnchor, bottom: leftPaddingView.bottomAnchor, trailing: leftPaddingView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 18, height: 18))
//            
//            textField.leftView = leftPaddingView
//            textField.leftViewMode = .always
//            
//            if isSecured{
//                let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
//                let rightImageView = UIImageView(image: UIImage(systemName: "eye.slash")!, contentModel: .scaleAspectFit)
//                rightPaddingView.addSubview(rightImageView)
//                rightImageView.anchor(top: rightPaddingView.topAnchor, leading: rightPaddingView.leadingAnchor, bottom: rightPaddingView.bottomAnchor, trailing: rightPaddingView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 18, height: 18))
//                textField.rightView = rightPaddingView
//                textField.rightViewMode = .always
//                
//                rightImageView.setImageColor(color: AppColors.primaryColor)
//                
//                rightImageView.addTapGesture(tagId: 0) { (action) in
//                    if
//                        textField.isSecureTextEntry{
//                        textField.isSecureTextEntry = false
//                        
//                        rightImageView.image = UIImage(systemName: "eye")
//                    }
//                    else{
//                        
//                        textField.isSecureTextEntry = true
//                        
//                        rightImageView.image = UIImage(systemName: "eye.slash")
//                    }
//                }
//                
//            }else{
//                let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
//                textField.rightView = rightPaddingView
//                textField.rightViewMode = .always
//            }
//            
//            
//            
//            textField.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius!, error == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), 1)
//            textField.backgroundColor = .white
//            
//            leftImageView.setImageColor(color: AppColors.primaryColor)
//            return textField
//        }()
//        
//        textField?.delegate = self
//        
//        self.layer.cornerRadius = cornerRadius!
//        
//        lblError = UILabel(title: error, fontColor: .red, alignment: .right, font: UIFont.font(.Poppins, type: .Regular, size: 11))
//        
//        addMultipleSubViews(views: textField!, lblError!)
//        
//        textField?.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 4, right: 0))
//        
//        lblError?.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: -10, left: 0, bottom: 0, right: 4))
//        
//        textField?.addTarget(self, action: #selector(onEditing(_:)), for: .editingChanged)
//    }
//    
//    @objc func onEditing(_ textField: UITextField){
//        self.error = ""
//        self.text = textField.text!
//    }
//    
//    
//    func isValidForRegex() -> Bool {
//        if textField?.text?.isValid(for: textInputType!.getRegex()) ?? false {
//            lblError?.text = ""
//            return true
//        } else {
//            lblError?.numberOfLines = 0
//            lblError?.text = textInputType?.getErrorString()
//            return false
//        }
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        textField.resignFirstResponder()
//        return false
//    }
//}



class SearchTextField: UIView, UITextFieldDelegate{
    
    var textField: UITextField?
    var placeholder: String
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    var onChanged: onChangedValue<String>
    var font = UIFont.font(.Poppins, type: .Regular, size: 14)
    
    var placeHolder: String?{
        didSet{
            textField?.placeholder = placeHolder ?? ""
        }
    }
    
    var text: String = "" {
        didSet{
            textField?.text = text
        }
    }
    
    init(placeholder: String, cornerRadius: CGFloat = 5.0, borderWidth: CGFloat = 1.0, frame: CGRect = .zero, onChangedValue: @escaping onChangedValue<String>) {
        self.placeholder = placeholder
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.onChanged = onChangedValue
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        textField = {
            let textField = UITextField()
            textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textField.font = font
            textField.autocorrectionType = .no
            textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
            textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: font!])
            
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
            textField.leftView = leftPaddingView
            textField.leftViewMode = .always
            
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
            textField.rightView = rightPaddingView
            textField.rightViewMode = .always
            
            textField.roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadius, borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), borderWidth: borderWidth)
            return textField
        }()
        
        let imgSearchView : UIView = {
            let img = UIImageView(image: #imageLiteral(resourceName: "icon_Search"))
            let view = UIView(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            view.roundCorners(corners: [.topRight, .bottomRight], radius: cornerRadius, borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), borderWidth: borderWidth)
            view.addSubview(img)
            img.centerSuperView(size: .init(width: 18, height: 18))
            return view
        }()
        
        let stack = UIStackView(views: [textField!, imgSearchView], axis: .horizontal)
        
        addMultipleSubViews(views: stack)
        imgSearchView.constraintsWidhHeight(size: .init(width: 35, height: 0))
        stack.fillSuperView()
        
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(onChangedValue(_:)), for: .editingChanged)
    }
    
    @objc func onChangedValue(_ textField: UITextField){
        onChanged(textField.text!)
    }
}



class chatTextField: UIView, UITextFieldDelegate{
    
    var title: String
    var placeHolder: String
    var lblError: UILabel?
    var textField: UITextField?
    var lblTitle: UILabel?
    var isValid: Bool?
    var lblStar: UILabel?
    
    var error: String = ""{
        didSet{
            configureUI()
        }
    }
    
    init(title:String, placeHolder: String, isValidator: Bool? = false, frame: CGRect = .zero) {
        self.title = title
        self.placeHolder = placeHolder
        self.isValid = isValidator
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        subviews.forEach({$0.removeFromSuperview()})
        if isValid == true{
            lblStar = UILabel(title: "*", fontColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), font: UIFont.font(.Poppins, type: .Bold, size: 18))
        }else{
            lblStar = UILabel(title: "*", fontColor: .clear, font: UIFont.font(.Poppins, type: .Bold, size: 18))
        }
        lblTitle = UILabel(title: title, fontColor: .black, font: UIFont.font(.Poppins, type: .Bold, size: 14))
        textField = {
            let textField = UITextField()
            textField.placeholder = placeHolder
            
            textField.autocorrectionType = .no
            textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
            textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.font(.Poppins, type: .Regular, size: 14)])
            textField.font = UIFont.font(.Poppins, type: .Regular, size: 14)
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
            textField.leftView = leftPaddingView
            textField.leftViewMode = .always
            
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
            textField.rightView = rightPaddingView
            textField.rightViewMode = .always
            
            textField.roundCorners(radius: 5, borderColor: error == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), borderWidth: 1)
            
            return textField
        }()
        lblError = UILabel(title: error, fontColor: .red, alignment: .right, font: UIFont.font(.Poppins, type: .Regular, size: 11))
        
        addMultipleSubViews(views: lblTitle!, lblStar!, textField!, lblError!)
        
        lblStar?.anchor(top: topAnchor, leading: lblTitle?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: -3, left: 0, bottom: 0, right: 0))
        
        lblTitle?.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
        textField?.anchor(top: lblTitle?.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 4, right: 0), size: .init(width: 0, height: 35))
        lblError?.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4))
    }
}


extension UITextField{
    
    convenience init(
        foregroundColor: UIColor = #colorLiteral(red: 0.8078431373, green: 0.831372549, blue: 0.8549019608, alpha: 1),
        font: UIFont = .systemFont(ofSize: 12, weight: .bold),
        backgroundColor: UIColor = UIColor.clear,
        textAligmet : NSTextAlignment,
        cornerradius : Float,
        bordercolor : CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        borderwidth : Float,
        placeHolder : String
        
    )
    
    {
        self.init()
        self.font = font
        self.backgroundColor = backgroundColor
        self.textAlignment = textAligmet
        self.textColor = foregroundColor
        self.layer.cornerRadius = CGFloat(cornerradius)
        self.layer.borderColor = bordercolor
        self.layer.borderWidth = CGFloat(borderwidth)
        // self.placeholder = placeholdertext
        
        self.autocorrectionType = .no
        self.inputAssistantItem.leadingBarButtonGroups.removeAll()
        
        self.inputAssistantItem.trailingBarButtonGroups.removeAll()
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.font(.Poppins, type: .Regular, size: 12)])
        self.font = UIFont.font(.Poppins, type: .Regular, size: 12)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: frame.size.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0.2862745098, green: 0.3137254902, blue: 0.3411764706, alpha: 1)
        self.layer.borderWidth = 1
        
    }
    
}

extension String{
    func isValid(for regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
