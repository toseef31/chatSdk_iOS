//
//  validator.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 08/09/2022.
//


import Foundation
import UIKit
import SwiftUI

class MoozyTextField:UIView, UITextFieldDelegate {
    
    var placeHolder: String
    var isSecured: Bool
    var lblError: UILabel?
    var textField: UITextField?
    var icon: UIImage?
    var keyBoardType: UIKeyboardType = .default
    var textInputType: TextInputType?
    var cornerRadius: CGFloat?
    var isValid: Bool?
    
    var error: String = ""{
        didSet{
            lblError?.text = error
            textField?.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    var text: String = ""
    
    init(icon: UIImage?, placeHolder: String, textInputType: TextInputType = .general, keyBoardType: UIKeyboardType = .default, isSecured: Bool = false, isValidator: Bool? = false , cornerRadius: CGFloat? = 5, frame: CGRect = .zero) {
        self.placeHolder = placeHolder
        self.isSecured = isSecured
        self.icon = icon
        self.isValid = isValidator
        self.cornerRadius = cornerRadius
        self.textInputType = textInputType
        self.keyBoardType = keyBoardType
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        subviews.forEach({$0.removeFromSuperview()})
        
        textField = {
            let textField = UITextField()
            textField.placeholder = placeHolder
            textField.isSecureTextEntry = isSecured
            textField.keyboardType = keyBoardType
            textField.autocapitalizationType = .none
//            textField.isEnabled = true
            textField.resignFirstResponder()
            
            textField.autocorrectionType = .no
            textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
            textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.font(.Roboto, type: .Medium, size: 17)])
            
            textField.font = UIFont.font(.Poppins, type: .Regular, size: 17)
            
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: frame.size.height))
            let leftImageView = UIImageView(image: icon!, contentModel: .scaleAspectFit)
            leftPaddingView.addSubview(leftImageView)
            leftImageView.anchor(top: leftPaddingView.topAnchor, leading: leftPaddingView.leadingAnchor, bottom: leftPaddingView.bottomAnchor, trailing: leftPaddingView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 18, height: 18))
            
            textField.leftView = leftPaddingView
            textField.leftViewMode = .always
            
            if isSecured{
                let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
                let rightImageView = UIImageView(image: UIImage(systemName: "eye.slash")!, contentModel: .scaleAspectFit)
                rightPaddingView.addSubview(rightImageView)
                rightImageView.anchor(top: rightPaddingView.topAnchor, leading: rightPaddingView.leadingAnchor, bottom: rightPaddingView.bottomAnchor, trailing: rightPaddingView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 18, height: 18))
                textField.rightView = rightPaddingView
                textField.rightViewMode = .always
                
                rightImageView.setImageColor(color: AppColors.primaryColor)
                
                rightImageView.addTapGesture(tagId: 0) { (action) in
                    if
                        textField.isSecureTextEntry{
                        textField.isSecureTextEntry = false
                        
                        rightImageView.image = UIImage(systemName: "eye")
                    }
                    else{
                        
                        textField.isSecureTextEntry = true
                        
                        rightImageView.image = UIImage(systemName: "eye.slash")
                    }
                }
                
            }else{
                let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
                textField.rightView = rightPaddingView
                textField.rightViewMode = .always
            }
            
            
            
            textField.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius!, error == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), 1)
            textField.backgroundColor = .white
            
            leftImageView.setImageColor(color: AppColors.primaryColor)
            return textField
        }()
        
        textField?.delegate = self
        
        self.layer.cornerRadius = cornerRadius!
        
        lblError = UILabel(title: error, fontColor: .red, alignment: .right, font: UIFont.font(.Poppins, type: .Regular, size: 11))
        
        addMultipleSubViews(views: textField!, lblError!)
        
        textField?.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 4, right: 0))
        
        lblError?.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: -10, left: 0, bottom: 0, right: 4))
        
        textField?.addTarget(self, action: #selector(onEditing(_:)), for: .editingChanged)
    }
    
    @objc func onEditing(_ textField: UITextField){
        self.error = ""
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.text = textField.text!
    }
    
    
    func isValidForRegex() -> Bool {
        if textField?.text?.isValid(for: textInputType!.getRegex()) ?? false {
            lblError?.text = ""
            return true
        } else {
            lblError?.numberOfLines = 0
            lblError?.text = textInputType?.getErrorString()
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
}
