//
//  validator.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 08/09/2022.
//


import Foundation
import UIKit
import SwiftUI

enum Regex {
    case email, name, password, phone, usStates, securityCode, number, website, FloatNumber
    case custom(regex: String)
    private func get() -> String {
        switch self {
        case .name:
            return "^[^ ][a-zA-Z ’'.-]{1,20}"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case .password:
            return ".{8,}"
        //return "^(?=.*[A-Za-z])(?=.*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~])(?=.*[0-9]).{8,}$"
        case .phone:
            return "^((\\+)|(00))[0-9]{6,14}$"
        case .usStates:
            return "^(?:(A[AEKLPRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|P[AR]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY]))$"
        case .securityCode:
            return "^[0-9]{3,4}$"
        case .custom(regex: let reg):
            return reg
        case .number:
            return "^[0-9]+(?:[.,][0-9]+)*$"
         
        case .website:
            return "^((https?|ftp|smtp):\\/\\/)?[a-zA-Z0-9]+(\\.[a-zA-Z]{2,}){1,3}(#?\\/?[a-zA-Z0-9#]+)*\\/?(\\?[a-zA-Z0-9-_]+=[a-zA-Z0-9-%]+&?)?$"
        case .FloatNumber:
            return ""
            
        }
    }
    func check(string: String) -> Bool {
        let tester = NSPredicate(format:"SELF MATCHES %@", get())
        return tester.evaluate(with: string)
    }
}


enum Validations {
    case regex(Regex)
    case maxLength(Int)
    case minLength(Int)
    case matches(MoozyTextField)
    case notMatchesTo(UITextField)
    case expiration
    case creditCard
    case notEmpty
    case phoneNumber
    
    func checkRule(on textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        switch self {
        case .regex(let reg):
            return reg.check(string: text)
        case .maxLength(let max):
            return max >= text.count
        case .minLength(let min):
            return min <= text.count
        case .matches(let matchText):
            return textField.text == matchText.text
        case .notMatchesTo(let matchText):
            return textField.text != matchText.text
        case .creditCard:
            return text.count > 16
        case .expiration:
            return text.count > 4
        case .notEmpty:
            return textField.text != ""
        case .phoneNumber:
            return text.count > 13
       
        }
    }
    func getMaxLength() -> Int? {
        switch self {
        case .maxLength(let max):
            return max
        default:
            return nil
        }
    }
    func isExpiration() -> Bool {
        switch self {
        case .expiration:
            return true
        default:
            return false;
        }
    }
    func isCreditCard() -> Bool {
        switch self {
        case .creditCard:
            return true
        default:
            return false;
        }
    }
    func isPhoneNumber() -> Bool {
        switch self {
        case .phoneNumber:
            return true
        default:
            return false;
        }
    }
}


typealias SuccessEvent = (Bool) -> Void

class Validator: NSObject, UITextFieldDelegate {
    
    private var validationObjects: [ValidationObject]
    //var selectedTextField: UITextField
    private var selectedIndex: Int = 0
    private var view: UIView
    
    init(withView: UIView) {
        view = withView
        validationObjects = []
    }
    
    func add(textField: MoozyTextField, rules: [Validations]) {
        validationObjects.last?.textField.textField?.returnKeyType = .next
        validationObjects.append(ValidationObject(textField: textField, rules: rules))
        textField.textField?.delegate = self
        textField.textField?.returnKeyType = .done
      
        textField.textField?.addTarget(self, action: #selector(editingBegin(_:)), for: .editingDidBegin)
    }
    
    func validateNow(valid: SuccessEvent? = nil) {
        valid?(checkValidation())
    }
    
    func removeRules(textField: MoozyTextField) {
        for validationObject in validationObjects {
            if textField == validationObject.textField {
                validationObject.rules = []
            }
        }
    }
    
    func addRules(textField: MoozyTextField, rules: [Validations]) {
        for validationObject in validationObjects {
            if textField == validationObject.textField {
                validationObject.rules = rules
            }
        }
    }
    
    func validate() {
//        validationChanged?(valid)
    }
    
    private func checkValidation() -> Bool {
        var valid: Bool = true
        for validationObject in validationObjects {
            if validationObject.isValid() == false {
                valid = false
            }
        }
        return valid
    }
    
    @objc func editingBegin(_ textField: MoozyTextField) {
        for i in 0 ..< validationObjects.count {
            if validationObjects[i].textField == textField {
                selectedIndex = i
            }
        }
    }
    
    func getSelectedTextField() -> MoozyTextField {
        return validationObjects[selectedIndex].textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if selectedIndex == validationObjects.count - 1 {
            view.endEditing(true)
        } else {
            validationObjects[selectedIndex + 1].textField.becomeFirstResponder()
        }
        return true
    }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newLength: Int = (textField.text?.count ?? 0) + string.count - range.length
            let selectedObject = validationObjects[selectedIndex]
    
            if selectedObject.hasExpirationRule() {
                let oldText = selectedObject.textField.textField?.text ?? ""
                return expirationCheck(oldText: oldText, newText: string, newLength: newLength)
            }
    
            if selectedObject.hasCreditCardRule() {
                return newLength < 24
            }
    
            if let maxLength = selectedObject.getMaxLength() {
                return maxLength >= newLength
            }
            return true
        }
    
    func expirationCheck(oldText: String, newText: String, newLength: Int) -> Bool {
        let oldLength: Int = oldText.count
        if newText == "" {
        } else if oldLength == 0 {
            
            return "01".contains(newText)
            
        } else if oldLength == 1 {
            if oldText == "0" {
                return "123456789".contains(newText)
            } else {
                return "012".contains(newText)
            }
        }
        return newLength < 6
    }
    
    func formatExp(string: String) -> String {
        var newString = string.replacingOccurrences(of: "/", with: "")
        if newString.count > 2 {
            newString.insert("/", at: newString.index(newString.startIndex, offsetBy: 2) )
        }
        return newString
    }
    
    func formatPhoneNumber(_ string: String) -> String {
        if string.count == 0 {
            return ""
        }
        let newString: String = (string as NSString).replacingCharacters(in: (string as NSString).range(of: string), with: string)
        let components: [Any] = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let decimalString: String = (components as NSArray).componentsJoined(by: "")
        let length: Int = decimalString.count
        var index: Int = 0
        var formattedString = String()
        if length - index > 3 {
            let areaCode: String = (decimalString as NSString).substring(with: NSRange(location: index, length: 3))
            formattedString += "(\(areaCode))"
            index += 3
        }
        if length - index > 3 {
            let prefix: String = (decimalString as NSString).substring(with: NSRange(location: index, length: 3))
            formattedString += " \(prefix) - "
            index += 3
        }
        let remainder = decimalString.substring(from: decimalString.index(decimalString.startIndex, offsetBy: index))
        formattedString.append(remainder)
        return formattedString
    }
}



typealias EmptyEvent = () -> ()

class ValidationObject {
    var textField: MoozyTextField
    var rules: [Validations]
    
    init(textField txt: MoozyTextField, rules rul: [Validations]) {
        textField = txt
        rules = rul
    }
    
    func isValid() -> Bool {
        
        if rules.count == 0 {
            textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return true
        }
        
        for rule in rules {
            let valid = rule.checkRule(on: textField.textField!)
            if !valid {
                textField.error = "."
             
                textField.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                return false
            }
        }
        
        textField.textField?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.lblError?.isHidden = true
        return true
    }
    
    func getMaxLength() -> Int? {
        for rule in rules {
            if let length = rule.getMaxLength() {
                return length
            }
        }
        return nil
    }
    
    func hasExpirationRule() -> Bool {
        return rules.contains { $0.isExpiration() }
    }
    
    func hasCreditCardRule() -> Bool {
        return rules.contains { $0.isCreditCard() }
    }
    
    func hasPhoneNumberRule() -> Bool {
        return rules.contains { $0.isPhoneNumber() }
    }
}




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
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.font(.Poppins, type: .Regular, size: 17)])
            
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
